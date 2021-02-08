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
#include "/work/jeroen/inc/Complex.h"

/*---------------------------------------------------------------
*   fft()
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
void	fft(a, n, ig)
  fcomplex *a;
  int n;
  int ig;
  {
  int i, j, k, step, m;
  fcomplex u, w, t;
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
    for (u=One,w=cmplx(cos(pi/m),sin(pi/m)),j=0; j<m; j++) {
      for (i=j; i<n; i+=step) {
	k = i+m;
	t = cmltp(a[k], u);
	a[k] = cplus(a[i], cngtv(t));
	a[i] = cplus(a[i], t);
      }
      u = cmltp(u, w);
    }
  }
  if (ig == 1) for (pi=1./n,i=0; i<n; i++) a[i] = dmltp(pi, a[i]);
}



/*---------------------------------------------------------------
*   fftr()
*   fast fourier transform of real sequence x[i], i=0,1,...,2*n-1.
*
*   The amplitude differs from the analog Fourier Transform by dt (see fft()).
*
*   Input arguments:
*   x (fcomplex *)	- array for FFT (IN/OUT)
*   n (int)		- dimension of x[], n=2^N, N>0.
*   ig (int)		- forward (-1) or inverse (1) FFT;
*--------------------------------------------------------------*/
void	fftr(fcomplex *x, int n, int ig) {
  int	i, j, n2;
  float	delw, w;
  fcomplex t, g, h, isg;
  n2 = n/2;
  delw = ig*PI/n;
  isg = cmplx(0., (float) ig);
  if (ig == -1) fft(x, n, ig);
  x[0] = cmplx(x[0].r+x[0].i, x[0].r-x[0].i);
  for (i=1, w=delw; i<n2; i++, w+=delw) {
    j = n-i;
    t = conjg(x[j]);
    g = cplus(x[i], t);
    h = cplus(x[i], cngtv(t));
    h = cmltp(cmplx(cos(w), sin(w)), h);
    x[i] = dmltp(0.5, cplus(g, cmltp(isg,h)));
    x[j] = dmltp(0.5, cplus(conjg(g), cmltp(isg, conjg(h))));
  }
  x[n2] = conjg(x[n2]);
  if (ig == 1) {
    x[0] = dmltp(0.5, x[0]);
    fft(x, n, ig);
  }
}



/*---------------------------------------------------------------
*   fftr_()
*   a wrap of fftr() for fortran calling
*   Input arguments:
*   x (fcomplex *)	- array for FFT (IN/OUT)
*   n (int)	- dimension of the x[], n=2^N, N>0.
*   ig (int)	- forward (-1) or inverse (1) FFT;
*--------------------------------------------------------------*/
void	fftr_(float *x, int n, int ig) {
  fftr((fcomplex *) x, n/2, ig);
}



/* deconvolution, IFFT{data[w]*src[w]} */
void	decon(
	      fcomplex	*src,		/* In: source function */
	      fcomplex     *data,	/* In: data */
	                                /* Out: deconv */
	      int 	nft		/* In: number of pts */
	      )
{
  int	j;

  data[0]=cmplx(data[0].r*src[0].r, data[0].i*src[0].i);
  for (j=1; j<nft; j++) {
    data[j]=cmltp(data[j], src[j]);
  }
  fftr(data, nft, 1);
}



/*
correlation, IFFT{data[w]*conjugate(src[w])}
the zero-lag is at data[nft/2].
*/
void	cor(
	    fcomplex	*src,		/* In: source function */
	    fcomplex     *data,		/* In: data */
	                                /* Out: orrelation */
	    int 	nft		/* In: number of pts */
	    )
{
  int	j;
  float	aa;

  aa = -1.;
  data[0]=cmplx(data[0].r*src[0].r, aa*data[0].i*src[0].i);
  for (j=1; j<nft; j++) {
    data[j]=cmltp(data[j], conjg(src[j]));
    data[j]=dmltp(aa, data[j]);
    aa = -aa;
  }
  fftr(data, nft, 1);
}


/*
   Convolving s[] with f[] in time domain, the result is
   brought back in f[]. so the result will be good for the
   case that s[] is shorter than f[]
*/
void    conv(float *s, int ns, float *f, int n) {
  int   i,j,k,m;
  float *g,*pt;
  m = n+ns;
  g=(float *) malloc(m*sizeof(float));
  for(i=0;i<ns;i++) g[i]=0.;
  for(pt=f,k=0;k<n;k++,i++,pt++){
     g[i]=*pt;
     for(*pt=0.,j=0;j<ns;j++) *pt += g[i-j]*s[j];
  }
  free(g);
}



/*
 cross-correlate rec with syn; only return a window of
 cross-correlation around the zero-lag
*/
float	*crscrl(int npt,float *rec,float *syn,int max_shft) {
  int	i,nft,nft2;
  float	*ss1,*ss2;
  nft=2;while(nft<npt)nft*=2;nft2=nft;nft*=2;
  ss1=(float *)calloc(nft, sizeof(float));
  ss2=(float *)calloc(nft, sizeof(float));
  memcpy((char *)ss1, (char *) rec, npt*sizeof(float));
  memcpy((char *)ss2, (char *) syn, npt*sizeof(float));
  for(i=npt;i<nft;i++) {ss1[i]=0.;ss2[i]=0.;}
  fftr((fcomplex *) ss1,nft2,-1);
  fftr((fcomplex *) ss2,nft2,-1);

  cor((fcomplex *) ss2, (fcomplex *) ss1, nft2);

  nft2 -= max_shft/2;
  i = (max_shft+1)*sizeof(float);
  ss2=(float *)realloc(ss2, i);
  memcpy(ss2, ss1+nft2, i);
  free(ss1);
  return(ss2);
}


/* integrate data[n] between t1 and t2 (normalized time by dt)*/
float amp(float t1, float t2, float *data, int n) {
  int i, it1, it2;
  float dd, am;
  if ( t1 < 0 ) t1=0;
  if ( t2 > n-1 ) t2=n-1;
  if ( t1 > n-1 || t2 < t1) return 0.;
  it1 = floor(t1);
  i = it1 + 1;
  dd = i-t1;
  am = dd*(dd*data[it1]+(2.-dd)*data[i]);
/* return data[it1]*dd + data[i]*(1.-dd);*/
  it2 = ceil(t2);
  while (i<it2) {
    am += data[i]+data[i+1];
    i++;
  }
  dd = i-t2;
  am -= dd*(dd*data[i-1]+(2.-dd)*data[i]);
  return 0.5*am;
}


/* return a taper function 0.5(1+cos(t)) */
float	*coswndw(int nn, int nt1) {
     int   j;
     float t, dt, *wndw;
     if ( (wndw = malloc(nn*sizeof(float))) == NULL) return NULL;
     t = -PI;
     dt = -t/nt1;
     for(j=0;j<=nt1;j++,t+=dt) wndw[j]=0.5*(1+cos(t));
     t = dt = PI/(nn-nt1-1);
     for(;j<nn;j++,t+=dt) wndw[j]=0.5*(1+cos(t));
     return wndw;
}

/* windowing spectrum d[i], sgn=1 -> high-pass; sgn=-1 -> low-pass */
void	filter(fcomplex *d, int n, float f1, float f2, float dt, int sgn) {
     int i, if1, if2;
     float a;
     dt = 0.5/dt/n;
     if1 = rint(f1/dt);
     if2 = rint(f2/dt); if (if2>=n) if2=n-1;
     if (if2<=if1) {
	fprintf(stderr, "filter freq. wrong f2<f1\n");
	return;
     }
     dt = PI/(if2-if1);
     for(a=0.,i=if1;i<if2;i++,a+=dt) d[i] = dmltp(0.5*(1-sgn*cos(a)), d[i]);
     if (sgn<0) {
	for(i=if2;i<n;i++) d[i] = Zero;
	d[0].i = 0.;
     } else  {
        d[0].r = 0.;
        for(i=1;i<if1;i++) d[i] = Zero;
     }
}
