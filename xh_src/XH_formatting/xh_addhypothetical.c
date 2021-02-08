#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

/* adds a spike in each record at a specified time in output of  */
/* hypothetical_scatter_times.sh */

int main(int argc, char *argv[]){
xhhed 	h;
int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

float gcarc,az,baz;
float time;
int itime;
float max=0.0;

char lat, lon;
char region[23];
FILE *inxh,*outxh,*inf;

if ((inxh = fopen(argv[1],"rb")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

if ((outxh = fopen(argv[2],"wb")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

if ((inf = fopen(argv[3],"r")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

while (still_reading_data) {
  if (! xh_readhead(inxh,&h)){
    still_reading_data = 0;
    exit(1);
  } 
  else {	
    if (! xh_readdata(inxh,h,seism)) {
      still_reading_data = 0;
      exit(1);
    }
    // check header
    if (! xh_checkheader(h))
      exit(-1);

  }

  for (i=0;i<h.ndata;i++){
      if (fabs(seism[i]) > max){
         max = fabs(seism[i]);
      }
  }

  fscanf(inf,"%f",&time);
  itime = (int)(time/(float)h.delta);
  
  for (i=itime-6;i<itime+6;i++){
      seism[i] = max*0.05;
  }
  for (i=itime+6;i<itime+12;i++){
      seism[i] = -1*max*0.05;
  }

  if (! xh_writehead(outxh,h))
  exit (-1);
  if (! xh_writedata(outxh,h,seism))
    exit (-1);
  
} // while

fclose(inf);
fclose(inxh);
fclose(outxh);
//fflush(stdout);
}

int usage(flnm)
char *flnm;
{
fprintf(stdout,"xh_addhypothetical XH_IN XH_OUT times");
fprintf(stdout,"times: single column text file made by hypothetical_scatter_times.sh \n");  
fprintf(stdout,"       must be the same length as records of XH_IN \n");  
fprintf(stdout,"XH_OUT will have a spike at each time listed in times. \n");  

return(-1);
}
