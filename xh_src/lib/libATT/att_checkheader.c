#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include <math.h>

#include "att.h"	/* XH format structures */

// Checks the header of ATT

int att_checkheader(h)
atthed h;
{
int ierr=1;
       
if ( fabs(h.version-ATT_VERSION) > 0.00001 ) {
  fprintf(stderr,"\nXH header version incompatibility ...\n");
  fprintf(stderr,"att.%4.2f versus ATT_VERSION= att.%4.2f\n",h.version,ATT_VERSION);
  ierr = 0;
}
if ( fabs(h.nhdr-ATT_HDRSIZE)    > 0    ) {
  fprintf(stderr,"\nXH header size error ...\n");
  fprintf(stderr,"  ---  SIZE: %d Bytes versus required %d Bytes\n\n",h.nhdr,ATT_HDRSIZE);
  ierr = 0;
}

return(ierr);
}
