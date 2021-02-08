/* ---   ScSScS    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */
                                                                                      
extern char stnam[6], chnam[6];
extern char datcode[8];

extern int i30s, i50s;
extern int jrvw, jlog;
extern int ScSScSsample;
extern int Wlength, Mshift, decim;

extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float T_noise, T_noise_window, T_noise_winMin;

extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;
extern float ScSScStime, SStime, sSStime, SSStime, sSSStime;
extern float PhaseSepTime;

void measure_ScSScS(pck,log,rvw)
FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= ScSScS\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
if ( fabs(ScSScStime-SStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because ScSScStime-SStime= %5.1f\n",
                stnam,chnam,ScSScStime-SStime);
   }
   return;
}
if ( fabs(ScSScStime-sSStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because ScSScStime-sSStime= %5.1f\n",
                stnam,chnam,ScSScStime-sSStime);
   }
   return;
}
if ( fabs(ScSScStime-SSStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because ScSScStime-SSStime= %5.1f\n",
                stnam,chnam,ScSScStime-SSStime);
   }
   return;
}
if ( fabs(ScSScStime-sSSStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because ScSScStime-sSSStime= %5.1f\n",
                stnam,chnam,ScSScStime-sSSStime);
   }
   return;
}

/* Check ENVELOPE noise level
   -- Defined as the minimum amplitude of ENV_DATA.   ----*/
iwindow1 = ScSScSsample-i50s;
iwindow2 = ScSScSsample+i50s;
signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log);

/*--  Check whether ScSScS signal is well above noise level --*/
if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] ScSScS_env amplitude is too small: %7.1f ...\n",
                stnam,chnam,envAmpRatio);
   }
   return;
}

/* Determine peak-to-trough ScSScS amplitude: */
iwindow1 = ScSScSsample - i30s; iwindow2 = ScSScSsample + i30s;
signallevel(iwindow1,iwindow2,data,1,&Amp,log);
if ( (Amp/T_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s  ScSScS_amp/T_noise smaller than allowed ...\n", stnam);
   }
   return;
}
/*  OUTPUT ....  */
if (jrvw) fprintf(rvw,"ScSScS   %s\n", datcode);
if (jrvw) write_review1(rvw,ScSScSsample,Amp,T_noise,T_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/T_noise, envAmpRatio);


/* PROCESSING ---------------------------*/
usefulrec = PROCESSING(data,synt,ScSScSsample,Wlength,Mshift,decim,log,pck,rvw);
fprintf(pck,"%-8s","ScSScS");
fprintf(pck,"%2d\n",usefulrec);


return;
}
