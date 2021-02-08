/* ---    SZ   ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used */

extern char stnam[6], chnam[6];
extern char datcode[8];
                                                                                                                                                       
extern int i30s, i50s;
extern int jrvw, jlog;
extern int Ssample;
extern int Wlength, Mshift, decim;
                                                                                                                                                       
extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float Z_noise, Z_noise_window, Z_noise_winMin;
                                                                                                                                                       
extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;


void measure_SZ(pck,log,rvw)

   
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


  if (jlog) fprintf(log,"\n                                          PHASE= S\n");

  /* Check ENVELOPE noise level
     -- Defined as the minimum amplitude of ENV_DATA.   ----*/   

  iwindow1 = Ssample-i50s;
  iwindow2 = Ssample+i50s;
  signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log); 

  /*--  Check whether S signal is well above noise level --*/
  if ( envAmpRatio < envAmpRatio_Min ) {
   if (jlog) {
     fprintf(log,"%s [%s] S_env amplitude is too small: %7.1f ...\n",
                  stnam,chnam,envAmpRatio);
   }
   return;
  }

  /* Determine peak-to-trough S amplitude: */
  iwindow1 = Ssample - i30s; iwindow2 = Ssample + i30s;
  signallevel(iwindow1,iwindow2,data,1,&Amp,log); 
  if ( (Amp/Z_noise) < SignalToNoise) {
   if (jlog) {
     fprintf(log,"%s [%s] discarded because S_amp/Z_noise= %5.1f\n",
                  stnam,chnam,Amp/Z_noise);
   }
   return;
  }
  /*  OUTPUT .... */
  if (jrvw) fprintf(rvw,"SZ  %s\n", datcode);
  if (jrvw) write_review1(rvw,Ssample,Amp,Z_noise,Z_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  if (Amp/Z_noise < 999.) {
  fprintf(pck," %5.1f %5.1f", Amp/Z_noise, envAmpRatio);
  } else {
  fprintf(pck," %5.1f %5.1f", 999.0,      envAmpRatio);
  }


  /* PROCESSING ---------------------------*/
  usefulrec = PROCESSING(data,synt,Ssample,Wlength,Mshift,decim,log,pck,rvw);

  fprintf(pck,"%-8s","SZ");
  fprintf(pck,"%2d\n",usefulrec);

return;
}
