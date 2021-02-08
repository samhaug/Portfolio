#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "parameter.h"

extern float dt;
extern int jrvw;


/* Cross-correlation of trace1 and trace2:
   Samp is the central sample of the traces.
   window2 (=2*window) is the time window on each side of Sample.
   Hence, trace1 and trace2 are:
   1st sample                     last sample:
   Samp-window2          Samp        Samp+window

   Cross-correlation occurs between
   1st sample                     last sample:
   Samp-window-maxshift  Samp      Samp+window+maxshift
   
   Maximum time shift of trace2 with respect to trace1 is MAXSHIFT.
*/

int PROCESSING(trace1,trace2,Samp,window,Mshift,decim,log,pck,rvw)

	float *trace1, *trace2;
        int    Samp, window, Mshift;
        int    decim;
        FILE  *log, *pck, *rvw;
{

          int       Meas = 1;
          int       i, j;
          int       maxshift;
          int       CentralSample, window2, window_new, window2_new;
          int       i_crcor = 0, i_crcor2a=0, i_crcor2b=0;
          int       iSecondMax = 0;
          int       iTraceMax = 0;
          int       i35s, i50s;

          float     crcor[npts_crc];
          float t1[npts_crc], t2[npts_crc];
          float dt_new;
          float time_uncert;
          float fit;
          float L2fit();
          void resample();
          float crosscor();
          float crcor_max,crcor_max2,auto_t1,auto_t2,max,Amp1,Amp2, Wvshape;


for(i=0; i<npts_crc; ++i) {
   t1[i] = 0.; t2[i] = 0.;
}


max = 0.;
for (i=Samp-i50s; i<=Samp+i50s; ++i) {
  if ( fabs(trace2[i]) > max ) {
     max = fabs(trace2[i]);
     j = i;
  }
}
if ( abs(j-Samp) > i35s ) iTraceMax = 1;
/*
fprintf(stdout,"in Processing: Samp= %d j= %d i35s= %d  iTraceMax= %d\n",Samp,j,i35s,iTraceMax);
*/
/*---------------------------------------------------*/

window_new  =  window*decim;
window2     =  window*2;
window2_new =  window_new*2;
dt_new      =  dt/decim;
maxshift    =  Mshift*decim;

/* Decimate trace1 and trace2 and put into t1 and t2: */
resample(trace1,t1,Samp,window2,decim);
resample(trace2,t2,Samp,window2,decim);

CentralSample = window2_new;

/*
fprintf(stdout,"in PROCESSING Samp= %d window= %d maxshift= %d\n", Samp,window,maxshift);
*/
if (jrvw) fprintf(rvw,"%5.2f %d %d\n", dt_new, maxshift, window2_new);

/* Determine cross-correlation function "crcor", its maximum
   value "crcor_max", and corresponding sample "i_crcor" */
crcor_max = 0.;
for(i= -maxshift; i<= maxshift; ++i) {
  crcor[i+maxshift] = crosscor(t1,t2,CentralSample,i,window_new,maxshift);
  if ( crcor[i+maxshift] > crcor_max) {
       i_crcor = i;
       crcor_max  = crcor[i+maxshift];
  }
}
for(i= -maxshift; i<= maxshift; i=i+10)
  fprintf(rvw,"%f %e\n", i*dt_new, crcor[i+maxshift]);

fit = L2fit(t1,t2,i_crcor,window2_new,log);

/*
fprintf(stdout,"Fit= %f\n", fit);
*/


/*-- Auto-Correlation of T1 and T2: --*/
i=0;
auto_t1 = crosscor(t1,t1,CentralSample,i,window_new,maxshift);
auto_t2 = crosscor(t2,t2,CentralSample,i,window_new,maxshift);

Amp1 = crcor_max/auto_t1;
Amp1 = 1./Amp1;
Amp2 = crcor_max/auto_t2;

if (Amp1 <= Amp2) {
  Wvshape = Amp1/Amp2;
} else {	
  Wvshape = Amp2/Amp1;
}

/* 
   The variables "i_crcor2a" and i_crcor2b" are
   samples where "crcor" has a value 50% of its maximum value.
   The value:
      (i_crcor2b - i_crcor2a )/2 * dt_new
   defines the "quality" of the cross-correlation.
*/


/* Find the samples where CRCOR falls more than 50% below its maximum: 
           These samples are i_crcor2a and i_crcor2b -------------------*/
crcor_max2 = crcor_max/2.;
for(i= i_crcor; i< maxshift; ++i) {
  if ( crcor[i+maxshift] < crcor_max2) {
       i_crcor2b = i;
       break;
  }
}
for(i= i_crcor; i> -maxshift; --i) {
  if ( crcor[i+maxshift] < crcor_max2) {
       i_crcor2a = i;
       break;
  }
}

/* Check if there are secondary maxima
   (i.e., Does CRCOR get above the 50, 60, 70% level beyond i_crcor2a and icrcor2b?)
   50% ---> crcor_max2
   60% ---> crcor_max2*6./5.
   70% ---> crcor_max2*7./5.

   60% Chosen for now .....
*/
/* crcor_max2 = crcor_max2;         */
   crcor_max2 = crcor_max2 * 6./5.;
/* crcor_max2 = crcor_max2 * 7./5.; */

for(i= i_crcor2b+1; i< maxshift; ++i) {
  if ( crcor[i+maxshift] > crcor_max2) {
       /* Secondary Maximum .... */
       iSecondMax = 1;
       break;
  }
}
for(i= i_crcor2a-1; i> -maxshift; --i) {
  if ( crcor[i+maxshift] > crcor_max2) {
       iSecondMax = 1;
       break;
  }
}
if (i_crcor2a == 0 && i_crcor2b == 0) {
   time_uncert = 999.;
} else {
   time_uncert = (i_crcor2b-i_crcor2a)*dt_new/2.;
}


fprintf(log,"dT= %4.1fs HalfAmp = [%4.1fs,%4.1fs]\n",
             i_crcor*dt_new,i_crcor2a*dt_new,i_crcor2b*dt_new);
fprintf(log,"Least_squares Fit= %5.2f\n", fit);
fprintf(log,"A2= %6.2f A1= %6.2f", Amp2, Amp1);

/* Write to PCKFILE:  --------------------------*/
fprintf(pck," | ");
fprintf(pck,"%6.2f",       i_crcor*dt_new);
fprintf(pck,"%6.1f",       time_uncert);
fprintf(pck,"%4.0f",       fit*100.);
fprintf(pck," %7.2f %7.2f %4.0f", Amp1, Amp2, 100.*Wvshape);
fprintf(pck," %2d %1d", iSecondMax, iTraceMax);


/* Print T1 and T2 to REVIEW */
if (jrvw) {
  for(i= 0; i<= 2*window2_new; i = i+10) {
    fprintf(rvw,"%f %e %e", i*dt_new, t1[i], t2[i]);
    if ( (i-i_crcor) >= 0 ) {
      fprintf(rvw," %e\n", t2[i-i_crcor]);
    } else {
      fprintf(rvw," %f\n", 0.);
    }
  }
}

if ( fabs(i_crcor*dt_new) > 20.)       Meas = 0;
if (time_uncert > 20.)                 Meas = 0;
if ( iSecondMax )                      Meas = 0;
if ( iTraceMax )                       Meas = 0;
if (Amp2 > 2.5 || Amp2 < 0.4  )        Meas = 0;
if (fit  < 0.709)                      Meas = 0;
if (Wvshape  < 0.709)                  Meas = 0;

/* Write to REVIEW:   --------------------------*/
if (jrvw) {
  fprintf(rvw,"%7.2f",        i_crcor*dt_new);
  fprintf(rvw," %7.1f",       time_uncert);
  fprintf(rvw," %6.2f",       fit);
  fprintf(rvw," %6.2f %6.2f %5.2f", Amp2, Amp1, Wvshape);
  fprintf(rvw," %2d %2d %2d\n", iSecondMax, iTraceMax, Meas);
}

return( Meas );
}

/*-----------------------------------------------------*/
float crosscor(trace1,trace2,CentralSample,ishift,window,maxshift)

float     *trace1, *trace2;
int        ishift, window, CentralSample, maxshift;

/* -----
m = window+maxshift

TRACE1 and TRACE2 are analysed between [CentralSample-m, CentralSample+m]
while TRACE2 is shifted by ishift
*/


{
       int j, m;
       float crc = 0.;
       int k=0;

m = window+maxshift;

if (m > CentralSample) {
  fprintf(stdout,"in CROSSCOR: m [%d] is larger than CentralSample [%d]\n",m, CentralSample);
  exit(-1);
}
  

/*
fprintf(stdout,"in CROSSCOR: CentralSample= %d\n",CentralSample);
fprintf(stdout,"in CROSSCOR: ishift= %d m= %d\n",ishift, m);
*/

for (j=CentralSample-m; j< CentralSample+m; ++j) {
  crc = crc + trace1[j]*trace2[j-ishift];
  ++k;
}

/*
fprintf(stdout,"in CROSSCOR: k= %d crc= %f\n",k,crc);
*/


return(crc);
}
