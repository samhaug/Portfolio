#include <stdio.h>
#include <math.h>

/* TTable has 160 indices.
   It contains travel times betwen 21 and 180 degrees */


void extractTTime(TTable, gcarc, ttime)

    float *TTable;
    float  gcarc;
    float *ttime;
{

int   i;
float dist, f1, f2;


*ttime = -999.;
if (gcarc < 1. || gcarc > 180.) 
  fprintf(stderr,"IN extractTTime:   GCARC is %f\n", gcarc);

for(i=0; i<180; ++i) {
   dist = 1. + i*1.;
   if (gcarc < dist) {
     f1 = dist - gcarc;
     f2 = TTable[i] - TTable[i-1];
     *ttime = TTable[i-1] + f1*f2;
     //fprintf(stdout,"i= %d gcarc= %f dist= %f T1= %f T0= %f ttime= %f\n",
     //  i, gcarc, dist,TTable[i], TTable[i-1], *ttime);
     goto cont;
   }
}

cont:
//fprintf(stdout,"IN extractTTime: gcarc= %f ttime= %f\n", gcarc, *ttime);
return;

}
