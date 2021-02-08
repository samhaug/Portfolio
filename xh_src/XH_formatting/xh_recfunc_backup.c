// xh_recfunc - deconvolves Z from R to attain the receiver function
// It is assumed that the XH file contains 3 records per stations
// grouped together, and in the order Z,R,T ... !!!
// The receiver function is written as an XH record for now:
// with chan = "RCF" and
// with chid = 0
// but it will eventually need a different format

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "/home/jeroen/inc/xhhead.h"
#include "/home/jeroen/inc/Complex.h"
#include "/home/jeroen/inc/time.h"

#define NZREC 200
#define NSAMP 2048

main( argc, argv )
int   argc;
char       *argv[];
{
    float     data[XH_NPTS];
    xhhed     h;

    // float     seism_z[NZREC][NSAMP]; // Z
    // float     seism_r[NZREC][NSAMP]; // R
    // float     seism_t[NZREC][NSAMP]; // T
    // float     seism_f[NZREC][NSAMP]; // Z (filtered)
    float     **seism_z; // Z
    float     **seism_r; // R
    float     **seism_t; // T
    float     **seism_f; // Z (filtered)

    float     rcf[NSAMP];		// receiver function
    float     stf[NSAMP];		// source time function
    float     mccc[NZREC][NZREC];       // matrix of differential traveltimes
    float     dum[NSAMP];               // dummy record

    float     dt;			// delta t

    // headers:
    xhhed     h_z[NZREC]; // Z
    xhhed     h_r[NZREC]; // R
    xhhed     h_t[NZREC]; // T
    xhhed     h_f; //receiver function

    int       still_reading_data=1;
    int       z_found=0;
    int       r_found=0;
    int       t_found=0;
    int       numSTAT=0;

    int       if1 =   10;	// bandpass frequencies
    int       if2 =   20;
    int       if3 =  300;
    int       if4 =  500;

    int       min_qual=2, max_qual=4;

    int       iP;		// sample of IASP91 P time;
    int       i_15s, i_120s, its;
    int       npts_xcor;	// # of samples in Xcor window (= i_15s+i_120s)
    int       icount=0;
    int	      i, j, k, ierr;
    float     wl=0.; 		// waterlevel
    float     t1,t2;		// receiver function window (sec)
    float     deg2rad;		// pi/180   

    FILE     *ifl, *ofl, *fopen();

    int usage();

deg2rad=4.*atan(1.)/180.;

// memory allocation
seism_z = (float **)calloc(NZREC, sizeof(float *));
seism_r = (float **)calloc(NZREC, sizeof(float *));
seism_t = (float **)calloc(NZREC, sizeof(float *));
seism_f = (float **)calloc(NZREC, sizeof(float *));

for(j=0;j<NZREC;j++) {
  seism_z[j] = (float *)calloc(NSAMP, sizeof(float));
  seism_r[j] = (float *)calloc(NSAMP, sizeof(float));
  seism_t[j] = (float *)calloc(NSAMP, sizeof(float));
  seism_f[j] = (float *)calloc(NSAMP, sizeof(float));
}


if(argc != 8) {
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
if (strncmp(argv[3],"-q",2) != 0) {
     ierr=usage();
     exit(-1);
}
if (strncmp(argv[6],"-w",2) != 0) {
     ierr=usage();
     exit(-1);
} else {
  sscanf(argv[4],"%d", &min_qual);
  sscanf(argv[5],"%d", &max_qual);
  sscanf(argv[7],"%f", &wl);
}
fprintf(stdout,"quality factor range= %d %d\n",min_qual, max_qual);
fprintf(stdout,"a1 wl= %f\n",wl);

// Loop over traces on stdin
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     still_reading_data=0;
     break;
  } else {
     if (! xh_readdata(ifl,h,data)) {
       still_reading_data=0;
       exit(-1);
     }
     if (h.qual < min_qual || h.qual > max_qual) continue;
     // check header
     if (! xh_checkheader(h) )
       exit(-1);
     if (numSTAT == 0 && icount == 0) {
       // this is the first record (presumably Z!!)
       // define some variables 
       dt = h.delta;
       i_15s  = lrint(15./dt);
       i_120s = lrint(120./dt);
       npts_xcor = i_15s+i_120s;
       if( npts_xcor > NSAMP) {
        fprintf(stderr,"Number of Xcorr samples exceeds NSAMP [=%d]\n", NSAMP);
        exit(-1);
       }
       fprintf(stdout,"Working with= %d samples dt=%f\n", npts_xcor,dt); 
     }
     icount=icount+1;
     if (h.delta != dt) {
      fprintf(stderr,"Inconsistent sampling time %s %s\n", h.stnm, h.chan);
      exit(-1);
     }
     if (h.tpcks[0] <= 0.) {
       fprintf(stderr,"P time not valid %s %s\n", h.stnm,h.chan);
       exit(-1);
     }
     iP = lrint( (h.tpcks[0])/dt );

     // Z record
     // (should be the first record for this station !!)
     if        (icount == 1) {
         if (h.chid != 1) {
           fprintf(stderr,"Record order ZRT not correct: %s\n", h.stnm);
           exit(-1);
         }
         z_found=1;
         // traveltime from IASP91 tables
         h_z[numSTAT]       = h;         
         h_z[numSTAT].ndata = npts_xcor;
         // put [P-i_15s,P+i_120s] of DATA into seism_z
         for( i=iP-i_15s; i<iP+i_120s; i++) {
            k = i-iP+i_15s;
            seism_z[numSTAT][k] = data[i];
         }
     // R record
     // (should be the second record for this station !!)
     } else if (icount == 2) {
         if (h.chid != 4) {
           fprintf(stderr,"Record order ZRT not correct: %s\n", h.stnm);
           exit(-1);
         }
         r_found=1;
         // traveltime from IASP91 tables
         h_r[numSTAT]       = h;         
         h_r[numSTAT].ndata = npts_xcor;
         // put [P-i_15s,P+i_120s] of DATA into seism_r
         for( i=iP-i_15s; i<iP+i_120s; i++) {
            k = i-iP+i_15s;
            seism_r[numSTAT][k] = data[i];
         }
     // T record
     // (should be the third record for this station !!)
     // For now, the T record is not used in the receiver function analysis
     } else if (icount == 3) {
         if (h.chid != 5) {
           fprintf(stderr,"Record order ZRT not correct: %s\n", h.stnm);
           exit(-1);
         }
         t_found=1;
         // traveltime from IASP91 tables
         h_t[numSTAT]       = h;         
         h_t[numSTAT].ndata = npts_xcor;
         // put [P-i_15s,P+i_120s] of DATA into seism_r
         for( i=iP-i_15s; i<iP+i_120s; i++) {
            k = i-iP+i_15s;
            seism_t[numSTAT][k] = data[i];
         }
     }
     fprintf(stdout,"CMT: %s", h.cmtcd);
     fprintf(stdout," numSTAT=%d %-4s %-2s %-3s    P-time= %8.2f\n", 
          numSTAT,h.stnm,h.netw,h.chan,h.tpcks[0]);

     if (icount==3) {
       if (z_found && r_found && t_found) {
         icount=0;
         numSTAT++;
         if (numSTAT == (NZREC-1)) {
           fprintf(stderr,"Number of Z records exceeds NZREC [=%d]\n", NZREC);
           exit(-1);
         }
       } else {
         fprintf(stderr,"Read error for station %s ...\n", h.stnm);
         fprintf(stderr,"icount= %d ...\n", icount);
         return(-1);
       }
     }
  }
} // while

// all records ave been retrieved.
// apply a low pass filter to seism_z
// and put filtered records in seism_f
fprintf(stdout,"Filtering ...\n");
for(i=0;i<numSTAT;i++) {
  if (! bpfilter(if1,if2,if3,if4,NSAMP,dt,seism_z[i],seism_f[i]) )
    exit(-1);
}
// using the filtered records (seism_f) we
// determine the best time shifts that give
// the best alignment of the filtered P waves
// with multi-channel cross-correlation
// (see VanDecar and Crosson [BSSA, 1990])
                                                                      
fprintf(stdout,"Cross-correlations ...\n");
// determine the cross-correlations
for (i=0;i<numSTAT;i++) {
  for (k=i+1;k<numSTAT;k++) {
    if (! crosscor(seism_f[i],seism_f[k],npts_xcor,dt,&mccc[i][k]) )
      exit(-1);
  }
}
fprintf(stdout,"LSQR ...\n");
// least-squares solution for the time shifts
for (i=0;i<numSTAT;i++) {
  h_z[i].tshift = 0.;
  for (k=i+1; k<numSTAT;k++)
    h_z[i].tshift = h_z[i].tshift + mccc[i][k];
  for (k=0; k<i;k++)
    h_z[i].tshift = h_z[i].tshift - mccc[k][i];
  h_z[i].tshift = h_z[i].tshift/numSTAT;
  fprintf(stdout,"MCCC %d %s  dt= %f\n",i,h_z[i].stnm,h_z[i].tshift);
}

// shift the records by TSHIFT
for(i=0;i<numSTAT;i++) {
  its = lrint(h_z[i].tshift/dt);
  fprintf(stdout,"SHIFTING: %s nsamp= %d its= %d shift= %f\n",
        h_z[i].stnm,h_z[i].ndata,its,h_z[i].tshift);

  // shift Z
  for (k=0; k<h_z[i].ndata; k++)
    dum[k] = seism_z[i][k];
  for (k=0; k<h_z[i].ndata; k++) {
    if ( (k-its) < 0 || (k-its) >= h_z[i].ndata ) {
       seism_z[i][k] = 0.;
    } else {
      seism_z[i][k] = dum[k-its];
    }
    // source-time function is the
    // average of the aligned Z records
    stf[k] = stf[k]+seism_z[i][k]/numSTAT;
  }
  // shift R
  for (k=0; k<h_r[i].ndata; k++)
    dum[k] = seism_r[i][k];
  for (k=0; k<h_r[i].ndata; k++) {
    if ( (k-its) < 0 || (k-its) >= h_r[i].ndata ) {
       seism_r[i][k] = 0.;
    } else {
      seism_r[i][k] = dum[k-its];
    }
  }
}
// deconvolution
// (see Zu and Kanamori, J. Geophys. Res. 105, 2969-2980, 2000)
for(i=0;i<numSTAT;i++) {
  fprintf(stdout,"Record number= %d stat= %s\n", i, h_z[i].stnm);
  if (! deconvolve(seism_r[i],stf,rcf,20.,wl,dt,npts_xcor))
     exit(-1);
  // WRITE XH header and data
  h_z[i].tpcks[0] = -999.;
  strncpy(h_z[i].chan,"RCF",3);
  h_z[i].chid = 0;
  if (! xh_writehead(ofl,h_z[i]))
    exit(-1);
  if (! xh_writedata(ofl,h_z[i],rcf))
    exit(-1);
}

strncpy(h_z[0].stnm,"PWAV",4);
strncpy(h_z[0].chan,"STF",3);
// WRITE SOURCE TIME FUNCTION
fprintf(stdout,"STF number of samples= %d\n", h_z[0].ndata);
if (! xh_writehead(ofl,h_z[0]))
  exit(-1);
if (! xh_writedata(ofl,h_z[0],stf))
  exit(-1);


fclose(ifl);
fclose(ofl);
exit( 0 );
}

int usage()
{
fprintf(stderr,"Usage: xh_recfunc in_XH out_XH -q min_QUAL max_QUAL -w waterlevel \n");
return(-1);
}
