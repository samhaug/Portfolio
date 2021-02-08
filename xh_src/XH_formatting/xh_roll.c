#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Shifts all traces in stream by the same time

int usage();

main(int argc, char *argv[]){
  xhhed 	h;
  int ierr;
  int still_reading_data = 1;
  float seism[XH_NPTS];
  float seism_roll[XH_NPTS];
  float rolltime;

  FILE *ifl, *ofl;

  // kwarg check
  if(argc != 5){
    usage();
    exit(1);
  }
  if ((ifl = fopen(argv[1],"r")) == NULL) {
       ierr = usage(argv[1]);
       exit(1);
  }
  if ((ofl = fopen(argv[2],"w")) == NULL) {
       ierr = usage(argv[2]);
       exit(2);
  }
  if (strncmp(argv[3],"-t",2) != 0){
       ierr = usage();
       exit(3);
  } 
  else {
      rolltime = atof(argv[4]);
  }
  fprintf(stdout,"Time shift: %f\n", rolltime);

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

    // shift 
    if (! roll(seism,seism_roll,h.ndata,(int)(rolltime/h.delta))){
       fprintf(stderr,"Shift error ... \n");
       exit(1);
    }
    fprintf(stdout,"Time shift %s %s %s\n", h.stnm,h.netw,h.chan);

    // WRITE XH header and data
    if (! xh_writehead(ofl,h))
      exit (-1);
    if (! xh_writedata(ofl,h,seism_roll)) 
      exit (-1);
  } // while

  fclose (ifl);
  fclose (ofl);
}

int usage(){
        fprintf(stdout,"Shift all traces by same time_shift\n");
        fprintf(stdout,"\n");
        fprintf(stderr,"Usage: xh_roll in_XHfile out_XHfile -t time_shift\n");
        return(-1);
}
