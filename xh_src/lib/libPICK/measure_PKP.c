/* ---    PKP     ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */
extern char stnam[6], chnam[6];
extern char datcode[8];

extern int i30s, i50s;
extern int jrvw, jlog;
extern int PKPsample;
extern int Wlength, Mshift, decim;

extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float Z_noise, Z_noise_window, Z_noise_winMin;
extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;

extern float PKPtime, PKIKPtime, pPKIKPtime, sPKIKPtime;
extern float PhaseSepTime;

void measure_PKP(pck,log,rvw)
FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


if (jlog) fprintf(log,"\n                                          PHASE= PKP\n");

/* VERIFY INTERFERENCE WITH OTHER PHASES -----------------*/
if ( fabs(PKPtime-PKIKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PKPtime-PKIKPtime= %5.1f\n",
                stnam,chnam,PKPtime-PKIKPtime);
   }
   return;
}
if ( fabs(PKPtime-pPKIKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PKPtime-pPKIKPtime= %5.1f\n",
                stnam,chnam,PKPtime-pPKIKPtime);
   }
   return;
}
if ( fabs(PKPtime-sPKIKPtime) < PhaseSepTime) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because PKPtime-sPKIKPtime= %5.1f\n",
                stnam,chnam,PKPtime-sPKIKPtime);
   }
   return;
}



/* Check ENVELOPE noise level
   -- Defined as the minimum amplitude of ENV_DATA.   ----*/
iwindow1 = PKPsample-i50s;
iwindow2 = PKPsample+i50s;
signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log);

/*--  Check whether PKP signal is well above noise level --*/
if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] PKP_env amplitude is too small: %7.1f ...\n",
                stnam,chnam,envAmpRatio);
   }
   return;
}

/* Determine peak-to-trough PKP amplitude: */
iwindow1 = PKPsample - i30s; iwindow2 = PKPsample + i30s;
signallevel(iwindow1,iwindow2,data,1,&Amp,log);
if ( (Amp/Z_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s  PKP_amp/Z_noise smaller than allowed ...\n", stnam);
   }
   return;
}
/*  OUTPUT ....  */
if (jrvw) fprintf(rvw,"PKP   %s\n", datcode);
if (jrvw) write_review1(rvw,PKPsample,Amp,Z_noise,Z_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/Z_noise, envAmpRatio);


/* PROCESSING ---------------------------*/
usefulrec = PROCESSING(data,synt,PKPsample,Wlength,Mshift,decim,log,pck,rvw);
fprintf(pck,"%-8s","PKPab");
fprintf(pck,"%2d\n",usefulrec);


return;
}
