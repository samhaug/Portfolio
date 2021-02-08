/*
 * Julian    - Compute the julian calendar day 
 *
 */

#include <stdio.h>
#include <math.h>
#include <string.h>

int julian(year, month, day)
   int   year, month, day;
{

int     i, days[13], jday=0;
float   y;

days[1]  = 31; days[3]  = 31; days[5]  = 31; days[7]  = 31;
days[8]  = 31; days[10] = 31; days[12] = 31;
days[4]  = 30; days[6]  = 30; days[9]  = 30; days[11] = 30;
days[2]  = 28;

if ( year < 100 ) {
    y = (year + 1900) * 1.;
} else {
    y = year * 1.;
}
if ( fmodf(year,4.)    == 0.) days[2] = 29; 
if ( fmodf(year,100.)  == 0.) days[2] = 28; 
if ( fmodf(year,1000.) == 0.) days[2] = 29; 

i = 1;
while (i < month) {
   jday = jday + days[i];
   ++i;
}
jday = jday + day;

return(jday);
}
