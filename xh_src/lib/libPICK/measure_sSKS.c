/* ---    sSKS    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

extern char stnam[6], chnam[6];
extern char datcode[8];
extern int i30s, i50s;
extern int jrvw, jlog;
extern int sSKSsample;
extern int Wlength, Mshift, decim;
extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float L_noise, L_noise_window, L_noise_winMin;
extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;
extern float sSKStime, pSKStime, Stime, sStime, SKKStime;
extern float PhaseSepTime;

void measure_sSKS(pck,log,rvw)

   
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


  if (jlog) fprintf(log,"\n                                          PHASE= sSKS\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
if ( fabs(sSKStime-pSKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sSKStime-pSKStime= %5.1f\n",
                stnam,chnam,sSKStime-pSKStime);
   }
   return;
}
if ( fabs(sSKStime-SKKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sSKStime-SKKStime= %5.1f\n",
                stnam,chnam,sSKStime-SKKStime);
   }
   return;
}
if ( fabs(sSKStime-Stime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sSKStime-Stime= %5.1f\n",
                stnam,chnam,sSKStime-Stime);
   }
   return;
}
if ( fabs(sSKStime-sStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sSKStime-sStime= %5.1f\n",
                stnam,chnam,sSKStime-sStime);
   }
   return;
}

  /* Check ENVELOPE noise level
     -- Defined as the minimum amplitude of ENV_DATA.   ----*/   
  iwindow1 = sSKSsample-i50s;
  iwindow2 = sSKSsample+i50s;
  signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log); 

  /*--  Check whether sSKS signal is well above noise level --*/
  if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] sSKS_env amplitude is too small: %7.1f ...\n",
                  stnam,chnam,envAmpRatio);
   }
   return;
  }

  /* Determine peak-to-trough sSKS amplitude: */
  iwindow1 = sSKSsample - i30s; iwindow2 = sSKSsample + i30s;
  signallevel(iwindow1,iwindow2,data,1,&Amp,log); 
  if ( (Amp/L_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because sSKS_amp/L_noise= %5.1f\n",
                  stnam,chnam,Amp/L_noise);
   }
   return;
  }
  /*  OUTPUT .... */
  if (jrvw) fprintf(rvw,"sSKS   %s\n", datcode);
  if (jrvw) write_review1(rvw,sSKSsample,Amp,L_noise,L_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/L_noise, envAmpRatio);


  /* PROCESSING ---------------------------*/
  usefulrec = PROCESSING(data,synt,sSKSsample,Wlength,Mshift,decim,log,pck,rvw);

  fprintf(pck,"%-8s","sSKS");
  fprintf(pck,"%2d\n",usefulrec);

return;
}
