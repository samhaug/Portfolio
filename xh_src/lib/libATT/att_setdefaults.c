// set default header variable in XH header
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <sys/param.h>

#include "att.h"     /* XH format structures */

int att_setdefaults(att)
atthed     *att;
{
int 	 k;
atthed     h;

// defaults:
strcpy(h.evtcd,"000000A");
h.version= ATT_VERSION;
if (sizeof(h) != ATT_HDRSIZE) {
  fprintf(stderr,"Inconsistent HEADER SIZE !!!!\n");
  h.nhdr= -99;
  return(0);
} else {
  h.nhdr= ATT_HDRSIZE;
}
strcpy(h.stnam,"XXXX");
strcpy(h.chnam,"XXX");
strcpy(h.phase,"XX");

/* SOURCE and STATION info */
h.elat = 0.;
h.elon = 0.;
h.edep = 0.;
h.slat = 0.;
h.slon = 0.;
h.selv = 0.;
h.mlat = 0.;
h.mlon = 0.;

h.az    = 0.;
h.baz   = 0.;
h.gcarc = 0.;
h.snr   = 0.;
h.enr   = 0.;
h.t     = 0.;
h.t_err = 0.;
h.a1    = 0.;
h.a2    = 0.;
h.dtcrust = 0.;
h.dtellip = 0.;
h.dtqcor  = 0.;
h.dtmod   = 0.;
h.dtreloc = 0.;

h.WvShape    = 0;
h.Fit        = 0;
h.iSecondMax = 0.;
h.iTraceMax  = 0.;
h.iUseful    = 0.;

*att = h;

return(1);
}
