/* ---   sScSScS    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

extern char stnam[6], chnam[6];
extern char datcode[8];
                                                                                                                                                 
extern int i30s, i50s;
extern int jrvw, jlog;
extern int sScSScSsample;
extern int Wlength, Mshift, decim;
extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float T_noise, T_noise_window, T_noise_winMin;
extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;
extern float sScSScStime, SStime, sSStime, SSStime, sSSStime;
extern float PhaseSepTime;

void measure_sScSScS(pck,log,rvw)

   
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= sScSScS\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
if ( fabs(sScSScStime-SStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sScSScStime-SStime= %5.1f\n",
                stnam,chnam,sScSScStime-SStime);
   }
   return;
}
if ( fabs(sScSScStime-sSStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sScSScStime-sSStime= %5.1f\n",
                stnam,chnam,sScSScStime-sSStime);
   }
   return;
}
if ( fabs(sScSScStime-SSStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sScSScStime-SSStime= %5.1f\n",
                stnam,chnam,sScSScStime-SSStime);
   }
   return;
}
if ( fabs(sScSScStime-sSSStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sScSScStime-sSSStime= %5.1f\n",
                stnam,chnam,sScSScStime-sSSStime);
   }
   return;
}

/* Check ENVELOPE noise level
   -- Defined as the minimum amplitude of ENV_DATA.   ----*/
iwindow1 = sScSScSsample-i50s;
iwindow2 = sScSScSsample+i50s;
signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log);

/*--  Check whether sScSScS signal is well above noise level --*/
if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] sScSScS_env amplitude is too small: %7.1f ...\n",
                stnam,chnam,envAmpRatio);
   }
   return;
}

/* Determine peak-to-trough sScSScS amplitude: */
iwindow1 = sScSScSsample - i30s; iwindow2 = sScSScSsample + i30s;
signallevel(iwindow1,iwindow2,data,1,&Amp,log);
if ( (Amp/T_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s  sScSScS_amp/T_noise smaller than allowed ...\n", stnam);
   }
   return;
}
/*  OUTPUT ....  */
if (jrvw) fprintf(rvw,"sScSScS   %s\n", datcode);
if (jrvw) write_review1(rvw,sScSScSsample,Amp,T_noise,T_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/T_noise, envAmpRatio);


/* PROCESSING ---------------------------*/
usefulrec = PROCESSING(data,synt,sScSScSsample,Wlength,Mshift,decim,log,pck,rvw);
fprintf(pck,"%-8s","sScSScS");
fprintf(pck,"%2d\n",usefulrec);


return;
}
