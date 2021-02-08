/*
  xh_count - count the number of records
*/

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       count = 0;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    FILE     *ifl, *fopen();

if (argc == 2) {
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
} else {
  ierr = usage();
  exit(ierr);
}

// Loop over traces on stdin
while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    break;
  } else {
    if (! xh_readdata(ifl,h,seism)) {
      still_reading_data = 0;
    }
  }
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
  count = count+1;
} // while
fclose(ifl);
fprintf(stdout,"%d\n", count);
} 

int usage()
{
fprintf(stderr,"Usage: xh_count in_XH\n");
return(-1);
}
