/* ---   PP    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

extern char stnam[6], chnam[6];
extern char datcode[8];
                                                                                                                                                       
extern int i30s, i50s;
extern int jrvw, jlog;
extern int PPsample;
extern int Wlength, Mshift, decim;
                                                                                                                                                       
extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float Z_noise, Z_noise_window, Z_noise_winMin;
                                                                                                                                                       
extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;
extern float PPtime, sPtime, pPtime;
extern float SKPtime, pSKPtime, sSKPtime, pPKIKPtime, sPKIKPtime;
extern float PhaseSepTime;

void measure_PP(pck,log,rvw)
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  AmpRatio;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= PP\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
if ( fabs(PPtime-pPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPtime-pPtime= %5.1f\n",
                stnam,chnam,PPtime-pPtime);
   }
   Z_noise = 0.;
}
if ( fabs(PPtime-sPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPtime-sPtime= %5.1f\n",
                stnam,chnam,PPtime-sPtime);
   }
   Z_noise = 0.;
}
if ( fabs(PPtime-SKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPtime-SKPtime= %5.1f\n",
                stnam,chnam,PPtime-SKPtime);
   }
   Z_noise = 0.;
}
if ( fabs(PPtime-sSKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPtime-sSKPtime= %5.1f\n",
                stnam,chnam,PPtime-sSKPtime);
   }
   Z_noise = 0.;
}
if ( fabs(PPtime-pSKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPtime-pSKPtime= %5.1f\n",
                stnam,chnam,PPtime-pSKPtime);
   }
   Z_noise = 0.;
}
if ( fabs(PPtime-pPKIKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPtime-pPKIKPtime= %5.1f\n",
                stnam,chnam,PPtime-pPKIKPtime);
   }
}
}
