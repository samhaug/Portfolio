/*********************************************************
*			Complex.h
*  header file for dcomplex data type, source codes are in
*  DComplex.c and fft.c
*********************************************************/

// #ifndef __MY_COMPLEX__
// #define __MY_COMPLEX__


/* data type */
typedef struct { double r; double i;} dcomplex;

/* constants */
#define PI	3.1415926
#define TPI	6.283185307179586
#define dImag dcmplx(0., 1.)
#define dOne  dcmplx(1., 0.)
#define dZero dcmplx(0., 0.)

/* basic operations */
dcomplex dcplus(dcomplex a, dcomplex b);
dcomplex dplus(double a, dcomplex b);
dcomplex dcmin(dcomplex a, dcomplex b);
dcomplex dcmltp(dcomplex a, dcomplex b);
dcomplex dcdiv(dcomplex a, dcomplex b);
dcomplex dcngtv(dcomplex a);
dcomplex dmltp(double a, dcomplex b);
dcomplex dconjg(dcomplex a);
dcomplex dcinvs(dcomplex a);
double  dcsqr(dcomplex a);
dcomplex dcsqrt(dcomplex a);
dcomplex dcmplx(double x, double y);
dcomplex dcexp(dcomplex a);
double  dccabs(dcomplex a);

/* fft */
// void    fft(fcomplex *a, int n, int ig);
// void    fftr(fcomplex *x, int n, int ig);
// 
/* convolution and deconvolution, and correlation */
// void	decon(fcomplex *a, fcomplex *b, int nft);
// void	cor(fcomplex *a, fcomplex *b, int nft);
// void	conv(float *, int, float *, int);
// float	*crscrl(int,float *,float *,int);
// 
/* integration */
// float amp(float t1, float t2, float *data, int n);
// 
/* windowing */
// float *coswndw(int, int);
// 
/* high-pass filtering */
// void	filter(fcomplex *, int, float, float, float, int);

// #endif
