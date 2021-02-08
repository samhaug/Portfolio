/*********************************************************
*			Complex.h
*  header file for fcomplex data type, source codes are in
*  Complex.c and fft.c
*********************************************************/

#ifndef __MY_COMPLEX__
  #define __MY_COMPLEX__


/* data type */
typedef struct { float r; float i;} fcomplex;

/* constants */
#define PI	3.1415926
#define TPI	6.283185307179586
#define Imag cmplx(0., 1.)
#define One  cmplx(1., 0.)
#define Zero cmplx(0., 0.)

/* basic operations */
fcomplex cplus(fcomplex a, fcomplex b);
fcomplex dplus(float a, fcomplex b);
fcomplex cmin(fcomplex a, fcomplex b);
fcomplex cdiv(fcomplex a, fcomplex b);
fcomplex cmltp(fcomplex a, fcomplex b);
fcomplex cngtv(fcomplex a);
fcomplex cinvs(fcomplex a);
fcomplex conjg(fcomplex a);
fcomplex dmltp(float a, fcomplex b);
fcomplex csqroot(fcomplex a);
fcomplex cexpon(fcomplex a);
fcomplex cmplx(float x, float y);
fcomplex cphase(fcomplex w);
double  ccabs(fcomplex a);
double  csqr(fcomplex a);

/* fft */
void    fft(fcomplex *a, int n, int ig);
void    fftr(fcomplex *x, int n, int ig);

/* convolution and deconvolution, and correlation */
void	decon(fcomplex *a, fcomplex *b, int nft);
void	cor(fcomplex *a, fcomplex *b, int nft);
void	conv(float *, int, float *, int);
float	*crscrl(int,float *,float *,int);

/* integration */
float amp(float t1, float t2, float *data, int n);

/* windowing */
float *coswndw(int, int);

/* high-pass filtering */
void	filter(fcomplex *, int, float, float, float, int);

#endif
