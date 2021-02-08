#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "xhhead.h"		// XH   structures

/* ---------------------------------------------------------
determines for each trace "h.tshift"
to optimize the alignment of P waves.
Assumes:
(-) that the traces been synchronized with xh_synch
(-) that the traces have the same sampling frequency
(-) that h.chid 
--------------------------------------------------------- */

#define NZREC 200
#define NSAMP 3000

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
xhhed 	h_z[NZREC];
int     index;
int 	icount=1;
int 	i,k, ierr;
int     i_t1,i_t2,iP,its;
int     i_rec=0;

int   still_reading_data = 1;
float data[XH_NPTS];
float dt;			// sampling time
float t1 = 5.;
float t2 = 55.;

float seism[NZREC][NSAMP];	// windowed vertical components
float seism_f[NZREC][NSAMP];	// windowed vertical components after filtering
float mccc[NZREC][NZREC];	// matrix of differential traveltimes
float dum[NSAMP];		// dummy record
float stack[NSAMP];		// waveform stack

float difftime;

int if1 =    7;			// bandpass frequencies
int if2 =   10;
int if3 =  200;
int if4 =  333;

int   npts_xcor;		// number of samples in the Xcor window

char infile[80];
FILE *ifl, *ofl, *fopen();

int usage();

// Command line input
if(argc < 3) {
     ierr = usage();
     exit(-1);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(-1);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(-1);
}
index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 't':
        // time window
        if ( sscanf( argv[++index], "%f", &t1 ) != 1) {
             ierr = usage();
        }
        if ( sscanf( argv[++index], "%f", &t2 ) != 1) {
             ierr = usage();
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}


for (k=0; k<NSAMP; k++) stack[k] = 0.;

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(-1);
  } else {
    if (! xh_readdata(ifl,h,data)) {
      still_reading_data = 0;
      exit(-1);
    }
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);
  // only Z component waveforms
  if (h.chid != 1) {
    fprintf(stderr,"Record %s %s -- chid [=%d] != 1 ...\n", h.stnm,h.chan,h.chid);
    exit(-1);
  }
  // Make sure that h.tpcks[0] (= iasp91 P time) is defined
  if (h.tpcks[0] <= 0.) {
    fprintf(stderr,"Record %s %s -- P arrival time [=%f] not valid ...\n", h.stnm,h.chan,h.tpcks[0]);
    exit(-1);
  }
  // define some variables after the first Z record has been read
  if(i_rec==0) {
    dt = h.delta;
    // cross-correlation window around IASP91 predicted
    // P traveltime: [ IASP91-T1, IASP91+T2]
    i_t1 = lrint(t1/dt);
    i_t2 = lrint(t2/dt);
    npts_xcor = i_t1+i_t2;
    if( (npts_xcor)>NSAMP) {
      fprintf(stderr,"Number of Xcorr samples exceeds NSAMP [=%d]\n", NSAMP);
      exit(-1);
    }
  }
  // traveltime from IASP91 tables
  iP = lrint( (h.tpcks[0])/dt );
  if(i_rec>1) { 
    if (h.delta != dt) {
      fprintf(stderr,"Inconsistent DT [=%f] Value for %s/%s = %f\n",
            dt,h.stnm,h.chan,h.delta);
      exit(-1);
    }
  }
  h_z[i_rec]       = h;
  h_z[i_rec].ndata = npts_xcor;
  // put [P-i_t1,P+i_t2] of DATA into seism
  for( i=iP-i_t1; i<iP+i_t2; i++) {
     k = i-iP+i_t1;
     seism[i_rec][k] = data[i];
  }
  i_rec = i_rec+1;
  if (i_rec == (NZREC-1)) {
    fprintf(stderr,"Number of Z records exceeds NZREC [=%d]\n", NZREC);
    exit(-1);
  }
  fprintf(stdout,"CMT: %s", h.cmtcd);
  fprintf(stdout," i_rec=%d %-4s %-2s %-3s    P-time= %8.2f\n",
       i_rec,h.stnm,h.netw,h.chan,h.tpcks[0]);
}
/* ------------------ Done reading the data --------------- */

// we have now found all the Z channels.
// They are in the array "seism"
// First apply a low pass filter:
// Put filtered records in seism_f
for(i=0;i<i_rec;i++) {
  if (! bpfilter(if1,if2,if3,if4,NSAMP,dt,seism[i],seism_f[i]) )
    exit(-1);
}

// using the filtered records (seism_f) we
// determine the time shifts that render
// the best alignment of the filtered P waves
// by multi-channel cross-correlation 
// (see VanDecar and Crosson [BSSA, 1990])

// determine the cross-correlations
for (i=0;i<i_rec;i++) {
  for (k=i+1;k<i_rec;k++) {
    if (! crosscor(seism_f[i],seism_f[k],npts_xcor,dt,&mccc[i][k]) )
      exit(-1);
  }
}
// least-squares solution for the time shifts
for (i=0;i<i_rec;i++) {
  h_z[i].tshift = 0.;
  for (k=i+1; k<i_rec;k++)
    h_z[i].tshift = h_z[i].tshift + mccc[i][k];
  for (k=0; k<i;k++)
    h_z[i].tshift = h_z[i].tshift - mccc[k][i];
  h_z[i].tshift = h_z[i].tshift/i_rec;
  fprintf(stdout,"MCCC %d %s  dt= %f\n",i,h_z[i].stnm,h_z[i].tshift);
}

// shift the records by TSHIFT
for(i=0;i<i_rec;i++) {
  its = lrint(h_z[i].tshift/dt);
  fprintf(stdout,"SHIFTING: %s nsamp= %d its= %d shift= %f\n",
        h_z[i].stnm,h_z[i].ndata,its,h_z[i].tshift);
  // make a backup of seism
  for (k=0; k<h_z[i].ndata; k++)
    dum[k] = seism[i][k];
  for (k=0; k<h_z[i].ndata; k++) {
    if ( (k-its) < 0 || (k-its) >= h_z[i].ndata ) {
       seism_f[i][k] = 0.;
       seism[i][k] = 0.;
    } else {
      seism[i][k] = dum[k-its];
    }
    stack[k] = stack[k]+seism[i][k]/i_rec;
  }
  h_z[i].ot.yr = 2000;
  h_z[i].ot.mo = 1;
  h_z[i].ot.day = 1;
  h_z[i].ot.hr = 0;
  h_z[i].ot.mn = 0;
  h_z[i].ot.sec = 0.;
  h_z[i].tstart.yr = 2000;
  h_z[i].tstart.mo = 1;
  h_z[i].tstart.day = 1;
  h_z[i].tstart.hr = 0;
  h_z[i].tstart.mn = 0;
  h_z[i].tstart.sec = 0.;
  // WRITE XH header and data
  if (! xh_writehead(ofl,h_z[i]))
    exit(-1);
  if (! xh_writedata(ofl,h_z[i],seism[i])) 
    exit(-1);
}
/* ----------------------------------------------------------------
strncpy(h_z[1].stnm,"STCK",CHARSIZE);
// WRITE WAVEFORM STACK
fprintf(stdout,"STCK number of samples= %d\n", h_z[1].ndata);
if (! xh_writehead(ofl,h_z[1]))
  exit(-1);
if (! xh_writedata(ofl,h_z[1],stack)) 
  exit(-1);
//for (k=0; k<NSAMP; k++)
//  fprintf(stdout,"%f\n", stack[k]);
---------------------------------------------------------------- */

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_Palignment in_XH out_XH [-t T1 T2]\n");
        return(0);
}
