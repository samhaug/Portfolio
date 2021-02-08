// Finds amplitude in the bandpass filter 

#include <stdio.h>
#include <math.h>

int bpf(if1,if2,if3,if4,omega,bpfilt)
int if1,if2,if3,if4;
float omega;
float *bpfilt;
{
double dummy;
float w1,w2,w3,w4;
float PI, TPI;

PI  = 4.*atan(1.);
TPI = 2.*PI;

w1 = if1*TPI/1000.;
w2 = if2*TPI/1000.;
w3 = if3*TPI/1000.;
w4 = if4*TPI/1000.;

if( w1 == 0. && w4 == 0.)
   {
   *bpfilt = 1.;
   return(1);
   }
// fprintf(stdout,"in bfp() omega = %f\n", omega);
// fprintf(stdout,"w1 w2 w3 w4= %f %f %f %f\n",w1,w2,w3,w4);
if( omega>w4 || omega<w1 )
   *bpfilt = 0.;
else if( omega<=w4 && omega>=w3 ) {
    dummy = cos( (omega-w3)/(w4-w3)*PI/2. );
    *bpfilt = dummy*dummy;
    }
else if( omega<w3 && omega>w2 )
    *bpfilt = 1.;
else if( omega<=w2 && omega>=w1 ) {
    dummy = cos( (omega-w2)/(w1-w2)*PI/2. );
    *bpfilt = dummy*dummy;
    }
else
    *bpfilt = 0.;

// fprintf(stdout,"in bfp() freq = %f bpfilt = %f\n", omega/PI/2., *bpfilt);

return(1);
}
