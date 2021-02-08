#include <stdio.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"
#include "Complex.h"

// ------------------------------------------------------------
// Removes instrument response using the Pole-Zero formulation.
// Convolves raw seismograms to velocity

int xh_irisresp(log,h,f,fvel)
FILE *log;
xhhed h;
float *f,*fvel;

{
int i, j;

int NFFT = XH_NPTS;
int npol = 0;
int nzer = 0;
int numsamp = 0;

float omega[XH_NPTS];
float gain;
float dt = 1.;

fcomplex iw, count, denom, resp;
fcomplex imag;
fcomplex x[XH_NPTS];
fcomplex poles[30], zeros[30];
void detrend();

int usage();

// fprintf(stdout," %s %-4s %2s %3s ",h.evtcd,h.stnm,h.netw,h.chan);
// fprintf(stdout," %d %7.3f\n",h.ndata,dt);
imag.r = 0.;  imag.i = 1.0;
numsamp = h.ndata;
dt      = h.delta;

if(numsamp<=0) { 
   fprintf(log,"No data: in %s %s %s; exiting ...",
     h.evtcd,h.stnm,h.chan);
   return(0);
}
if( numsamp>XH_NPTS) {
  // fprintf(log,"%s\n","numsamp set equal to XH_NPTS");
  numsamp=XH_NPTS;
}
// Minimize NFFT to speed up fft(); XH_NPTS MUST be 2**(int)n
NFFT = XH_NPTS;
while (NFFT/2 >=numsamp) {
  NFFT = NFFT/2;
}

// Get the POLE AND ZEROES from the XH header 
gain = h.A0 * h.DS;
if ( (npol=xh_float2int(h.pole[0].r)) < 0) return(0);
if ( (nzer=xh_float2int(h.zero[0].r)) < 0) return(0);
for(i=1; i<=npol; i++) {
   poles[i-1].r = h.pole[i].r;
   poles[i-1].i = h.pole[i].i;
}
for(i=1; i<=nzer; i++) {
   zeros[i-1].r = h.zero[i].r;
   zeros[i-1].i = h.zero[i].i;
}
// fprintf(log," %s %-4s %2s %3s ",h.evtcd,h.stnm,h.netw,h.chan);
// fprintf(log," %d %7.3f ",h.ndata,dt);
// fprintf(stdout," %d/%d %9.2e\n",npol,nzer,gain);

for( i=0; i<numsamp; i++)   {
   x[i].r = f[i]; x[i].i = 0.;
}
for(i=numsamp; i<NFFT; i++) {
   x[i].r = 0.;   x[i].i = 0.;
}
  
// Fourier transform to FREQ domain
fft( x,NFFT,-1 );
  
// Divide by instrument response using PoleZero formalism
for( i=0; i<=(NFFT/2); i++ ) {
   omega[i] = TPI*i/(NFFT*dt);
   iw       = dmltp(omega[i],imag);
   count.r = 1.; count.i = 0.;
   denom.r = 1.; denom.i = 0.;
   for(j=0;j<nzer;++j) {
     count = cmltp(count,cmin(iw,zeros[j]));
   }
   for(j=0;j<npol;++j) {
     denom = cmltp(denom,cmin(iw,poles[j]));
   }
   resp    = dmltp(gain,cdiv(count,denom));
   x[i] = cdiv(x[i],resp);
   // Make velocity response ... 
   x[i] = cmltp(x[i],iw);       

  
   // High-pass filter with f<4mHz (T>250s)
   // to suppress long-period noise:
   if (omega[i]/TPI < 0.004) {
     x[i].r = 0.;
     x[i].i = 0.;
   }
} // for loop

// Mirror around NFFT/2
for( i=(NFFT/2)+1; i<NFFT; i++ ) x[i] = conjg(x[NFFT-i]);
// Inverse Fourier transform to TIME domain
fft( x,NFFT,1 );
// Real part of x is the deconvolved seismogram
// I do not think that we have to divide by NFFT or dt;
// but I will need to verify this ... (jeroen ritsema)
for( i=0; i<numsamp; i++ ) fvel[i] = x[i].r;
// Remove DC and linear trend
if (! xh_detrend(fvel, numsamp)) return(0);

return(1);
}
