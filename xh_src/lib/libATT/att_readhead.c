#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include <math.h>
#include "att.h"  /* ATT format structures */

/* Reads the header of an ATT file */

int att_readhead(ifl,att)
atthed *att;
FILE *ifl;
{


int bRead = fread(att,1,ATT_HDRSIZE,ifl);
if (bRead == ATT_HDRSIZE) {
  return 1;
}

// Check for end of file!
if (feof(ifl) != 0) {
  // make sure there was no trailing junk in file
  if (bRead != ATT_HDRSIZE && bRead != 0) {
    fprintf(stderr,"\natt_readhead() error ... ");
    fprintf(stderr,"read only %d bytes; expected %d bytes\n", bRead,ATT_HDRSIZE);
  } else {
    // normal end of file case
    // fprintf(stderr,"EOF reached\n");
  }
} else {
  // There was an error of some kind
  fprintf(stderr,"\natt_readhead() error ... %d", ferror(ifl));
  perror("att_readhead");
}
return 0;

} /* end */
