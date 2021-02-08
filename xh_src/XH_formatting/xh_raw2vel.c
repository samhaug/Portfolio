#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "DComplex.h"

#define MAX_NPTS 262144

// ------------------------------------------------------------
// Removes instrument response using the Pole-Zero formulation.
// Convolves seismogram from "raw" to "vel".
// Requires that h.wavf == "raw";

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[MAX_NPTS],fvel[MAX_NPTS];
FILE *ifl, *ofl, *fopen();

int i, j;
int ierr;
int still_reading_data = 1;

int NFFT = MAX_NPTS;
int npol = 0;
int nzer = 0;
int numsamp = 0;

float omega[MAX_NPTS];
double gain;
float dt = 1.;

dcomplex iw, count, denom, P1, P2, resp;
dcomplex imag;
dcomplex x[MAX_NPTS];
dcomplex poles[30], zeros[30];
dcomplex z;

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
    if (! xh_readdata(ifl,h,f)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
  // Exit if input seismogram is NOT a "raw" seismogram: 
  if ( strncmp(h.wavf,"raw",3) != 0) {
    fprintf(stderr,"Record %s with WAVF=%s is not RAW\n", h.stnm,h.wavf);
    exit (-1);
  }

  imag.r = 0.;  imag.i = 1.0;
  numsamp = h.ndata;
  dt      = h.delta;
  if(numsamp<=0) { 
     fprintf(stderr,"No data: in %s %s %s; exiting ...",
       h.cmtcd,h.stnm,h.chan);
     exit(-1);
  }
  if( numsamp>MAX_NPTS) {
     fprintf(stderr,"Number of samples exceed MAX_NPTS in %s %s %s; exiting ...",
       h.cmtcd,h.stnm,h.chan);
     exit(-1);
  }
fprintf(stdout,"A0 f[600] = %e\n", f[600]);
  // Remove DC and linear trend
  if (! xh_detrend(f, numsamp)) exit(-1);
fprintf(stdout,"A1 f[600] = %e\n", f[600]);
  // Minimize NFFT to speed up fft(); MAX_NPTS MUST be 2**(int n)
  NFFT = MAX_NPTS;
  while (NFFT/2 >=numsamp) {
    NFFT = NFFT/2;
  }

  // Get the POLE AND ZEROES from the XH header 
  gain = h.A0 * h.DS;
  if ( (npol=xh_float2int(h.pole[0].r)) < 0) exit (-1);
  if ( (nzer=xh_float2int(h.zero[0].r)) < 0) exit (-1);
  for(i=1; i<=npol; i++) {
     poles[i-1].r = h.pole[i].r;
     poles[i-1].i = h.pole[i].i;
  }
  for(i=1; i<=nzer; i++) {
     zeros[i-1].r = h.zero[i].r;
     zeros[i-1].i = h.zero[i].i;
  }
  fprintf(stdout," %s %-4s %2s %3s ",h.evtcd,h.stnm,h.netw,h.chan);
  fprintf(stdout," %d %7.3f ",h.ndata,dt);
  fprintf(stdout," %d/%d %9.2e\n",npol,nzer,gain);

  for( i=0; i<numsamp; i++)   {
     x[i].r = f[i]; x[i].i = 0.;
  }
  for(i=numsamp; i<NFFT; i++) {
     x[i].r = 0.;   x[i].i = 0.;
  }
  
fprintf(stdout,"A2 x[600] = %e\n", x[600].r);
// Fourier transform to FREQ domain
dfft( x,NFFT,-1 );
fprintf(stdout,"A3 x[600] = %e\n", x[600].r);
  
  // Divide by instrument response using PoleZero formalism
  for( i=0; i<=(NFFT/2); i++ ) {
     omega[i] = TPI*i/(NFFT*dt);
     iw       = dmltp(omega[i],imag);
     count.r = 1.; count.i = 0.;
     denom.r = 1.; denom.i = 0.;
     for(j=0;j<nzer;++j) {
       count = dcmltp(count,dcmin(iw,zeros[j]));
     }
     for(j=0;j<npol;++j) {
       denom = dcmltp(denom,dcmin(iw,poles[j]));
     }
if (i == 600)
fprintf(stdout,"b1 x= %e %e count= %e %e denom= %e %e gain= %e\n",x[600].r,x[600].i,count.r,count.i,denom.r,denom.i,gain);
     count   = dmltp(gain,count);
if (i == 600)
fprintf(stdout,"b2 x= %e %e count= %e %e denom= %e %e gain= %e\n",x[600].r,x[600].i,count.r,count.i,denom.r,denom.i,gain);
     resp    = dcdiv(count,denom);
if (i == 600)
fprintf(stdout,"b3 x= %e %e count= %e %e denom= %e %e gain= %e\n",x[600].r,x[600].i,count.r,count.i,denom.r,denom.i,gain);
     x[i] = dcdiv(x[i],resp);
if (i == 600)
fprintf(stdout,"b4 x= %e %e count= %e %e denom= %e %e gain= %e\n",x[600].r,x[600].i,count.r,count.i,denom.r,denom.i,gain);
     // Make velocity response ... 
     x[i] = dcmltp(x[i],iw);       
if (i == 600)
fprintf(stdout,"A3 x[600] = %e\n", x[600].r);

  
     // High-pass filter with f<4mHz (T>250s) to suppress long-period noise:
     if (omega[i]/TPI < 0.004) {
       x[i].r = 0.;
       x[i].i = 0.;
     }
  } // for loop

  // Mirror around NFFT/2
  for( i=(NFFT/2)+1; i<NFFT; i++ ) x[i] = dconjg(x[NFFT-i]);
  // Inverse Fourier transform to TIME domain
  dfft( x,NFFT,1 );
  // Real part of x is the deconvolved seismogram
  // I do not think that we have to divide by NFFT or dt;
  // but I will need to verify this ... (jeroen ritsema)
  for( i=0; i<numsamp; i++ ) fvel[i] = x[i].r;
fprintf(stdout,"A2 fvel[600] = %e\n", fvel[600]);
  // Remove DC and linear trend
  if (! xh_detrend(fvel, numsamp)) exit(-1);
fprintf(stdout,"A3 fvel[600] = %e\n", fvel[600]);

  // New record is now a VELOCITY record
  strcpy(h.wavf,"vel");
  /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,fvel))
    exit(-1);
} // while

fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
        fprintf(stderr,"Usage: xh_raw2vel in_XHfile out_XHfile\n");
        return(-1);
}
