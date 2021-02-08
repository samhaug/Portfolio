/* ---   SSS    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used */

/*  ---  Global variables  ---  */
                                                                                                                                                       
extern char stnam[6], chnam[6];
extern char datcode[8];
                                                                                                                                                       
extern int i30s, i50s;
extern int jrvw, jlog;
extern int SSSsample;
extern int Wlength, Mshift, decim;
                                                                                                                                                       
extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float T_noise, T_noise_window, T_noise_winMin;
                                                                                                                                                       
extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;
                                                                                                                                                       
extern float SSStime, sSStime, ScSScStime;
extern float PhaseSepTime;

void measure_SSS(pck,log,rvw)
FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= SSS\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
if ( fabs(SSStime-sSStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SSStime-sSStime= %5.1f\n",
                stnam,chnam,SSStime-sSStime);
   }
   return;
}
if ( fabs(SSStime-ScSScStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SSStime-ScSScStime= %5.1f\n",
                stnam,chnam,SSStime-ScSScStime);
   }
   return;
}


/* Check ENVELOPE noise level
   -- Defined as the minimum amplitude of ENV_DATA.   ----*/
iwindow1 = SSSsample-i50s;
iwindow2 = SSSsample+i50s;
signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log);

/*--  Check whether SSS signal is well above noise level --*/
if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] SSS_env amplitude is too small: %7.1f ...\n",
                stnam,chnam,envAmpRatio);
   }
   return;
}

/* Determine peak-to-trough SSS amplitude: */
iwindow1 = SSSsample - i30s; iwindow2 = SSSsample + i30s;
signallevel(iwindow1,iwindow2,data,1,&Amp,log);
if ( (Amp/T_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s  SSS_amp/T_noise smaller than allowed ...\n", stnam);
   }
   return;
}
/*  OUTPU