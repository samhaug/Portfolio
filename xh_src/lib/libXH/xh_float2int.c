#include <stdio.h>
#include <math.h>

/*------------------------------------
 checks whether the float F, which is either
 xh.pole[0].re or xh.zero[0].re
 (the numer of poles or zeros),
 is an integer,i.e. it end with ".000000",
 and larger than 0.
 Returns lrint(F) if so, else it returns "-1".

 For example:
   xh_float2int(2.000) = 2
   xh_float2int(9.000) = 9
   xh_float2int(3.001) = -1
   xh_float2int(-9.00) = -1
         
 See xhhead.h
------------------------------------*/
                                                                                
int xh_float2int(f)
float f;
{

if ( f>= 0. && ceilf(f)==floorf(f) ) {
  return( lrint(f) );
} else {
  // fprintf(stderr,"ceil= %f  floor= %f trunc= %f\n", ceilf(f), floorf(f), truncf(f));
  return (-1);
}
}
