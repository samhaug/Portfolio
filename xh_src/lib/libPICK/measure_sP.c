/* ---   SP    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

extern char stnam[6], chnam[6];
extern char datcode[8];

extern int i30s, i50s;
extern int jrvw, jlog;
extern int SPsample;
extern int Wlength, Mshift, decim;


extern float SignalToNoise, envAmpRatio_Min;
extern float data_sp[npts_dat], synt_sp[npts_dat], env_sp[npts_dat];
extern float L_noise, L_noise_window, L_noise_winMin;

extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;

extern float SPtime, PStime, Stime, sStime, pStime;
extern float sSKStime, pSKStime, sSKKStime, pSKKStime;
extern float PhaseSepTime;

extern float SP_amp, PS_amp;

void measure_SP(pck,log,rvw)

   
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= SP\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
//if ( fabs(SPtime-PStime) < PhaseSepTime) {
//   if (jlog) {
//     fprintf(log,"%s [%s] discarded because SPtime-PStime= %5.1f\n",
//                stnam,chnam,SPtime-PStime);
//   }
//   return;
//}
if ( fabs(SPtime-Stime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SPtime-Stime= %5.1f\n",
                stnam,chnam,SPtime-Stime);
   }
   return;
}
if ( fabs(SPtime-sStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SPtime-sStime= %5.1f\n",
                stnam,chnam,SPtime-sStime);
   }
   return;
}
if ( fabs(SPtime-pStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SPtime-pStime= %5.1f\n",
                stnam,chnam,SPtime-pStime);
   }
   return;
}
if ( fabs(SPtime-sSKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SPtime-sSKStime= %5.1f\n",
                stnam,chnam,SPtime-sSKStime);
   }
   return;
}
if ( fabs(SPtime-pSKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SPtime-pSKStime= %5.1f\n",
                stnam,chnam,SPtime-pSKStime);
   }
   return;
}
if ( fabs(SPtime-sSKKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SPtime-sSKKStime= %5.1f\n",
                stnam,chnam,SPtime-sSKKStime);
   }
   return;
}
if ( fabs(SPtime-pSKKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SPtime-pSKKStime= %5.1f\n",
                stnam,chnam,SPtime-pSKKStime);
   }
   return;
}
}


/* Check ENVELOPE noise level
   -- Defined as the minimum ampli*/
