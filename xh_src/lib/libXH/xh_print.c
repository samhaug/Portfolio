#include <stdio.h>
#include <string.h>
#include <math.h>
//#include <malloc.h>
#include "xhhead.h"
#include "Complex.h"

int xh_print(data1,data2,data3,dt,numsamp)
float data1[];
float data2[];
float data3[];
float dt;
int numsamp;
{

fcomplex x1[16384];
fcomplex x2[16384];
fcomplex z2[16384];
fcomplex imag;

fprintf(stdout,"in xh_print numsamp= %d\n", numsamp);
fprintf(stdout,"in xh_print data1[100]= %f\n", data1[100]);
fprintf(stdout,"in xh_print data2[100]= %f\n", data2[100]);
fprintf(stdout,"in xh_print dt= %f\n", dt);
return (1);
}
