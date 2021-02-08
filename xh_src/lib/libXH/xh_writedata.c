#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include <math.h>
#include "xhhead.h"	/* XH format structures */

/* Writes the DATA of an XH file */

int xh_writedata(ofl,h,seism)
FILE *ofl;
xhhed h;
float *seism;
{

float max_val = 0.;
int   i;

if (fwrite(seism,sizeof(float),h.ndata,ofl) != h.ndata) {
    fprintf(stderr,"ERROR writing XH data\n");
    return(0);
} else {
    return(1);
}

} /* end */
