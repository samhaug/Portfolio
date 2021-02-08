#include <math.h>
#include <stdio.h>
#include "Complex.h"

// complex addition: z=a+b
fcomplex cplus(a,b)
fcomplex a, b;
  {
  fcomplex z;
  z.r = a.r + b.r;
  z.i = a.i + b.i;
  return(z);
}

// float addition: z=k0+a
fcomplex fplus(k0,a)
fcomplex a;
float k0;
  {
  fcomplex z;
  z.r = a.r + k0;
  z.i = a.i;
  return(z);
}

// complex subtraction: z=a-b
fcomplex cmin(a,b)
fcomplex a, b;
  {
  fcomplex z;
  z.r = a.r - b.r;
  z.i = a.i - b.i;
  return(z);
}

// complex multiplication: z=a*b
fcomplex cmltp(a,b)
fcomplex a, b;
  {
  fcomplex z;
  z.r = a.r*b.r - a.i*b.i;
  z.i = a.r*b.i + a.i*b.r;
  return(z);
}

// complex division: z=a/b
fcomplex cdiv(a,b)
fcomplex a, b;
  {
  fcomplex z;
  float denom;
  denom = b.r*b.r + b.i*b.i;
  z.r = (a.r*b.r + a.i*b.i) /denom;
  z.i = (a.i*b.r - a.r*b.i) /denom;
  return(z);
}

// complex negative: z=-a
fcomplex cngtv(a)
fcomplex a;
  {
  fcomplex z;
  z.r = -a.r;
  z.i = -a.i;
  return(z);
}

// multiplication z=k0*a
fcomplex fmltp(k0,a)
float k0;
fcomplex a;
  {
  fcomplex z;
  z.r = a.r * k0;
  z.i = a.i * k0;
  return(z);
}

// conjugate: z=conjg(a)
fcomplex conjg(a)
fcomplex a;
  {
  fcomplex z;
  z.r =  a.r;
  z.i = -a.i;
  return(z);
}

// complex inversion: z=1/a
fcomplex cinvs(a)
fcomplex a;
  {
  fcomplex z;
  float denom;
  denom = a.r*a.r + a.i*a.i;
  z.r =  a.r/denom;
  z.i = -a.i/denom;
  return(z);
}

// complex square z=csqr(a)
double csqr(a)
fcomplex a;
  {
  double k0;
  k0 = a.r*a.r+a.i*a.i;
  return(k0);
}

// complex square root z=sqrt(a)
fcomplex csqroot(a)
fcomplex a;
  {
  fcomplex z;
  float fcabs();
  float mo, ar;
  mo = sqrtf(fcabs(a));
  ar = 0.5*atan2f(a.i, a.r);
  z.r = mo*cos(ar);
  z.i = mo*sin(ar);
  return(z);
}

// make complex number z=cmplx(x,y)
fcomplex cmplx(x,y)
float x,y;
  {
  fcomplex z;
  z.r = x;
  z.i = y;
  return(z);
}

// complex exp(a)
fcomplex cexpon(a)
fcomplex a;
  {
  double mo;
  mo = exp(a.r);
  return cmplx(mo*cos(a.i), mo*sin(a.i));
}

// absolute value of a: return float
float fcabs(a)
fcomplex a;
  {
  float k0;
  k0 = sqrt(a.r*a.r+a.i*a.i);
  return(k0);
}
