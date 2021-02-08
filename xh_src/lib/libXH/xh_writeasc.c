/*-----------------------------
 write out new XH file
-----------------------------*/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include "xhhead.h"     /* XH format structures */
#include "time.h"       /* TIME format structures */

int xh_writeasc(xh,seism,ascfile)
char ascfile[80];
float *seism;
xhhed     xh;
{
FILE 	*oasc, *fopen();
int 	 i;

if ( (oasc=fopen(ascfile,"w")) == NULL) 
   fprintf(stderr,"Error opening %s\n", ascfile);


fprintf(stdout,"CMT: %s H=%4.0fkm %4s %3s loc= %6.2f %7.2f\n",
   xh.evtcd,xh.edep,xh.stnm,xh.chan,xh.slat,xh.slon);

for(i=0; i<xh.ndata;i++) 
  fprintf(oasc,"%f %f\n", i*xh.delta,seism[i]);

fclose(oasc);

return(1);
}
