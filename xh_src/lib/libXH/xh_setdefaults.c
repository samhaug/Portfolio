// set default header variable in XH header
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <sys/param.h>

#include "xhhead.h"     /* XH format structures */

int xh_setdefaults(xh)
xhhed     *xh;
{
int 	 k;
xhhed     h;

// defaults:
strcpy(h.evtcd,"000000A");
h.version= X_VERSION;
if (sizeof(h) != X_HDRSIZE) {
  fprintf(stderr,"Inconsistent HEADER SIZE !!!!\n");
  h.nhdr= -99;
  return(0);
} else {
  h.nhdr= X_HDRSIZE;
}
strcpy(h.stnm,"XXXX");
strcpy(h.chan,"XXX");
strcpy(h.netw,"XX");
strcpy(h.wavf,"raw");

h.maxamp = 0.0;
h.tshift = 0.0;
strcpy(h.rcomment,"DEFAULT COMMENT LINE");

h.DS= 0.0;
h.A0= 0.0;
for(k=0; k< NOCALPTS; ++k) {
 h.pole[k].r= 0.0;
 h.pole[k].i= 0.0;
 h.zero[k].r= 0.0;
 h.zero[k].i= 0.0;
}
                                                               
h.tstart.yr=   1970;
h.tstart.mo=   1;
h.tstart.day=  1;
h.tstart.hr=   0;
h.tstart.mn=   0;
h.tstart.sec=  0.0;
h.ot.yr=       1970;
h.ot.mo=       1;
h.ot.day=      1;
h.ot.hr=       0;
h.ot.mn=       0;
h.ot.sec=      0.0;

/* SOURCE and STATION info */
h.elat = 0.;
h.elon = 0.;
h.edep = 0.;
h.Mb = 0.;
h.Ms = 0.;
h.Mw = 0.;
h.slat = 0.;
h.slon = 0.;
h.elev = 0.;

h.azim = 0.;
h.incl = 0.;
h.chid = 0;
h.locc = 9;
h.qual = 0.;

h.tshift = 0.;

/* TIME PICKS */
for(k=0;k<NPCKS; k++) {
  h.tpcks[k] = 0.;
  h.flt[k]   = 0.;
  h.intg[k]  = 0;
}

*xh = h;

return(1);
}
