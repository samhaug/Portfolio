/* ---   PPP   ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */
                                                                                      
extern char stnam[6], chnam[6];
extern char datcode[8];

extern int i30s, i50s;
extern int jrvw, jlog;
extern int PPPsample;
extern int Wlength, Mshift, decim;

extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float Z_noise, Z_noise_window, Z_noise_winMin;

extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;

extern float PPPtime, pPPtime, sPPtime;
extern float SKPtime, pSKPtime, sSKPtime;
extern float PhaseSepTime;

void measure_PPP(pck,log,rvw)
FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= PPP\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
if ( fabs(PPPtime-SKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPPtime-SKPtime= %5.1f\n",
                stnam,chnam,PPPtime-SKPtime);
   }
   return;
}
if ( fabs(PPPtime-pPPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPPtime-pPPtime= %5.1f\n",
                stnam,chnam,PPPtime-pPPtime);
   }
   return;
}
if ( fabs(PPPtime-sPPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPPtime-sPPtime= %5.1f\n",
                stnam,chnam,PPPtime-sPPtime);
   }
   return;
}
if ( fabs(PPPtime-pSKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPPtime-pSKPtime= %5.1f\n",
                stnam,chnam,PPPtime-pSKPtime);
   }
   return;
}
if ( fabs(PPPtime-sSKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PPPtime-sSKPtime= %5.1f\n",
                stnam,chnam,PPPtime-sSKPtime);
   }
   return;
}



/* Check ENVELOPE noise level
   -- Defined as the minimum amplitude of ENV_DATA.   ----*/
iwindow1 = PPPsample-i50s;
iwindow2 = PPPsample+i50s;
signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log);

/*--  Check whether PPP signal is well above noise level --*/
if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] PPP_env amplitude is too small: %7.1f ...\n",
                stnam,chnam,envAmpRatio);
   }
   return;
}

/* Determine peak-to-trough PPP amplitude: */
iwindow1 = PPPsample - i30s; iwindow2 = PPPsample + i30s;
signallevel(iwindow1,iwindow2,data,1,&Amp,log);
if ( (Amp/Z_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s  PPP_amp/Z_noise smaller than allowed ...\n", stnam);
   }
   return;
}
/*  OUTPUT ....  */
if (jrvw) fprintf(rvw,"PPP   %s\n", datcode);
if (jrvw) write_review1(rvw,PPPsample,Amp,Z_noise,Z_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/Z_noise, envAmpRatio);


/* PROCESSING ---------------------------*/
usefulrec = PROCESSING(data,synt,PPPsample,Wlength,Mshift,decim,log,pck,rvw);
fprintf(pck,"%-8s","PPP");
fprintf(pck,"%2d\n",usefulrec);


return;
}
