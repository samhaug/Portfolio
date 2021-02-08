#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include <math.h>
#include "xhhead.h"	/* XH format structures */

/* Writes the header of an XH file */

int xh_writehead(ofl,xh)
xhhed xh;
FILE *ofl;
{

if (fwrite(&xh,X_HDRSIZE,1,ofl) != 1) {
    fprintf(stderr,"WRITEHEAD error ... \n");
    return(0);
} else {
    return(1);
}

} /* end */
