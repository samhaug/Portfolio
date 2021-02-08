/* ---   PS    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

extern char stnam[6], chnam[6];
extern char datcode[8];

extern int i30s, i50s;
extern int jrvw, jlog;
extern int PSsample;
extern int Wlength, Mshift, decim;


extern float SignalToNoise, envAmpRatio_Min;
extern float data_ps[npts_dat], synt_ps[npts_dat], env_ps[npts_dat];
extern float L_noise, L_noise_window, L_noise_winMin;

extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;

extern float SPtime, PStime, Stime, sStime, pStime;
extern float sSKStime, pSKStime, sSKKStime, pSKKStime;
extern float PhaseSepTime;

extern float SP_amp, PS_amp;


void measure_PS(pck,log,rvw)

   
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= PS\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
//if ( fabs(SPtime-PStime) < PhaseSepTime) {
//   if (jlog) {
//     fprintf(log,"%s [%s] discarded because SPtime-PStime= %5.1f\n",
//                stnam,chnam,SPtime-PStime);
//   }
//   return;
//}
if ( fabs(PStime-Stime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PStime-Stime= %5.1f\n",
                stnam,chnam,PStime-Stime);
   }
   return;
}
if ( fabs(PStime-sStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PStime-sStime= %5.1f\n",
                stnam,chnam,PStime-sStime);
   }
   return;
}
if ( fabs(PStime-pStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PStime-pStime= %5.1f\n",
                stnam,chnam,PStime-pStime);
   }
   return;
}
if ( fabs(PStime-sSKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PStime-sSKStime= %5.1f\n",
                stnam,chnam,PStime-sSKStime);
   }
   return;
}
if ( fabs(PStime-pSKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PStime-pSKStime= %5.1f\n",
                stnam,chnam,PStime-pSKStime);
   }
   return;
}
if ( fabs(PStime-sSKKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PStime-sSKKStime= %5.1f\n",
                stnam,chnam,PStime-sSKKStime);
   }
   return;
}
if ( fabs(PStime-pSKKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PStime-pSKKStime= %5.1f\n",
                stnam,chnam,PStime-pSKKStime);
   }
   return;
}


/* Check ENVELOPE noise level
   -- Defined as the minimum amplitude of ENV_DATA.   ----*/
iwindow1 = PSsample-i50s;
iwindow2 = PSsample+i50s;
signallevel(iwindow1,iwindow2,env_ps,2,&envAmpRatio,log);

/*--  Check whether PS signal is well above noise level --*/
if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] PS_env amplitude is too small: %7.1f ...\n",
                stnam,chnam,envAmpRatio);
   }
   return;
}

/* Determine peak-to-trough PS amplitude: */
iwindow1 = PSsample - i30s; iwindow2 = PSsample + i30s;
signallevel(iwindow1,iwindow2,data_ps,1,&Amp,log);
if ( (Amp/L_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s  PS_amp/L_noise smaller than allowed ...\n", stnam);
   }
   return;
}
/*  OUTPUT ....  */
if (jrvw) fprintf(rvw,"PS   %s\n", datcode);
if (jrvw) write_review_ps(rvw,PSsample,Amp,L_noise,L_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/L_noise, envAmpRatio);


/* PROCESSING ---------------------------*/
usefulrec = PROCESSING(data_ps,synt_ps,PSsample,Wlength,Mshift,decim,log,pck,rvw);
fprintf(pck,"%-8s","PS");
fprintf(pck,"%2d ",usefulrec);
fprintf(pck,"%5.2f %5.2f\n",SP_amp,PS_amp);


return;
}
