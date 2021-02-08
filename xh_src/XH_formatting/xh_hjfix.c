// xh_hjfix - Hendrik puts the data in the order T, L, Z
// For some stations, component are missing
// I will write out the data only for which we have Z,L,T.

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    float     seism_z[XH_NPTS];
    float     seism_l[XH_NPTS];
    float     seism_t[XH_NPTS];
    xhhed     h;
    xhhed     h_z;
    xhhed     h_l;
    xhhed     h_t;
    int       still_reading_data = 1;
    int       z_found=0;
    int       l_found=0;
    int       t_found=0;
    int       icount=0;
    int	      j, ierr;
    float     td;
    float     delta,az,baz;
    float     rad;
    FILE     *ifl, *ofl, *fopen();
    int timdif();
    int distaz();

if(argc != 3) {
   ierr = usage();
   exit(ierr);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}
fprintf(stdout,"AA\n");

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
     icount = icount+1;
     fprintf(stdout,"---- Record %2s/%s/%3s ID= %d\n",h.netw,h.stnm,h.chan,h.chid); 
     if (h.chid == 1)
       fprintf(stdout,"---- EVT lat/lon= %5.1f/%6.1f ---- STA lat/lon= %5.1f/%6.1f\n",h.elat,h.elon,h.slat,h.slon); 
     if        (h.chan[2] == 'T' && h.chid == 5) {
       // T  component
       t_found = 1;
       h_t = h;
       for(j=0;j<h.ndata;j++) seism_z[j] = seism[j];
     } else if (h.chan[2] == 'L' && h.chid == 4) {
       // L component
       l_found = 1;
       h_l = h;
       for(j=0;j<h.ndata;j++) seism_l[j] = seism[j];
     } else if (h.chan[2] == 'Z' && h.chid == 1) {
       // Z component
       z_found = 1;
       h_z = h;
       for(j=0;j<h.ndata;j++) seism_z[j] = seism[j];
     } else {
       // Records are not in T,L,Z order ?
       fprintf(stderr,"Record %s %s : channel type: %s id= %d\n", h.netw,h.stnm,h.chan,h.chid); 
       exit(-1);
     }
     
     if (icount==3) {
       if (z_found && l_found && t_found) {
         // Print out Z, L, T
         if (! xh_writehead(ofl,h_z))
           exit(-1);
         if (! xh_writedata(ofl,h_z,seism_z))
           exit(-1);
         if (! xh_writehead(ofl,h_l))
           exit(-1);
         if (! xh_writedata(ofl,h_l,seism_l))
           exit(-1);
         if (! xh_writehead(ofl,h_t))
           exit(-1);
         if (! xh_writedata(ofl,h_t,seism_t))
           exit(-1);
         icount=0;
       } else {
         fprintf(stdout,"Read error for station %s %s ...\n", h.netw, h.stnm);
       }
    }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_reorder in_XH out_XH \n");
return(-1);
}
