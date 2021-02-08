#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"
#include "DComplex.h"

//#include "xh_functions.h"

#define NPTS 262144

// ------------------------------------------------------------
// Decimate

int main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[NPTS],fnew[NPTS];
FILE *ifl, *ofl, *fopen();

int i,k;
int ierr;
int index;
int NFFT = 524288;
int still_reading_data = 1;

int fact=1;

float omega;
float omega_nyg;
float newdt;

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
        if ( sscanf( argv[++index], "%f", &newdt ) != 1) {
            ierr = usage();
        }
        break;
     default:
        ierr = usage();
        return(ierr);
  }
}

imag.r = 0.;  imag.i = 1.0;
fprintf(stdout,"newdt= %7.3f\n",newdt);

while (still_reading_data) {
fprintf(stdout,"A newdt= %7.3f\n",newdt);
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,f)) {
      still_reading_data = 0;
      exit(0);
    }
  }
fprintf(stdout,"B newdt= %7.3f\n",newdt);
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
fprintf(stdout,"C newdt= %7.3f\n",newdt);
// Minimize NFFT to speed up fft(); XH_NPTS MUST be 2**(int)n
  if        ( fabs(newdt-h.delta) < 0.00001) {
    // fprintf(stderr,"No RESAMPLING newDT (=%f) == dt (=%f) %s/%s/%s\n",newdt,h.delta,h.netw,h.stnm,h.chan);
    fprintf(stdout,"%s %s %s %s ",h.evtcd,h.stnm,h.netw,h.chan);
    fprintf(stdout,"ndata= %d dt= %7.3f fact= %d\n",h.ndata,h.delta,1);
   /* WRITE XH header and data */
    if (! xh_writehead(ofl,h))
      exit(-1);
    if (! xh_writedata(ofl,h,f))
      exit(-1);
  } else if ( (h.delta - newdt) > 0.001) {
    fprintf(stdout,"DELTA-T (=%7.3f) is larger than NEWDT (=%7.3f) %s/%s/%s\n",h.delta,newdt,h.netw,h.stnm,h.chan);
  } else {
    fact = (int) rintf( newdt / h.delta );
    fprintf(stdout,"%s %s %s %s ",h.evtcd,h.stnm,h.netw,h.chan);
    fprintf(stdout,"ndata= %d dt= %7.3f fact= %d\n",h.ndata,h.delta,fact);
    fprintf(stdout,"C1 newdt= %7.3f\n",newdt);
    NFFT = XH_NPTS;
    NFFT = 524288;
    fprintf(stdout,"Z1 NFFT= %d\n",NFFT);
    fprintf(stdout,"C2 newdt= %7.3f\n",newdt);
    while (NFFT/2 >=h.ndata) {
      NFFT = NFFT/2;
    }
    fprintf(stdout,"C3 newdt= %7.3f\n",newdt);
    fprintf(stdout,"Z2 NFFT= %d\n",NFFT);
    fprintf(stdout,"h.ndata= %d NFFT= %d\n",h.ndata, NFFT);
    for( i=0; i<h.ndata; i++) {
       x[i].r = f[i]; x[i].i = 0.;
    }
    fprintf(stdout,"C4 newdt= %7.3f\n",newdt);
    fprintf(stdout,"h.ndata= %d NFFT= %d\n",h.ndata, NFFT);
    fprintf(stdout,"Z3 NFFT= %d\n",NFFT);
    for(i=h.ndata; i<NFFT; i++) {
       x[i].r = 0.;   x[i].i = 0.;
       //fprintf(stdout,"----- i= %d newdt= %7.3f\n", i, newdt);
    }
    fprintf(stdout,"C5 newdt= %7.3f\n",newdt);
  
    // Fourier transform to FREQ domain
    dfft( x,NFFT,-1 );
                                                                                  
    omega_nyg = TPI/(2.*newdt); // Nyguist frequency
    for( i=0; i<=(NFFT/2); i++ ) {
       omega = TPI*i/(NFFT*h.delta);
       // set spectrum zero beyond Nyquist frequency
       if (omega >= omega_nyg) 
         x[i].r = x[i].i = 0.;
    } // for loop
    x[0].r=x[0].i=0.;
  
    // mirror around NFFT/2
    for( i=(NFFT/2)+1; i<NFFT; i++ ) x[i] = dconjg(x[NFFT-i]);
    // Inverse Fourier transform to TIME domain
    dfft( x,NFFT,1 );
    // Real part of x is the filtered seismogram
    for( i=0; i<h.ndata; i++ ) f[i] = x[i].r;
  
    // resample
    for ( i=0, k=0; k<h.ndata; i++, k+=fact )
      fnew[i] = f[k+1];
    h.ndata = i;
    h.delta = newdt;
  
  
   /* WRITE XH header and data */
    if (! xh_writehead(ofl,h))
      exit(-1);
    if (! xh_writedata(ofl,h,fnew))
      exit(-1);
  }
fprintf(stdout,"D newdt= %7.3f\n",newdt);
} // while
  
fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
  fprintf(stderr,"Usage: xh_decim in_XHfile out_XHfile -t newDT (s)\n");
  return(-1);
}
