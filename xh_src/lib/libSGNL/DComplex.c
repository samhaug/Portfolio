#include <math.h>
#include <stdio.h>
#include "DComplex.h"

// complex addition: z=a+b
dcomplex dcplus(a,b)
dcomplex a, b;
  {
  dcomplex z;
  z.r = a.r + b.r;
  z.i = a.i + b.i;
  return(z);
}

// float addition: z=k0+a
dcomplex dplus(k0,a)
dcomplex a;
double k0;
  {
  dcomplex z;
  z.r = a.r + k0;
  z.i = a.i;
  return(z);
}

// complex subtraction: z=a-b
dcomplex dcmin(a,b)
dcomplex a, b;
  {
  dcomplex z;
  z.r = a.r - b.r;
  z.i = a.i - b.i;
  return(z);
}

// complex multiplication: z=a*b
dcomplex dcmltp(a,b)
dcomplex a, b;
  {
  dcomplex z;
  z.r = a.r*b.r - a.i*b.i;
  z.i = a.r*b.i + a.i*b.r;
  return(z);
}

// multiplication z=k0*a
dcomplex dmltp(k0,a)
double k0;
dcomplex a;
  {
  dcomplex z;
  z.r = a.r * k0;
  z.i = a.i * k0;
  return(z);
}

// complex division: z=a/b
dcomplex dcdiv(a,b)
dcomplex a, b;
  {
  dcomplex z;
  double denom;
  denom = b.r*b.r + b.i*b.i;
  z.r = (a.r*b.r + a.i*b.i) /denom;
  z.i = (a.i*b.r - a.r*b.i) /denom;
  return(z);
}

// complex negative: z=-a
dcomplex dcngtv(a)
dcomplex a;
  {
  dcomplex z;
  z.r = -a.r;
  z.i = -a.i;
  return(z);
}


// conjugate: z=conjg(a)
dcomplex dconjg(a)
dcomplex a;
  {
  dcomplex z;
  z.r =  a.r;
  z.i = -a.i;
  return(z);
}

// complex inversion: z=1/a
dcomplex dcinv(a)
dcomplex a;
  {
  dcomplex z;
  double denom;
  denom = a.r*a.r + a.i*a.i;
  z.r =  a.r/denom;
  z.i = -a.i/denom;
  return(z);
}

// complex square z=csqr(a)
double dcsqr(a)
dcomplex a;
  {
  double k0;
  k0 = a.r*a.r+a.i*a.i;
  return(k0);
}

// complex square root z=sqrt(a)
dcomplex dcsqrt(a)
dcomplex a;
  {
  dcomplex z;
  double mo, ar;
  double dccabs(dcomplex);
  mo = sqrt(dccabs(a));
  ar = 0.5*atan2(a.i, a.r);
  z.r = mo*cos(ar);
  z.i = mo*sin(ar);
  return(z);
}

// make complex number z=cmplx(x,y)
dcomplex dcmplx(x,y)
double x,y;
  {
  dcomplex z;
  z.r = x;
  z.i = y;
  return(z);
}

// complex exp(a)
dcomplex dcexp(a)
dcomplex a;
  {
  double mo;
  mo = exp(a.r);
  return dcmplx(mo*cos(a.i), mo*sin(a.i));
}

// absolute value of a: return double
double dccabs(a)
dcomplex a;
  {
  double k0;
  k0 = sqrt(a.r*a.r+a.i*a.i);
  return(k0);
}
