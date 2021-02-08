// xh_Ptraveltime - calculates relative arrival times
// of teleseismic P waves recorded by an array
// It is assumed that the XH file contains Z records (chid = 1)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "Complex.h"

#define NZREC 200
#define NSAMP 2048

main( argc, argv )
int   argc;
char       *argv[];
{
    float     data[XH_NPTS];
    xhhed     h;
    xhhed     h_z[NZREC];

    // float     seism_z[NZREC][NSAMP]; // Z
    // float     seism_f[NZREC][NSAMP]; // Z (filtered)
    float     **seism_z; // Z
    float     **seism_f; // Z (filtered)

    float     rcf[NSAMP];		// receiver function
    float     mccc[NZREC][NZREC];       // matrix of differential traveltimes

    float     dt;			// Delta t (sampling interval)
    float     Evlat, Evlon;		// Event Latitude and longitude
    float     delta,az,baz;             // GreatCircle distance, Azimuth, BackAzi
    char      Evcode[NCMT];		// CMT code
    char      region[23];               // CMT event region

    float     ArvTime[NZREC];           // array with relative arrival times
    float     Ptime;                    // IASP traveltime
    float     xcorrwin;

    int       still_reading_data=1;
    int       z_found=0;
    int       numSTAT=0;

    int       if1 =    7;	// bandpass frequencies
    int       if2 =   10;
    int       if3 =  125;
    int       if4 =  200;

    int       iP;		// sample of IASP91 P time;
    int       i_15s, i_25s;
    int       npts_xcor;	// # of samples in Xcor window (= i_15s+i_25s)
    int	      i, j, k, ierr, index;

    FILE     *ifl, *log, *fopen();

    int usage();

// memory allocation
seism_z = (float **)calloc(NZREC, sizeof(float *));
seism_f = (float **)calloc(NZREC, sizeof(float *));

for(j=0;j<NZREC;j++) {
  seism_z[j] = (float *)calloc(NSAMP, sizeof(float));
  seism_f[j] = (float *)calloc(NSAMP, sizeof(float));
}

// command line input
// First argument is the XH data file
index = 1;
if ((ifl=fopen(argv[index],"r")) == NULL) {
     ierr=usage();
     exit(-1);
}
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
    case 'w':
      if ( sscanf(argv[++index],"%f",&xcorrwin ) != 1) {
        fprintf(stderr,"ERROR reading value for Xcorr window: %f\n", xcorrwin);
        exit(-1);
      }
      break;
    default:
      ierr = usage();
      exit(-1);
  }
}

// Log file
if ((log=fopen("xh_Ptraveltime.log","w")) == NULL) {
     ierr=usage();
     exit(-1);
}

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
     // check header
     if (! xh_checkheader(h) )
       exit(-1);
     if (numSTAT == 0) {
       // this is the first record 
       // We record variables, and check later
       // whether they are the same for all records 
       dt = h.delta;
       Evlat = h.elat;
       Evlon = h.elon;
       sprintf(Evcode,"%s",h.cmtcd);
       i_15s  = lrint(15./dt);
       i_25s = lrint(25./dt);
       npts_xcor = i_15s+i_25s;
       if( npts_xcor > NSAMP) {
        fprintf(stderr,"Number of Xcorr samples exceeds NSAMP [=%d]\n", NSAMP);
        exit(-1);
       }
       fprintf(log,"Working with= %d samples dt=%f\n", npts_xcor,dt); 
     }

     // ------------------------------ Checks -----------------
     // Check if it is a Z record
     if (h.chid != 1) {
         fprintf(stderr,"Record order ZRT not correct: %s\n", h.stnm);
           exit(-1);
     }
     // Check consistency in dT
     if (h.delta != dt) {
      fprintf(stderr,"Inconsistent sampling time %s %s\n", h.stnm, h.chan);
      fprintf(stderr,"Dt= %f and expected to be: %f\n", h.delta, dt);
      exit(-1);
     }
     // Check consistency in Event Code
     if (strncmp(h.cmtcd,Evcode,7)) {
      fprintf(stderr,"Inconsistent Event code %s %s\n", h.stnm, h.chan);
      fprintf(stderr,"Event code= %s and expected to be: %s\n", h.cmtcd, Evcode);
      exit(-1);
     }
     // Check consistency in Event location
     if ( fabs(h.elat-Evlat) > 0.001 || fabs(h.elon-Evlon) > 0.001) {
      fprintf(stderr,"Inconsistent Event epicenter %s %s\n", h.stnm, h.chan);
      fprintf(stderr,"Event lat= %f lon= %f\n", h.elat, h.elon);
      fprintf(stderr,"and expected to be lat= %f lon= %f\n", Evlat, Evlon);
      exit(-1);
     }
     // Check if P time is recorded
     if (h.tpcks[0] <= 0.) {
       fprintf(stderr,"P time [= %f ] not valid %s %s\n", h.tpcks[0], h.stnm,h.chan);
       exit(-1);
     }
     // -------------------------------------------------------
     // sample where P is predicted to arrive (for IASP91)
     iP = lrint( (h.tpcks[0])/dt );

     h_z[numSTAT] = h;
     // put [P-i_15s,P+i_25s] of DATA into seism_z
     for( i=iP-i_15s; i<iP+i_25s; i++) {
        k = i-iP+i_15s;
        seism_z[numSTAT][k] = data[i];
     }
     fprintf(log," numSTAT=%d %-4s %-2s %-3s    P-time= %8.2f\n", 
          numSTAT,h.stnm,h.netw,h.chan,h.tpcks[0]);

     numSTAT++;
     if (numSTAT == (NZREC-1)) {
       fprintf(stderr,"Number of Z records exceeds NZREC [=%d]\n", NZREC);
       exit(-1);
     }
  }
} // all records have been retrieved

if (! get_cmt_region(h.cmtcd,region) ) {
        fprintf(stderr,"Error in get_cmt_region() ... for %s \n", h.cmtcd);
        exit(-1);
}

fprintf(stdout,"CMT: %s", h.cmtcd);
fprintf(stdout,"%7.2f %7.2f %3dkm", h.elat,h.elon,lrint(h.edep));
fprintf(stdout," %-23s",region);
fprintf(stdout," %4d/%02d/%02d %02d:%02d:%04.1f   M=%3.1f\n",
           h.ot.yr,h.ot.mo,h.ot.day,h.ot.hr,h.ot.mn,h.ot.sec,h.Mb);

// apply a low pass filter to seism_z
// and put filtered records in seism_f
// fprintf(stdout,"Filtering ...\n");
for(i=0;i<numSTAT;i++) {
  if (! bpfilter(if1,if2,if3,if4,NSAMP,dt,seism_z[i],seism_f[i]) )
    exit(-1);
}
// using the filtered records (seism_f) we
// determine the best time shifts that give
// the best alignment of the filtered P waves
// with multi-channel cross-correlation
// (see VanDecar and Crosson [BSSA, 1990])
                                                                      
// fprintf(stdout,"Cross-correlations ...\n");
// determine the cross-correlations

for (i=0;i<numSTAT;i++) {
  for (k=i+1;k<numSTAT;k++) {
    if (! crosscor(seism_f[i],seism_f[k],npts_xcor,dt,&mccc[i][k]) )
      exit(-1);
    // reverse sign due to my definition of cross-correlation
    // see crosscor(): 
    mccc[i][k] = -mccc[i][k];
  }
}
// fprintf(stdout,"LSQR ...\n");
// least-squares solution for the time shifts
for (i=0;i<numSTAT;i++) {
  ArvTime[i] = 0.;
  for (k=i+1; k<numSTAT;k++)
    ArvTime[i] = ArvTime[i] + mccc[i][k];
  for (k=0; k<i;k++)
    ArvTime[i] = ArvTime[i] - mccc[k][i];
  ArvTime[i] = ArvTime[i]/numSTAT;

  // Get epicentral distance (delta) and backazimuth (baz)
  if (! distaz(h_z[i].slat,h_z[i].slon,h_z[i].elat,h_z[i].elon,&delta,&az,&baz))
    exit (-1);
  // Get Pwave traveltime for depth and distance from TravelTimeTables
  if (! gettime(h.edep,delta,&Ptime,"P"))
    exit (-1);

  fprintf(stdout,"%3d %2s %-4s %6.2f %7.2f EpD= %6.2f Baz= %5.1f IASP91: %6.1f  dT= %5.2f\n",
     i+1,h_z[i].netw,h_z[i].stnm,h_z[i].slat,h_z[i].slon,delta,baz,Ptime,ArvTime[i]);
}

fclose(ifl);
exit( 0 );
}

int usage()
{
fprintf(stderr,"Usage: xh_Ptraveltime in_XH -w Xcorr_window\n");
return(-1);
}
