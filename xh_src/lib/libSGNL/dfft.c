/*****************************************************************
-			fft.c
-	subroutines doing fast fourier transform, correlation
-	and deconvolution
-
- Includes:
-	fft()	- for complex sequence
-	fftr()	- for real sequence
-	fftr_() - wrap of fftr for fortran calling
-	decon() - deconvolution of two complex sequences
-	cor()	- correlation of two complex sequences
-	crscrl()- cross-correlation of two time seq., returns a portion
-       conv()  - convolve two time seq.,
-	amp()	- integrate a time seq. between two points
-	coswndw() - applying a cosine taper window to data
-	filter()	- high-pass filtering data in frequency domain
-
- Revision History
-	Lupei Zhu	06/20/94	Initial revision
-	Lupei Zhu	12/02/99	conv() now can handle ns>n
******************************************************************/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "DComplex.h"

/*---------------------------------------------------------------
*   dfft()
*   fast fourier transform of complex sequence x[i], i=0,1,...,n-1.
*
*	fft{x}[i] = SUM x[k] exp(-j*i*k*pi/n) over k=0 to n-1
*
*   The amplitude of foward transform differs from the analog Fourier
*   Transform by factor of dt (should be divided by dt).
*
*   Input arguments:
*   x (fcomplex *)	- array for FFT (IN/OUT)
*   n (int)	- dimension of x[], n=2^N, N>0.
*   ig	(int)	- forward (-1) or inverse (1) FFT;
*--------------------------------------------------------------*/
void	dfft(a, n, ig)
  dcomplex *a;
  int n;
  int ig;
  {
  int i, j, k, step, m;
  dcomplex u, w, t;
  double pi;
  pi = ig*PI;
  for (m=n/2,j=0,i=1; i<n-1; i++) {
    for (k=m; k<=j; k/=2) j -= k;
    j += k;
    if(i<j) {
      t = a[i];
      a[i] = a[j];
      a[j] = t;
    }
  }
  for (m=1,step=2; m<n; m=step, step*=2) {
    for (u=dOne,w=dcmplx(cos(pi/m),sin(pi/m)),j=0; j<m; j++) {
      for (i=j; i<n; i+=step) {
	k = i+m;
	t = dcmltp(a[k], u);
	a[k] = dcplus(a[i], dcngtv(t));
	a[i] = dcplus(a[i], t);
      }
      u = dcmltp(u, w);
    }
  }
  if (ig == 1) for (pi=1./n,i=0; i<n; i++) a[i] = dmltp(pi, a[i]);
}

