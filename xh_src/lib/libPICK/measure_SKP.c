/* ---   SKP   ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>
#include "autopick.h"

void measure_SKP(pck,log,rvw)

   
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= SKP\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
if ( fabs(SKPtime-PKStime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-PKStime= %5.1f\n",
                stnam,chnam,SKPtime-PKStime);
   }
   return;
}
if ( fabs(SKPtime-PPPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-PPPtime= %5.1f\n",
                stnam,chnam,SKPtime-PPPtime);
   }
   return;
}
if ( fabs(SKPtime-PPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-PPtime= %5.1f\n",
                stnam,chnam,SKPtime-PPtime);
   }
   return;
}
if ( fabs(SKPtime-sPPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-sPPtime= %5.1f\n",
                stnam,chnam,SKPtime-sPPtime);
   }
   return;
}
if ( fabs(SKPtime-pPPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-pPPtime= %5.1f\n",
                stnam,chnam,SKPtime-pPPtime);
   }
   return;
}
if ( fabs(SKPtime-sPKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-sPKPtime= %5.1f\n",
                stnam,chnam,SKPtime-sPKPtime);
   }
   return;
}
if ( fabs(SKPtime-pPKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-pPKPtime= %5.1f\n",
                stnam,chnam,SKPtime-pPKPtime);
   }
   return;
}
if ( fabs(SKPtime-sPKIKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-sPKIKPtime= %5.1f\n",
                stnam,chnam,SKPtime-sPKIKPtime);
   }
   return;
}
if ( fabs(SKPtime-pPKIKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKPtime-pPKIKPtime= %5.1f\n",
                stnam,chnam,SKPtime-pPKIKPtime);
   }
   return;
}


/* Check ENVELOPE noise level
   -- Defined as the minimum amplitude of ENV_DATA.   ----*/
iwindow1 = SKPsample-i50s;
iwindow2 = SKPsample+i50s;
signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log);

/*--  Check whether SKP signal is well above noise level --*/
if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] SKP_env amplitude is too small: %7.1f ...\n",
                stnam,chnam,envAmpRatio);
   }
   return;
}

/* Determine peak-to-trough SKP amplitude: */
iwindow1 = SKPsample - i30s; iwindow2 = SKPsample + i30s;
signallevel(iwindow1,iwindow2,data,1,&Amp,log);
if ( (Amp/Z_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s  SKP_amp/Z_noise smaller than allowed ...\n", stnam);
   }
   return;
}
/*  OUTPUT ....  */
if (jrvw) fprintf(rvw,"SKP   %s\n", datcode);
if (jrvw) write_review1(rvw,SKPsample,Amp,Z_noise,Z_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/Z_noise, envAmpRatio);


/* PROCESSING ---------------------------*/
usefulrec = PROCESSING(data,synt,SKPsample,Wlength,Mshift,decim,log,pck,rvw);
fprintf(pck,"%-8s","SKP");
fprintf(pck,"%2d\n",usefulrec);


return;
}
