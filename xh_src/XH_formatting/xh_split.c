#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

// ------------------------------------------------------------
// splits XH file into files with N xh records

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[XH_NPTS];
char  xhname[80];
FILE *ifl, *ofl, *fopen();

int i,count;
int ierr;
int n;
int still_reading_data = 1;

int usage();

if(argc != 4) {
   ierr = usage();
   exit(ierr);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if (strncmp(argv[2],"-n",2) != 0) {
     ierr = usage();
     return(ierr);
} else {
  sscanf(argv[3],"%d",&n); 
}

i=0;
count=0;
while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,f)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header:
  if (! xh_checkheader(h) )
    exit(-1);

  if(i==n) {
    fclose(ofl);
    i=0;
  }
  if(i==0) {
    count = count+1;
    sprintf(xhname,"split.%d.xh",count);
    if ((ofl = fopen(xhname,"w")) == NULL) {
       fprintf(stderr,"Cannot open %s ...\n", xhname);
       exit(-1);
    }
  }
  /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,f))
    exit(-1);
  i=i+1;
} // while

fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
  fprintf(stderr,"Usage: xh_split XH_file -n N\n");
  return(-1);
}
