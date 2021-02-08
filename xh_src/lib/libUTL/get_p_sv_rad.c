#include <math.h>
#include "ndk.h"
#define  DEGRAD  0.01745329


// see Aki and Richards, 1980 section 4.5.2

int get_p_sv_rad(h,azim,inc,SV_amp,P_amp)
cmthed h;
float azim, inc, *SV_amp, *P_amp;
{
   float P[3], SV[3];

    P[1] = -sin(inc*DEGRAD)*cos(azim*DEGRAD);  // THETA = - North
    P[2] = +sin(inc*DEGRAD)*sin(azim*DEGRAD);  // PHI   =   East 
    P[0] = -cos(inc*DEGRAD);                   // RRR   = - Down

   SV[1] = -cos(inc*DEGRAD)*cos(azim*DEGRAD);
   SV[2] = +cos(inc*DEGRAD)*sin(azim*DEGRAD);
   SV[0] = +sin(inc*DEGRAD);

   *SV_amp  = h.Mrr*P[0]*SV[0]+h.Mtt*P[1]*SV[1]+h.Mpp*P[2]*SV[2]; 
   *SV_amp += h.Mrt*(P[0]*SV[1]+P[1]*SV[0]);
   *SV_amp += h.Mrp*(P[0]*SV[2]+P[2]*SV[0]);
   *SV_amp += h.Mtp*(P[2]*SV[1]+P[1]*SV[2]);

   *P_amp   = h.Mrr*P[0]*P[0]+h.Mtt*P[1]*P[1]+h.Mpp*P[2]*P[2]; 
   *P_amp  += h.Mrt*(P[0]*P[1]+P[1]*P[0]);
   *P_amp  += h.Mrp*(P[0]*P[2]+P[2]*P[0]);
   *P_amp  += h.Mtp*(P[2]*P[1]+P[1]*P[2]);
/*
BUG FIX??? LUIS had it this way ... mistake???
   *SV_amp  = h.Mrr*P[0]*SV[0]+h.Mtt*P[1]*SV[1]+h.Mpp*P[2]*SV[2]; 
   *SV_amp += h.Mrt*(P[0]*SV[1]+P[1]*SV[0]);
   *SV_amp += h.Mrp*(P[1]*SV[2]+P[2]*SV[1]);
   *SV_amp += h.Mtp*(P[2]*SV[0]+P[0]*SV[2]);
*/

 
   if(h.eigval1 > -h.eigval3) {
	 *SV_amp /=  h.eigval1;
	 *P_amp /=  h.eigval1;
   } else {
	 *SV_amp /= -h.eigval3;
	 *P_amp /= -h.eigval3;
   }

   return(1);
}
