/* ---    P    ---*/

#include <string.h>
#include <stdio.h>
#include <math.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

extern char stnam[6], chnam[6];
extern char datcode[8];
                                                                                                                                                       
extern int i30s, i50s;
extern int jrvw, jlog;
extern int Psample;
extern int Wlength, Mshift, decim;
                                                                                                                                                       
extern float SignalToNoise, envAmpRatio_Min;
extern float data[npts_dat], synt[npts_dat], env_data[npts_dat];
extern float Z_noise, Z_noise_window, Z_noise_winMin;
                                                                                                                                                       
extern float stlat,stlon,stelv,  evlat,evlon,evdep, gcarc;

void measure_P(pck,log,rvw)
FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  AmpRatio;
float  envAmpRatio;
float  Amp;


  fprintf(log,"\n                                          PHASE= P\n");

  /* Check ENVELOPE noise level
     -- Defined as the minimum amplitude of ENV_DATA.   ----*/   
  iwindow1 = Psample-i50s;
  iwindow2 = Psample+i50s;
  signallevel(iwindow1,iwindow2,env_data,2,&envAmpRatio,log); 

  /*--  Check whether P signal is well above noise level --*/
  if ( envAmpRatio < envAmpRatio_Min ) {
     if (jlog) {
       fprintf(log,"%s [%s] P_env amplitude is too small: %7.1f ...\n",
                  stnam,chnam,envAmpRatio);
     }
//   return;
  }

  /* Determine peak-to-trough P amplitude: */
  iwindow1 = Psample - i30s; iwindow2 = Psample + i30s;
  signallevel(iwindow1,iwindow2,data,1,&Amp,log); 
  if (Z_noise != 0.) {
     AmpRatio = Amp/Z_noise; 
  } else {
     AmpRatio = 0.;
  }

  if ( (AmpRatio) < SignalToNoise) {
     if (jlog) {
       fprintf(log,"%s [%s] discarded because P_amp/Z_noise= %5.1f\n",
                  stnam,chnam,AmpRatio);
     }
//   return;
  }
  /*  OUTPUT .... */
  if (jrvw) fprintf(rvw,"P   %s\n", datcode);
  if (jrvw) write_review1(rvw,Psample,Amp,Z_noise,Z_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", AmpRatio, envAmpRatio);

  /* PROCESSING ---------------------------*/
  usefulrec = PROCESSING(data,synt,Psample,Wlength,Mshift,decim,log,pck,rvw);

  fprintf(pck,"%-8s","P");
  fprintf(pck,"%2d\n",usefulrec);

return;
}
