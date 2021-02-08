#include <math.h>
#include <stdio.h>
#include "ndk.h"
#define  DEGRAD  0.01745329


// see Aki and Richards, 1980 section 4.5.2

int get_sv_rad(h,azim,inc,SV_amp)
cmthed h;
float azim, inc, *SV_amp;
{
    float P[3], SV[3];
    float Mxx=0., Myy=0., Mzz=0., Mxy=0., Mxz=0., Myz=0.;
    float strike, dip, rake;
    float rad;
    
    rad = 4.*atanf(1.)/180.;
    strike  = h.strike1*rad;
    dip     = h.dip1*rad;
    rake    = h.rake1*rad;

    P[0] =  sinf(inc*rad)*cosf(azim*rad);
    P[1] =  sinf(inc*rad)*sinf(azim*rad);
    P[2] =  cosf(inc*rad);
   SV[0] =  cosf(inc*rad)*cosf(azim*rad);
   SV[1] =  cosf(inc*rad)*sinf(azim*rad);
   SV[2] = -sinf(inc*rad);


    Mxx = Mxx + sinf(dip)*cosf(rake)*sinf(2.*strike);
    Mxx = Mxx + sinf(2.*dip)*sinf(rake)*sinf(strike)*sinf(strike);
    Mxx = -Mxx;

    Mxy = Mxy + sinf(dip)*cosf(rake)*cosf(2.*strike);
    Mxy = Mxy + 0.5*sinf(2.*dip)*sinf(rake)*sinf(2.*strike);

    Mxz = Mxz + cosf(dip)*cosf(rake)*cosf(strike);
    Mxz = Mxz + cosf(2.*dip)*sinf(rake)*sinf(strike);
    Mxz = -Mxz;

    Myy = Myy + sinf(dip)*cosf(rake)*sinf(2.*strike);
    Myy = Myy - sinf(2.*dip)*sinf(rake)*cosf(strike)*cosf(strike);
    
    Myz = Myz + cosf(dip)*cosf(rake)*sinf(strike);
    Myz = Myz - cosf(2.*dip)*sinf(rake)*cosf(strike);
    Myz = -Myz;

    Mzz = Mzz + sinf(2.*dip)*sinf(rake);

//  fprintf(stdout,"%4.2f %4.2f %4.2f\n", Mxx, Mxy, Mxz);
//  fprintf(stdout,"%4.2f %4.2f %4.2f\n", Mxy, Myy, Myz);
//  fprintf(stdout,"%4.2f %4.2f %4.2f\n", Mxz, Myz, Mzz);
//  fprintf(stdout,"%d %d %d\n", h.strike1, h.dip1, h.rake1);
//  fprintf(stdout,"%d %d %d\n", h.strike2, h.dip2, h.rake2);

   *SV_amp   = Mxx*P[0]*SV[0]+Myy*P[1]*SV[1]+Mzz*P[2]*SV[2]; 
   *SV_amp  += Mxy*(P[0]*SV[1]+P[1]*SV[0]);
   *SV_amp  += Mxz*(P[0]*SV[2]+P[2]*SV[0]);
   *SV_amp  += Myz*(P[2]*SV[1]+P[1]*SV[2]);
 
// *SV_amp /=  h.M0;

   return(1);
}
