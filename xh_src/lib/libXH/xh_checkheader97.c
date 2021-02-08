#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include <math.h>

#include "xhhead97m.h"	/* XH format structures */

// Checks the header of XH in 0.97 format

int xh_checkheader97(h)
xhhed97 h;
{
int ierr=1;
       
if ( fabs(h.version-X_VERSION97) > 0.00001 ) {
  fprintf(stderr,"\nXH header version incompatibility ...\n");
  fprintf(stderr,"xh.%4.2f versus X_VERSION97= xh.%4.2f\n",h.version,X_VERSION97);
  ierr = 0;
}
if ( fabs(h.nhdr-X_HDRSIZE)    > 0    ) {
  fprintf(stderr,"\nXH header size error ...\n");
  fprintf(stderr,"  ---  SIZE: %d Bytes versus required %d Bytes\n\n",h.nhdr,X_HDRSIZE);
  ierr = 0;
}
if ( h.chan[2]=='Z' && h.chid !=1) {
 fprintf(stderr,"xh_checkheader97() Error: %s with chid: %d\n",h.chan,h.chid);
 ierr = 0.;
}
if ( h.chan[2]=='N' && h.chid !=2) {
 fprintf(stderr,"xh_checkheader97() Error: %s with chid: %d\n",h.chan,h.chid);
 ierr = 0.;
}
if ( h.chan[2]=='E' && h.chid !=3) {
 fprintf(stderr,"xh_checkheader97() Error: %s with chid: %d\n",h.chan,h.chid);
 ierr = 0.;
}
// The component name of Ears receiver functions = "ITR"
if ( ( h.chan[2]=='R' || h.chan[2]=='L' ) && h.chid !=4 && strncmp(h.chan,"ITR",3) ) {
 fprintf(stderr,"xh_checkheader97() Error: %s with chid: %d\n",h.chan,h.chid);
 ierr = 0.;
}
if ( h.chan[2]=='T' && h.chid !=5) {
 fprintf(stderr,"xh_checkheader97() Error: %s with chid: %d\n",h.chan,h.chid);
 ierr = 0.;
}

if( h.ndata>XH_NPTS97 || h.ndata<1) {
 fprintf(stderr,"xh_checkheader97() Error: %s %s: NDATA [=%d] higher than XH_NPTS [=%d]\n",h.stnm,h.chan,h.ndata,XH_NPTS97);
 ierr = 0.;
}
       

return(ierr);
}
