#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"    /* XH format structures */

// inserts the PoleZeros of BDSN
//

int xh_bdsnresp(h)
xhhed *h;
{

int i;

for(i=0; i<30; ++i) {
  h->pole[i].r = 0.;
  h->pole[i].i = 0.;
  h->zero[i].r = 0.;
  h->zero[i].i = 0.;
}

if ( strncmp(h->stnm,"BDM",3) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   1.009e+09;
return(1);
}

if ( strncmp(h->stnm,"BKS",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -3.918e+01; h->pole[3].i =   4.912e+01;
h->pole[4].r =  -3.918e+01; h->pole[4].i =  -4.912e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   4.189e+03;
h->DS=   9.382e+08;
return(1);
}

if ( strncmp(h->stnm,"BRK",3) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   1.049e+09;
return(1);
}

if ( strncmp(h->stnm,"CMB",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -3.918e+01; h->pole[3].i =   4.912e+01;
h->pole[4].r =  -3.918e+01; h->pole[4].i =  -4.912e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   4.189e+03;
h->DS=   8.884e+08;
return(1);
}

if ( strncmp(h->stnm,"CVS",3) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   1.003e+09;
return(1);
}

if ( strncmp(h->stnm,"JCC",3) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   1.058e+09;
return(1);
}

if ( strncmp(h->stnm,"KCC",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -3.918e+01; h->pole[3].i =   4.912e+01;
h->pole[4].r =  -3.918e+01; h->pole[4].i =  -4.912e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   4.189e+03;
h->DS=   1.009e+09;
return(1);
}

if ( strncmp(h->stnm,"MIN",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -1.959e+01; h->pole[3].i =   2.456e+01;
h->pole[4].r =  -1.959e+01; h->pole[4].i =  -2.456e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   987.14;
h->DS=   1.074e+09;
return(1);
}

if ( strncmp(h->stnm,"MHC",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -3.918e+01; h->pole[3].i =   4.912e+01;
h->pole[4].r =  -3.918e+01; h->pole[4].i =  -4.912e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   5.236e+03;
h->DS=   8.083e+08;
return(1);
}

if ( strncmp(h->stnm,"MOD",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -3.918e+01; h->pole[3].i =   4.912e+01;
h->pole[4].r =  -3.918e+01; h->pole[4].i =  -4.912e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   5.236e+03;
h->DS=   7.941e+08;
return(1);
}

if ( strncmp(h->stnm,"ORV",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -3.918e+01; h->pole[3].i =   4.912e+01;
h->pole[4].r =  -3.918e+01; h->pole[4].i =  -4.912e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   4.189e+03;
h->DS=   8.586e+08;
return(1);
}

if ( strncmp(h->stnm,"PKD",3) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   9.908e+08;
return(1);
}

if ( strncmp(h->stnm,"SAO",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -3.918e+01; h->pole[3].i =   4.912e+01;
h->pole[4].r =  -3.918e+01; h->pole[4].i =  -4.912e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   4.189e+03;
h->DS=   9.961e+08;
return(1);
}

if ( strncmp(h->stnm,"WDC",3) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   9.854e+08;
return(1);
}

if ( strncmp(h->stnm,"YBH",3) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -1.959e+01; h->pole[3].i =   2.456e+01;
h->pole[4].r =  -1.959e+01; h->pole[4].i =  -2.456e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   1.309e+03;
h->DS=   7.297e+08;
return(1);
}

if ( strncmp(h->stnm,"BRIB",4) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -4.442e-02; h->pole[1].i =   4.442e-02;
h->pole[2].r =  -4.442e-02; h->pole[2].i =  -4.442e-02;
h->pole[3].r =  -5.058e+02; h->pole[3].i =   1.935e+02;
h->pole[4].r =  -5.058e+02; h->pole[4].i =  -1.935e+02;
h->zero[0].r =  4.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   9.456e+02; h->zero[3].i =   0.000e+00;
h->zero[4].r =   0.000e+00; h->zero[4].i =   0.000e+00;
h->A0=   1.763e+02;
h->DS=  -1.057e+09;
return(1);
}

if ( strncmp(h->stnm,"FARB",4) == 0) {
h->pole[0].r =  2.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -4.443e-02; h->pole[1].i =   4.443e-02;
h->pole[2].r =  -4.443e-02; h->pole[2].i =  -4.443e-02;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   5.684e-01;
h->DS=   4.257e+09;
return(1);
}

if ( strncmp(h->stnm,"HOPS",4) == 0) {
h->pole[0].r =  4.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.234e-02; h->pole[1].i =   1.234e-02;
h->pole[2].r =  -1.234e-02; h->pole[2].i =  -1.234e-02;
h->pole[3].r =  -3.918e+01; h->pole[3].i =   4.912e+01;
h->pole[4].r =  -3.918e+01; h->pole[4].i =  -4.912e+01;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   4.189e+03;
h->DS=   9.181e+08;
return(1);
}

if ( strncmp(h->stnm,"HUMO",4) == 0) {
h->pole[0].r = 11.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.680e-02; h->pole[1].i =   3.705e-02;
h->pole[2].r =  -3.680e-02; h->pole[2].i =  -3.705e-02;
h->pole[3].r =  -1.024e+04; h->pole[3].i =   2.725e+03;
h->pole[4].r =  -1.024e+04; h->pole[4].i =  -2.725e+03;
h->pole[5].r =  -9.513e+03; h->pole[5].i =   1.147e+04;
h->pole[6].r =  -9.513e+03; h->pole[6].i =  -1.147e+04;
h->pole[7].r =  -4.545e+02; h->pole[7].i =   0.000e+00;
h->pole[8].r =  -4.218e+02; h->pole[8].i =   0.000e+00;
h->pole[9].r =  -9.087e+01; h->pole[9].i =   3.992e+02;
h->pole[10].r =  -9.087e+01; h->pole[10].i =  -3.992e+02;
h->pole[11].r =  -1.527e+01; h->pole[11].i =   0.000e+00;
h->zero[0].r =  7.0;
h->zero[0].i =  0.0;
h->zero[1].r =  -4.618e+02; h->zero[1].i =   4.291e+02;
h->zero[2].r =  -4.618e+02; h->zero[2].i =  -4.291e+02;
h->zero[3].r =  -1.984e+02; h->zero[3].i =   0.000e+00;
h->zero[4].r =  -1.515e+01; h->zero[4].i =   0.000e+00;
h->zero[5].r =   0.000e+00; h->zero[5].i =   0.000e+00;
h->zero[6].r =   0.000e+00; h->zero[6].i =   0.000e+00;
h->zero[7].r =   0.000e+00; h->zero[7].i =   0.000e+00;
h->A0=   5.820e+18;
h->DS=   1.112e+09;
return(1);
}

if ( strncmp(h->stnm,"ARC",3) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   4.925e+07;
h->DS=   6.232e+08;
return(1);
}

if ( strncmp(h->stnm,"JRSC",4) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   9.900e+08;
return(1);
}

if ( strncmp(h->stnm,"MNRC",4) == 0) {
h->pole[0].r = 11.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.630e+03; h->pole[1].i =   4.337e+02;
h->pole[2].r =  -1.630e+03; h->pole[2].i =  -4.337e+02;
h->pole[3].r =  -1.514e+03; h->pole[3].i =   1.826e+03;
h->pole[4].r =  -1.514e+03; h->pole[4].i =  -1.826e+03;
h->pole[5].r =  -7.234e+01; h->pole[5].i =   0.000e+00;
h->pole[6].r =  -6.925e+01; h->pole[6].i =   0.000e+00;
h->pole[7].r =  -1.447e+01; h->pole[7].i =   6.256e+01;
h->pole[8].r =  -1.447e+01; h->pole[8].i =  -6.256e+01;
h->pole[9].r =  -2.460e+00; h->pole[9].i =   0.000e+00;
h->pole[10].r =  -3.678e-02; h->pole[10].i =   3.712e-02;
h->pole[11].r =  -3.678e-02; h->pole[11].i =  -3.712e-02;
h->zero[0].r =  7.0;
h->zero[0].i =  0.0;
h->zero[1].r =  -7.350e+01; h->zero[1].i =   6.829e+01;
h->zero[2].r =  -7.350e+01; h->zero[2].i =  -6.829e+01;
h->zero[3].r =  -3.258e+01; h->zero[3].i =   0.000e+00;
h->zero[4].r =  -2.411e+00; h->zero[4].i =   0.000e+00;
h->zero[5].r =   0.000e+00; h->zero[5].i =   0.000e+00;
h->zero[6].r =   0.000e+00; h->zero[6].i =   0.000e+00;
h->zero[7].r =   0.000e+00; h->zero[7].i =   0.000e+00;
h->A0=   6.247e+14;
h->DS=   1.024e+09;
return(1);
}

if ( strncmp(h->stnm,"PACP",4) == 0) {
h->pole[0].r = 11.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -1.630e+03; h->pole[1].i =   4.337e+02;
h->pole[2].r =  -1.630e+03; h->pole[2].i =  -4.337e+02;
h->pole[3].r =  -1.514e+03; h->pole[3].i =   1.826e+03;
h->pole[4].r =  -1.514e+03; h->pole[4].i =  -1.826e+03;
h->pole[5].r =  -7.234e+01; h->pole[5].i =   0.000e+00;
h->pole[6].r =  -6.955e+01; h->pole[6].i =   0.000e+00;
h->pole[7].r =  -1.488e+01; h->pole[7].i =   6.256e+01;
h->pole[8].r =  -1.488e+01; h->pole[8].i =  -6.256e+01;
h->pole[9].r =  -2.452e+00; h->pole[9].i =   0.000e+00;
h->pole[10].r =  -3.677e-02; h->pole[10].i =   3.710e-02;
h->pole[11].r =  -3.677e-02; h->pole[11].i =  -3.710e-02;
h->zero[0].r =  7.0;
h->zero[0].i =  0.0;
h->zero[1].r =  -7.350e+01; h->zero[1].i =   6.829e+01;
h->zero[2].r =  -7.350e+01; h->zero[2].i =  -6.829e+01;
h->zero[3].r =  -3.235e+01; h->zero[3].i =   0.000e+00;
h->zero[4].r =  -2.411e+00; h->zero[4].i =   0.000e+00;
h->zero[5].r =   0.000e+00; h->zero[5].i =   0.000e+00;
h->zero[6].r =   0.000e+00; h->zero[6].i =   0.000e+00;
h->zero[7].r =   0.000e+00; h->zero[7].i =   0.000e+00;
h->A0=   6.322e+14;
h->DS=   9.927e+08;
return(1);
}

if ( strncmp(h->stnm,"POTR",4) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   1.054e+09;
return(1);
}

if ( strncmp(h->stnm,"WENL",4) == 0) {
h->pole[0].r =  5.0;
h->pole[0].i =  0.0;
h->pole[1].r =  -3.702e-02; h->pole[1].i =   3.702e-02;
h->pole[2].r =  -3.702e-02; h->pole[2].i =  -3.702e-02;
h->pole[3].r =  -1.188e+02; h->pole[3].i =   4.235e+02;
h->pole[4].r =  -1.188e+02; h->pole[4].i =  -4.235e+02;
h->pole[5].r =  -2.513e+02; h->pole[5].i =   0.000e+00;
h->zero[0].r =  3.0;
h->zero[0].i =  0.0;
h->zero[1].r =   0.000e+00; h->zero[1].i =   0.000e+00;
h->zero[2].r =   0.000e+00; h->zero[2].i =   0.000e+00;
h->zero[3].r =   0.000e+00; h->zero[3].i =   0.000e+00;
h->A0=   2.976e+07;
h->DS=   9.716e+08;
return(1);
}

}
