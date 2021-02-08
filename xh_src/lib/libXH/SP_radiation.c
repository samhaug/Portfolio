#include        <stdlib.h>
#include        <stdio.h>
#include        <math.h>
#include        "ndk.h"


int SP_radiation(evtcd,slat,slon,SP_amp,PS_amp)
char   evtcd[];
float  slat, slon;
float *SP_amp, *PS_amp;
{

float  elat, elon,edep;
float  gcarc, az, baz;
float  rayp[1960];
float  z[39];
float  vp[39], vs[39];
float  Pvel, Svel;
float  rayp_SP, rayp_PS, sinPS,sinSP, SP_ang, PS_ang, SP_ampl, PS_ampl;
float  rad2deg;
int    i, j, index=0;
char   ss[120];
cmthed cmt;
FILE   *fp, *fopen();

rad2deg = 180./(4.*atan(1.));

*SP_amp = 0.;
*PS_amp = 0.;

if (! read_cmtheader(evtcd, &cmt))
  return(0);
elat = cmt.centroid_lat;
elon = cmt.centroid_lon;
edep = cmt.centroid_dep;

// Get distance (degrees) and azimuth
if (! distaz(slat,slon,elat,elon,&gcarc,&az,&baz)) {
  fprintf(stderr, "DISTAZ error in SP_radiation ...\n");
  return(0);
}
if (gcarc > 139. || gcarc < 80.) {
  fprintf(stderr, "SP_radiation() GCARC= %6.2f outside acceptable range ...\n", gcarc);
  return(0);
}

// get Vs, Vp, and rho at the source
fp = fopen("/work/jeroen/Utils/Models/1D_models/premmodel","r");
for(i=0;i<39;i++) {
  fscanf(fp,"%f %f %f", &z[i], &vp[i], &vs[i]);
}
fclose(fp);
for(i=0;i<39;i++) {
  if(edep<z[i]) {
    Pvel = vp[i-1] + (edep-z[i-1])/(z[i]-z[i-1])*(vp[i]-vp[i-1]);
    Svel = vs[i-1] + (edep-z[i-1])/(z[i]-z[i-1])*(vs[i]-vs[i-1]);
    break;
  }
}

// get SP ray parameter
// tt.SP in UTILS is a table of rayp as a function
// of source depth and epicentral distance
i = (int) floorf(edep/25.);
j = (int) floorf(gcarc-70.);
index = i*70 + j;
fp = fopen("/work/jeroen/Utils/TauP_calculations/SP/tt.SP","r");
for(i=0;i<1960;i++) {
  fgets(ss,120,fp);
  sscanf(ss,"%*f %*f %*s %*f %f", &rayp[i]);
}
fclose(fp);
rayp_SP = rayp[index];
fp = fopen("/work/jeroen/Utils/TauP_calculations/SP/tt.PS","r");
for(i=0;i<1960;i++) {
  fgets(ss,120,fp);
  sscanf(ss,"%*f %*f %*s %*f %f", &rayp[i]);
}
fclose(fp);
rayp_PS = rayp[index];

//fprintf(stdout,"index= %d rayp_SP= %f rayp_PS= %f\n", index,rayp_SP,rayp_PS);

if (rayp_SP > 0.) {
  sinSP  = rayp_SP/111.195*Svel;
  SP_ang = asinf(sinSP)*rad2deg;
  if (! get_sv_rad(cmt, az, SP_ang, &SP_ampl)) { 
    fprintf(stderr,"Error get_sv_rad() ...\n");
    return(0);
  }
}
if (rayp_PS > 0.) {
  sinPS  = rayp_PS/111.195*Pvel;
  PS_ang = asinf(sinPS)*rad2deg;
  if (! get_p_rad(cmt, az, PS_ang, &PS_ampl)) {
    fprintf(stderr,"Error get_p_rad() ...\n");
    return(0);
  }
}
// fprintf(stdout,"ray_par= %f Svel= %f sinSP= %f SP_angle= %f\n",
//     rayp_SP,Svel,sinSP, SP_ang);
// fprintf(stdout,"ray_par= %f Pvel= %f sinPS= %f PS_angle= %f\n",
//     rayp_PS,Pvel,sinPS, PS_ang);

*SP_amp = SP_ampl;
*PS_amp = PS_ampl;
// fprintf(stdout,"inc= %f SP_amp= %f PS_amp= %f\n", SP_ang, *SP_amp, *PS_amp);

return(1);
}
