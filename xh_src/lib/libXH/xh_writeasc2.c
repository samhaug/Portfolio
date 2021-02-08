#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include "xhhead.h"     /* XH format structures */

int xh_writeasc2(h,seism,ascfile)
char ascfile[80];
float *seism;
xhhed     h;
{
FILE 	*oasc, *fopen();
int 	 i;

fprintf(stdout,"%s %6.2f %7.2f H= %3.0f km %4s %6.2f %7.2f dt= %4.2f Nsamp= %d\n",
   h.evtcd,h.elat,h.elon,h.edep,h.stnm,h.slat,h.slon,h.delta,h.ndata);
if ( (oasc=fopen(ascfile,"w")) == NULL) { 
   fprintf(stderr,"Error opening %s\n", ascfile);
   return(0);
}

fprintf(oasc,"%s %6.2f %7.2f H= %3.0f km %4s %6.2f %7.2f dt= %4.2f Nsamp= %d\n",
   h.evtcd,h.elat,h.elon,h.edep,h.stnm,h.slat,h.slon,h.delta,h.ndata);
for(i=0; i<h.ndata;i++) 
  fprintf(oasc,"%f %f\n", i*h.delta-20.,seism[i]);

fclose(oasc);

return(1);
}
