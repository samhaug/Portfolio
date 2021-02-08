/* ---    SKS    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

extern char stnam[6], chnam[6];
extern char datcode[8];

extern int i30s, i50s;
extern int jrvw, jlog;
extern int SKSsample;
extern int Wlength, Mshift, decim;
                                                                                                                                                       
extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float L_noise, L_noise_window, L_noise_winMin;
                                                                                                                                                       
extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;

void measure_SKS(pck,log,rvw)

   
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


  if (jlog) fprintf(log,"\n                                          PHASE= SKS\n");

  /* Check ENVELOPE noise level
     -- Defined as the minimum amplitude of ENV_DATA.   ----*/   
iwindow1 = SKSsample-i50s;
iwindow2 = SKSsample+i50s;
signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log); 

/*--  Check whether SKS signal is well above noise level --*/
if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] SKS_env amplitude is too small: %7.1f ...\n",
                stnam,chnam,envAmpRatio);
   }
   return;
}

/* Determine peak-to-trough SKS amplitude: */
iwindow1 = SKSsample - i30s; iwindow2 = SKSsample + i30s;
signallevel(iwindow1,iwindow2,data,1,&Amp,log); 
if ( (Amp/L_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because SKS_amp/L_noise= %5.1f\n",
                stnam,chnam,Amp/L_noise);
   }
   return;
}
/*  OUTPUT .... */
if (jrvw) fprintf(rvw,"SKS   %s\n", datcode);
if (jrvw) write_review1(rvw,SKSsample,Amp,L_noise,L_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/L_noise, envAmpRatio);


/* PROCESSING ---------------------------*/
usefulrec = PROCESSING(data,synt,SKSsample,Wlength,Mshift,decim,log,pck,rvw);

fprintf(pck,"%-8s","SKS");
fprintf(pck,"%2d\n",usefulrec);

return;
}
