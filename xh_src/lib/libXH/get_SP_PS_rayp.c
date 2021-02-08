#include        <stdlib.h>
#include        <stdio.h>
#include        <math.h>
#include        "ndk.h"

// get SP and PS ray parameters

int get_SP_PS_rayp(edep,gcarc,rayp_SP,rayp_PS)
float  edep, gcarc;
float *rayp_SP, *rayp_PS;
{

float  rayp[1960];
int    i, j, index=0;
char   ss[120];
FILE   *fp, *fopen();


i = (int) floorf(edep/25.);
j = (int) floorf(gcarc-70.);
index = i*70 + j;

fp = fopen("/work/jeroen/Utils/TauP_calculations/SP/tt.SP","r");
for(i=0;i<1960;i++) {
  fgets(ss,120,fp);
  sscanf(ss,"%*f %*f %*s %*f %f", &rayp[i]);
}
fclose(fp);
*rayp_SP = rayp[index];

fp = fopen("/work/jeroen/Utils/TauP_calculations/SP/tt.PS","r");
for(i=0;i<1960;i++) {
  fgets(ss,120,fp);
  sscanf(ss,"%*f %*f %*s %*f %f", &rayp[i]);
}
fclose(fp);
*rayp_PS = rayp[index];

//fprintf(stdout,"IN get_SP_PS_rayp() index= %d rayp_SP= %f rayp_PS= %f\n", index,*rayp_SP,*rayp_PS);

return(1);
}
