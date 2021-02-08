/* Write TO the REVIEW file: */

#include <stdio.h>
#include <string.h>
#include <math.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

extern int i150s, i250s;
                                                                                                                   
extern float startsec, dt;
extern float bandpass[];
extern float data[], env_data[], synt[];
extern float evlat,evlon,evdep;
extern float stlat,stlon,gcarc;
                                                                                                                   
extern char stnam[], chnam[], datcode[];

void write_review1(rvw, Sample, Amp, Noise, Noise_window, envAmpRatio)
   int         Sample;
   float       Amp, Noise, Noise_window, envAmpRatio;
   FILE       *rvw;
{

   int i, k;

// fprintf(stdout,"in WRITE_review1\n");
// fprintf(stdout,"BP: %5.1f %5.1f %5.1f %5.1f\n",
//          bandpass[0],bandpass[1],bandpass[2],bandpass[3]);
// fprintf(stdout,"Start= %5.1f  dt= %5.2f\n", startsec,dt);
// fprintf(stdout,"Event:   %5.2f %6.2f %5.1f\n",evlat,evlon,evdep);
// fprintf(stdout,"%s %s %5.2f %6.2f %7.1f\n",stnam,chnam,stlat,stlon,gcarc);
// fprintf(stdout,"EnvAmpRatio= %7.2f SNratio=  %7.2f %8.1f\n",
//                 envAmpRatio,Amp/Noise,Noise_window);

fprintf(rvw,"BP: %5.1f %5.1f %5.1f %5.1f\n",
         bandpass[0],bandpass[1],bandpass[2],bandpass[3]);
fprintf(rvw,"Start= %5.1f  dt= %5.2f\n", startsec,dt);
fprintf(rvw,"Event:   %5.2f %6.2f %5.1f\n",evlat,evlon,evdep);
fprintf(rvw,"%s %s %5.2f %6.2f %7.1f\n",stnam,chnam,stlat,stlon,gcarc);
fprintf(rvw,"EnvAmpRatio= %7.2f SNratio=  %7.2f %8.1f\n",
                envAmpRatio,Amp/Noise,Noise_window);

/* write DATA and SYNT:    t = [Samp-150s,Samp+250s] */
k = -i150s;
for(i= (Sample-i150s); i<= (Sample+i250s); i=i+2) {
   fprintf(rvw,"%6.1f %e %e %e\n", k*dt, data[i], env_data[i], synt[i]);
   k=k+2;
}

return;

}
