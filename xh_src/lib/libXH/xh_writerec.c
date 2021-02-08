#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include "xhhead.h"     /* XH format structures */
#include "time.h"       /* TIME format structures */

int xh_writerec(h,seism,drecfile,hrecfile)
char drecfile[80];
char hrecfile[80];
float *seism;
xhhed     h;
{
FILE 	*drec, *hrec, *fopen();
int 	 i;
float gcarc,az,baz;

if ( (drec=fopen(drecfile,"w")) == NULL) 
   fprintf(stderr,"Error opening %s\n", drecfile);
if ( (hrec=fopen(hrecfile,"w")) == NULL) 
   fprintf(stderr,"Error opening %s\n", hrecfile);

// Get backazimuth baz (degrees)
if (! distaz(h.slat,h.slon,h.elat,h.elon,&gcarc,&az,&baz))
   return(0) ;
fprintf(stdout,"CMT: %s H=%4.0fkm %4s %3s loc= %6.2f %7.2f\n",
   h.evtcd,h.edep,h.stnm,h.chan,h.slat,h.slon);
fprintf(hrec,"%s %6.2f %7.2f %4.0f %4s %3s %6.2f %7.2f %6.2f %3.0f\n",
   h.evtcd,h.elat,h.elon,h.edep,h.stnm,h.chan,h.slat,h.slon,gcarc,baz);

for(i=0; i<h.ndata;i++) 
  fprintf(drec,"%f %f\n", i*h.delta,seism[i]);

fclose(drec);
fclose(hrec);

return(1);
}
