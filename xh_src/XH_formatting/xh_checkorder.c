// xh_checkorder
// Makes sure that for each stations we have
// three components and in the order Z-R/L-T

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    xhhed     h;
    xhhed     h_z;
    xhhed     h_l;
    xhhed     h_t;
    int       still_reading_data = 1;
    int       z_found=0;
    int       l_found=0;
    int       t_found=0;
    int       icount=0;
    int       itrace=0;
    int	      j, ierr;
    FILE     *ifl, *fopen();
    int   okay=1;

if(argc != 2) {
   ierr = usage();
   exit(ierr);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}

// Loop over traces on stdin
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism)) {
       exit(-1);
     }
     // check header
     if (! xh_checkheader(h))
       exit(-1);
     itrace = itrace+1;

     // records should already be in Z,L,T order
     icount = icount+1;
     if        (h.chan[2] == 'Z' && h.chid == 1) {
       // Z  component
       z_found = 1;
       h_z = h;
     } else if ( (h.chan[2] == 'L' || h.chan[2] == 'R') && h.chid == 4) {
       // L component
       l_found = 1;
       h_l = h;
       if(strncmp(h_l.stnm,h_z.stnm,3) != 0) okay=0;
     } else if (h.chan[2] == 'T' && h.chid == 5) {
       // T component
       t_found = 1;
       h_t = h;
       if(strncmp(h_t.stnm,h_z.stnm,3) != 0) okay=0;
     } else {
       // Records are not in Z/L/T order ?
       fprintf(stderr,"Record %s %s : channel type: %s id= %d\n", h.netw,h.stnm,h.chan,h.chid); 
       exit(-1);
     }
     
     if (icount==3) {
       if (z_found && l_found && t_found && okay==1) {
         fprintf(stdout,"OKAY Record %2s/%s I= %d\n",h_z.netw,h_z.stnm,itrace); 
       } else {
         fprintf(stdout,"Read error for station %s/%s ...\n", h_z.netw, h_z.stnm);
         fprintf(stdout,"Read error for station %s/%s ...\n", h_l.netw, h_l.stnm);
         fprintf(stdout,"Read error for station %s/%s ...\n\n", h_t.netw, h_t.stnm);
       }
       icount=0;
       okay = 1;
    }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_checkorder in_XH \n");
return(-1);
}
