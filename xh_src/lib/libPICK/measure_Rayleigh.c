/* ---   Rayleigh    ---*/

#include <string.h>
#include <math.h>
#include <stdio.h>
#include "autopick.h"

void measure_P(pck,log,rvw,iwin1,iwin2)

   
   FILE    *pck, *log, *rvw;
{

int    iwindow1, iwindow2;
int    usefulrec = 0;
float  envAmpRatio;
float  Amp;


  /*  OUTPUT .... */
  if (jrvw) fprintf(rvw,"P   %s\n", datcode);
  if (jrvw) write_review1(rvw,Psample,Amp,Z_noise,Z_noise_window,envAmpRatio);

  fprintf(pck,"%7s",datcode);
  fprintf(pck," %6.2f %7.2f %5.1f %6.2f",evlat,evlon,evdep,gcarc);
  fprintf(pck," %9s %3s %6.2f %7.2f %7.1f",stnam,chnam,stlat,stlon,stelv);
  fprintf(pck," %5.1f %5.1f", Amp/Z_noise, envAmpRatio);

  /* PROCESSING ---------------------------*/
  usefulrec = PROCESSING_R(data,synt,iwin1,iwin2,log,pck,rvw);

  fprintf(pck,"%-8s","P");
  fprintf(pck,"%2d\n",usefulrec);

return;
}
