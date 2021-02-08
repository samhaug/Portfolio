#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include "xhhead.h"
#include "Complex.h"

/*
Removing instrument response from TRInet stations
using Hiroo's formulation

J(w)a = G Jo(w)
Jo(w) = (iw*iw)/(iw - P)(iw - P*)
P     = omega0 * [ -h + i sqrt(1 - h*h)]
P*    = the complex conjugate of P

w = 2pi*f

*/

int xh_trinetresp(log,xh,f,fcorr)

FILE *log;
xhhed xh;
float *f,*fcorr;

{
int numsamp;
float dt;

FILE *fp, *fopen();

int i, j;
int nstat, nchan;
char ss[90];
char stat[CHARSIZE], chan[CHARSIZE];
char sta[CHARSIZE],  cha[CHARSIZE];

float cornfr, h, gain;
float omega0, a, b;
float omega[XH_NPTS];

fcomplex iw, counter, denominator, P1, P2, resp;
fcomplex dum1, dum2;
fcomplex imag;
fcomplex x[XH_NPTS];

int NFFT = XH_NPTS;
int notfound = 1;

void detrend();

numsamp = xh.ndata;
dt      = xh.delta;

// fprintf(log,"IN TERRARESP: %s %s numsamp= %d dt= %f\n",
//   xh.stnm,xh.chan,numsamp,dt);

for(i=0;i<CHARSIZE;++i)         sta[i]=tolower(xh.stnm[i]);
if (strncmp(xh.chan,"BHZ",3) == 0) sprintf(cha,"vbbz");
if (strncmp(xh.chan,"BHN",3) == 0) sprintf(cha,"vbbn");
if (strncmp(xh.chan,"BHE",3) == 0) sprintf(cha,"%s","vbbe");

imag.r = 0.;  imag.i = 1.0;

if(numsamp<=0) {
   fprintf(log,"%s\n","No data points read ....");
   return(0);
}

if( numsamp>XH_NPTS ) {
    fprintf(log,"%s\n","numsamp set equal to XH_NPTS");
    numsamp=XH_NPTS;
}
// Minimize NFFT to speed up fft(); XH_NPTS MUST be 2**(int)n
NFFT = XH_NPTS;
while (NFFT/2 >=numsamp) {
  NFFT = NFFT/2;
}

/*------------------------------------------------------------------*/
if ( (fp=fopen("/home/jeroen/Utils/Instruments/resdat.TK","r"))==NULL) {
  fprintf(stderr,"resdat.TK not found ...\n");
  return(0);
}
nstat = strlen(sta);
nchan = strlen(cha);
while (notfound) {
   if ( fgets(ss,90,fp) == NULL) break;
   sscanf(ss,"%s %s %f %f %f", stat,chan,&cornfr,&h,&gain);
   if ( strncmp(stat,sta,nstat) == 0 && strncmp(chan,cha,nchan) == 0) {
     // fprintf(log,"%s %s cornfr= %f H= %f G= %f\n",stat,chan,cornfr,h,gain);
     notfound = 0;
   }
}
if (notfound) {
  fprintf(log,"%s %s Not in resdat.TK catalogue ...\n",sta,cha);
  return(0);
}
/*------------------------------------------------------------------*/
omega0 = cornfr*TPI;

for( i=0; i<numsamp; i++) {
  x[i].r = f[i]; 
  x[i].i = 0.;
}
for(i=numsamp; i<NFFT; i++) 
  x[i].r = x[i].i = 0.;

fft( x,NFFT,-1 );

for( i=0; i<=(NFFT/2); i++ ) {
  omega[i] = TPI*i/(NFFT*dt);
  iw       = dmltp(omega[i],imag);
  a = -1.*h;
  b = 1. - h*h;
  b = sqrt(b);
  P1 = dmltp(omega0,dplus(a,dmltp(b,imag)));
  P2 = conjg(P1);
  counter     = cmltp(iw,iw);
  denominator = cmltp(cmin(iw,P1),cmin(iw,P2));
  resp        = cdiv(counter,denominator);
  x[i] = cdiv(x[i],resp);
  x[i] = dmltp((1./gain),x[i]);

  // High-pass filter with f<4mHz (T>250s)
  if (omega[i]/TPI < 0.004) {
    x[i].r = 0.;
    x[i].i = 0.;
  }
} // for loop

for( i=(NFFT/2)+1; i<NFFT; i++ ) 
  x[i] = conjg(x[NFFT-i]);

fft( x,NFFT,1 );

for( i=0; i<numsamp; i++)       
  fcorr[i] = x[i].r/100.;  // cm to meter

if (! xh_detrend(fcorr, numsamp))
  return(0);

return(1);
}
