#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "DComplex.h"

#define MAX_NPTS 262144

// ------------------------------------------------------------
// Convolves seismogram from "vel" to "disp".
// Requires that h.wavf == "vel";

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float fdisp[MAX_NPTS],fvel[MAX_NPTS];
FILE *ifl, *ofl, *fopen();

int i, j;
int ierr;
int still_reading_data = 1;

int NFFT = MAX_NPTS;
int npol = 0;
int nzer = 0;
int numsamp = 0;

float omega[MAX_NPTS];
float cornfr, gain;
float dt = 1.;

dcomplex iw;
dcomplex imag;
dcomplex x[MAX_NPTS];

int usage();

if(argc != 3) {
   ierr = usage();
   exit(ierr);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,fvel)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
  // Exit if input seismograms is NOT a "vel" seismogram: 
  if ( strncmp(h.wavf,"vel",3) != 0) {
    fprintf(stderr,"Record %s with WAVF=%s is not VEL\n", h.stnm,h.wavf);
    exit (-1);
  }
  fprintf(stdout,"%s %-4s %2s %3s ",h.evtcd,h.stnm,h.netw,h.chan);
  fprintf(stdout,"%d %7.3f\n",h.ndata,dt);
  // Detrend the data
  if (! detrend(fvel, h.ndata)) exit(-1);

  imag.r = 0.;  imag.i = 1.0;
  numsamp = h.ndata;
  dt      = h.delta;
  if(numsamp<=0) { 
     fprintf(stderr,"No data: in %s %s %s; exiting ...",
       h.evtcd,h.stnm,h.chan);
     exit(-1);
  }
  if( numsamp>MAX_NPTS) {
     fprintf(stderr,"Number of samples exceed MAX_NPTS in %s %s %s; exiting ...",
       h.evtcd,h.stnm,h.chan);
     exit(-1);
  }

  // Minimize NFFT to speed up fft(); MAX_NPTS MUST be 2**(int)n
  NFFT = MAX_NPTS;
  while (NFFT/2 >=numsamp) {
    NFFT = NFFT/2;
  }
  for( i=0; i<numsamp; i++)   {
     x[i].r = fvel[i]; x[i].i = 0.;
  }
  for(i=numsamp; i<NFFT; i++) {
     x[i].r = 0.;   x[i].i = 0.;
  }
  // Fourier transform to FREQ domain
  dfft( x,NFFT,-1 );
  
  // Divide by i.omega to get displacements
  for( i=0; i<=(NFFT/2); i++ ) {
     omega[i] = TPI*i/(NFFT*dt);
     iw       = dmltp(omega[i],imag);
     // Make displacement response ... 
     x[i] = dcdiv(x[i],iw);       
     // High-pass filter with f<4mHz (T>250s) to suppress long-period noise:
     if (omega[i]/TPI < 0.004) {
       x[i].r = 0.;
       x[i].i = 0.;
     }
  }
  // Mirror around NFFT/2
  for( i=(NFFT/2)+1; i<NFFT; i++ ) x[i] = dconjg(x[NFFT-i]);
  // Inverse Fourier transform to TIME domain
  dfft( x,NFFT,1 );
  // Real part of x is the deconvolved seismogram
  // I do not think that we have to divide by NFFT or dt;
  // but I will need to verify this ... (jeroen ritsema)
  for( i=0; i<numsamp; i++ ) fdisp[i] = x[i].r;
  // Remove DC and linear trend
  if (! detrend(fdisp, numsamp)) exit(-1);

  // New record is now a VELOCITY record
  strcpy(h.wavf,"dis");
  /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,fdisp))
    exit(-1);
}

fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
        fprintf(stderr,"Usage: xh_vel2disp in_XHfile out_XHfile\n");
        return(-1);
}
