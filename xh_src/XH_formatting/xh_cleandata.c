#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Removes traces below a SNR criteria

int usage();

main(int argc, char *argv[]){
  xhhed 	h;
  int ierr;
  int still_reading_data = 1;
  int maxind;
  float seism[XH_NPTS];
  float seism_roll[XH_NPTS];
  float degree, time;
  float gcarc,az,baz;
  FILE *ifl, *ofl, *times;

  // kwarg check
  if(argc != 5){
    usage();
    exit(1);
  }
  if ((ifl = fopen(argv[1],"r")) == NULL) {
       ierr = usage();
       exit(1);
  }
  if ((ofl = fopen(argv[2],"w")) == NULL) {
       ierr = usage();
       exit(1);
  }

  if ((times = fopen(argv[3],"r")) == NULL) {
       ierr = usage();
       exit(1);
  }

  float SNR = atof(argv[4]);
  fprintf(stdout,"SNR cutoff: %f\n", SNR);

  // Start the process
  while (still_reading_data) {
    if (! xh_readhead(ifl,&h)) {
       still_reading_data = 0;
       exit(0);
    } 
    else {
      if (! xh_readdata(ifl,h,seism)) {
        still_reading_data = 0;
        exit(0);
      }
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);
   
    float time_min;
    float deg_min=10.;
    distaz(h.slat, h.slon, h.elat, h.elon, &gcarc, &az, &baz);

    while (!feof(times)){
      fscanf(times,"%f %f\n",&degree,&time);
      if (fabs(degree-gcarc) < deg_min){ 
         deg_min = fabs(degree-gcarc);
         //time_min is the arrival time corresponding to the closest distance
         time_min = fabs(time);
         //printf("%f %f\n",deg_min,time_min);
      }
    }
    rewind(times);

    int time_samp = (int)(time_min/h.delta);
    //printf("Time min, Time sample: %5s %5s %5d %f\n",h.netw,h.stnm,time_min,time_samp);

    // find maximum amplitude up to 10 seconds before signal (190 seconds at 5Hz)
    float noisemax=0;
    for (int i=0;i<time_samp-50;i++){
        if (fabs(seism[i]) >= fabs(noisemax)){
           noisemax = fabs(seism[i]);
        }
    }
    // find maximum amplitude of ten second window around signal (190-210 seconds)
    float sigmax=0;
    for (int i=(time_samp-50);i<(time_samp+50);i++){
        if (fabs(seism[i]) >= fabs(sigmax)){
           sigmax = fabs(seism[i]);
           maxind = i;
        }
    }

    // Only if the max signal amplitude is greater than SNR*noise, write the trace
    if (sigmax >= noisemax*SNR){
       // Normalize trace on signal maxima
       for (int i=0;i<h.ndata;i++){   
           seism[i] *= 1./sigmax;
       }
      
       // Align the traces so the maximum amplitude is at 200 seconds @ 5HZ (1000 samples)
       //`if (! roll(seism,seism_roll,h.ndata,(1000-maxind))){
       //`    fprintf(stderr,"Shift error ... \n");
       //`    exit(1);
       //`}

       if (! xh_writehead(ofl,h)) exit(-1);
       if (! xh_writedata(ofl,h,seism)) exit(-1);
    }

  } // while

  fclose (ifl);
  fclose (ofl);
  fclose(times);
}

int usage(){
        fprintf(stdout,"Write out traces that have a SNR above cutoff\n");
        fprintf(stdout,"Assumes trace has 5Hz sampling rate and begins\n");
        fprintf(stdout,"200 seconds before P wave\n");
        fprintf(stdout,"\n");
        fprintf(stderr,"Usage: xh_cleandata XH_in XH_out lkup_table SNR_cutoff\n");
        fprintf(stdout,"\n");
        fprintf(stderr,"if SNR_cutoff = 3, XH_out will contain only \n");
        fprintf(stderr,"   traces where the signal amplitde is at least three\n");
        fprintf(stderr,"   times bigger than the highest noise amplitude\n");
        fprintf(stderr,"lkup_table is two-column ascii file: deg time \n");
        fprintf(stdout,"\n");
        return(-1);
}
