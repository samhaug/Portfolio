#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"
#include "DComplex.h"


// ------------------------------------------------------------
// Convolves seismogram from "disp" to "vel".
// Requires that h.wavf == "dis";

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float fdisp[XH_NPTS],fvel[XH_NPTS];
FILE *ifl, *ofl, *fopen();

int i, j;
int index;
int ierr;
int still_reading_data = 1;

int NFFT = XH_NPTS;
int npol = 0;
int nzer = 0;
int numsamp = 0;

float omega[XH_NPTS];
float cornfr, gain;
float dt = 1.;
float taptime;

dcomplex iw;
dcomplex imag;
dcomplex x[XH_NPTS];

int usage();

if(argc != 5) {
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
index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 't':
        // number of samples
        if ( sscanf( argv[++index], "%f", &taptime ) != 1) {
            ierr = usage();
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,fdisp)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
  // Exit if input seismograms is NOT a "dis" seismogram: 
  if ( strncmp(h.wavf,"dis",3) != 0) {
    fprintf(stdout,"Warning: Record %s with WAVF=%s is not DIS\n", h.stnm,h.wavf);
  }
  fprintf(stdout,"%s %-4s %2s %3s ",h.cmtcd,h.stnm,h.netw,h.chan);
  fprintf(stdout,"%d %7.3f\n",h.ndata,dt);
  // Detrend the data
  if (! detrend(fdisp, h.ndata)) exit(-1);
  // Taper
  if (! taper(fdisp,h.delta,h.ndata,taptime)) exit(-1);

  imag.r = 0.;  imag.i = 1.0;
  numsamp = h.ndata;
  dt      = h.delta;
  if(numsamp<=0) { 
     fprintf(stderr,"No data: in %s %s %s; exiting ...",
       h.cmtcd,h.stnm,h.chan);
     exit(-1);
  }
  if( numsamp>XH_NPTS) {
     fprintf(stderr,"Number of samples exceed XH_NPTS in %s %s %s; exiting ...",
       h.cmtcd,h.stnm,h.chan);
     exit(-1);
  }

  // Minimize NFFT to speed up fft(); XH_NPTS MUST be 2**(int)n
  NFFT = XH_NPTS;
  while (NFFT/2 >=numsamp) {
    NFFT = NFFT/2;
  }
  for( i=0; i<numsamp; i++)   {
     x[i].r = fdisp[i]; x[i].i = 0.;
  }
  for(i=numsamp; i<NFFT; i++) {
     x[i].r = 0.;   x[i].i = 0.;
  }
  // Fourier transform to FREQ domain
  dfft( x,NFFT,-1 );
  
  // Multiply by i.omega to get velocities
  for( i=0; i<=(NFFT/2); i++ ) {
     omega[i] = TPI*i/(NFFT*dt);
     iw       = dmltp(omega[i],imag);
     // Make velocity response ... 
     x[i] = dcmltp(x[i],iw);       
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
  for( i=0; i<numsamp; i++ ) fvel[i] = x[i].r;
  // Remove DC and linear trend
  if (! xh_detrend(fvel, numsamp)) exit(-1);

  // New record is now a VELOCITY record
  strncpy(h.wavf,"vel",CHARSIZE);
  /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,fvel))
    exit(-1);
}

fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
        fprintf(stderr,"Usage: xh_disp2vel in_XHfile out_XHfile -t TAPtime\n");
        return(-1);
}
