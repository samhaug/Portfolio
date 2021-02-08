/* ---------------------------------------------------------
xh_difftstar --
Measures spectral ratios of vertical component record.
It is assumed that the input XH file contains
vertical component (h.chid = 1) broadband seismograms.

The  function is written as an XH record for now:
with chan = "TSTAR" and
with chid = 0
but it may eventually need a different format

Seismogram O(w) = S(w)C(w)A(w) = S(w)C(w) exp{ -0.5 w t*}
                = source x crust x attenuation

t* = \int (1/Q) dT
(dT is the traveltime along a segment of the ray path)
or 
t* = \int ( 1/Q.Vp(t) ) ds
(ds is distance along a segment of the ray path)

w  = 2.pi.f

For station i and j:
ln Rij(w) = -w/2 (t*i - t*j) = -w/2 Dtij*
(equation (2) from Venkatamaran et al., GRL, 31, 2004)
--------------------------------------------------------- */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

#define NZREC 400
#define NSAMP 8192
#define NFFT  8192

main( argc, argv )
int   argc;
char       *argv[];
{
    float     data[XH_NPTS];
    xhhed     h;

    float     Pwave[NZREC][NSAMP];	// P wave segments

    float     lnR[NFFT];		// log of spectral ratios
    float     dt;			// delta t
    float     dw;			// delta omega

    // header for XH file
    xhhed     h_z[NZREC]; // Z
    // header for lnR
    // lnRhed     h_f; //receiver function

    int       still_reading_data=1;
    int       z_found=0;

    // bandpass frequencies: eventually they need to be read from file
    int       if1 =    7;
    int       if2 =   10;
    int       if3 =  300;
    int       if4 =  500;

    int       iP;		// sample of IASP91 predicted P time;
    int       i_t1, i_t2, its;
    int       npts_Pwin;	// # of samples in the window around P for which tstar is estimated (= i_t1+i_t2)
    int       npts_freq;	// # of samples in lnR

    int       i_rec=0;          // record counter
    int	      i, j, k, ierr;

    FILE     *ifl, *ofl, *log, *fopen();

    int usage();


// memory allocation
/*
Pwave = (float **)calloc(NZREC, sizeof(float *));
for(j=0;j<NZREC;j++) {
  Pwave[j] = (float *)calloc(NSAMP, sizeof(float));
}
*/

if(argc < 3) {
  ierr=usage();
  exit(-1);
}
if ((ifl=fopen(argv[1],"r")) == NULL) {
     ierr=usage();
     exit(-1);
}
if ((ofl=fopen(argv[2],"w")) == NULL) {
     ierr=usage();
     exit(-1);
}
// LOG file
if ((log=fopen("xh_difftstar.log","w")) == NULL) {
     fprintf(stderr,"Cannot open xh_difftstar.log\n");
     exit(-1);
}
fprintf(log,"---------------------------------------\n");
fprintf(log,"LOG for xh_difftstar\n");
fprintf(log,"---------------------------------------\n");


// ----------------------------------------------------------------
// Reading XH data
// Place segments of data into Pwave[]
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     still_reading_data=0;
     break;
  } else {
     if (! xh_readdata(ifl,h,data)) {
       still_reading_data=0;
       exit(-1);
     }
     // check header
     if (! xh_checkheader(h) )
       exit(-1);
     // Record should be a vertical component seismogram
     if (h.chid != 1) {
       fprintf(stderr,"Record: %s %s -- chid [=%d] is not 1\n", h.stnm, h.chan, h.chid);
       exit(-1);
     }
     // For the first record we define the default values of key variables 
     if (i_rec == 0) {
       dt = h.delta;
       i_t1  = lrint(2./dt);
       i_t2 = lrint(38./dt);
       npts_Pwin = i_t1+i_t2;
       if( npts_Pwin > NSAMP) {
        fprintf(stderr,"Number of Xcorr samples exceeds NSAMP [=%d]\n", NSAMP);
        exit(-1);
       }
       fprintf(log,"Working with= %d samples dt=%f\n\n", npts_Pwin,dt); 
     }
     if (h.delta != dt) {
      fprintf(stderr,"Inconsistent sampling time %s %s\n", h.stnm, h.chan);
      exit(-1);
     }
     if (h.tpcks[0] <= 0.) {
       fprintf(stderr,"Record: %s %s -- P time [= %f] is not valid\n", h.stnm, h.chan, h.tpcks[0]);
       exit(-1);
     }

     // iP is the sample of the predicted P traveltime [IASP91 tables]
     // see xh_insPtime()
     iP = lrint( (h.tpcks[0])/dt );
     // put [P-i_t1,P+i_t2] of DATA into Pwave
     for( i=iP-i_t1; i<iP+i_t2; i++) {
        k = i-iP+i_t1;
        Pwave[i_rec][k] = data[i];
     }
     // Copy header and modify h_z[i_rec].ndata
     h_z[i_rec]       = h;         
     h_z[i_rec].ndata = npts_Pwin;

     fprintf(log,"CMT: %s", h.cmtcd);
     fprintf(log," i_rec=%d %-4s %-2s %-3s    P-time= %8.2f\n", 
                   i_rec,h.stnm,h.netw,h.chan,h.tpcks[0]);
  }
  i_rec=i_rec+1;
} // all records have been retrieved.
// ----------------------------------------------------------------

// Now do the measurements on the traces stored
// in Pwave for all record pairs [i,j]

for(i=0;i<i_rec;i++) {
  for(j=i+1;j<i_rec;j++) {
    fprintf(log,"Record number= %d stat= %s\n", i, h_z[i].stnm);
    if (! xh_dtstar(Pwave[i],Pwave[j],lnR,dt,npts_Pwin,&dw,&npts_freq))
       exit(-1);
//  for(k=0;k<npts_Pwin;k++) 
//     fprintf(stdout,"%f %e\n", k*dt, Pwave[j][k]);
    for(k=0;k<npts_freq;k++) 
       fprintf(stdout,"%f %e\n", k*dw, lnR[k]);
    /*
    // WRITE XH header and data
    h_z[i].tpcks[0] = -999.;
    strncpy(h_z[i].chan,"RCF",CHARSIZE);
    h_z[i].chid = 0;
    if (! xh_writehead(ofl,h_z[i]))
      exit(-1);
    if (! xh_writedata(ofl,h_z[i],rcf))
      exit(-1);
  */
  }
}


fclose(ifl);
fclose(ofl);
exit( 0 );
}

int usage()
{
fprintf(stderr,"Usage: xh_diffftstar in_XH out_XH\n");
return(-1);
}
