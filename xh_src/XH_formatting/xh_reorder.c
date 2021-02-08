// xh_reorder - Hendrik puts the data in the order T, L, Z
// I am rearranging them in the order, Z, L, T and I am
// deleting stations for which only the Z component is available

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
    float     seism_z[XH_NPTS];
    float     seism_l[XH_NPTS];
    float     seism_t[XH_NPTS];
    xhhed     h;
    xhhed     h_z;
    xhhed     h_l;
    xhhed     h_t;
    int       still_reading_data = 1;
    int       z_found;
    int       l_found;
    int       t_found;
    int       ok_order=0;
    int       icount=0;
    int	      j=0, ierr;
    FILE      *ifl, *ofl, *fopen();

    if (argc != 3){
         ierr = usage();
         exit(ierr);
    }
    if ((ifl = fopen(argv[1],"r")) == NULL) {
         ierr = usage();
         exit(-1);
    }
    if ((ofl = fopen(argv[2],"w")) == NULL) {
         ierr = usage();
         exit(-1);
    }

// Loop over traces on stdin
while (still_reading_data) {
    if (! xh_readhead(ifl,&h)) {
     exit(-1);
    } 
    else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     // check header
     if (! xh_checkheader(h))
       exit(-1);

     if        (h.chan[2] == 'T' && h.chid == 5) {
       // T  component
       t_found = 1;
       h_t = h;
       ok_order = 1;
       icount   = 1;
       fprintf(stdout,"T-- %2s/%s/%3s ID= %d ok= %d icount= %d\n",
                  h.netw,h.stnm,h.chan,h.chid,ok_order,icount); 
       for(j=0;j<h.ndata;j++) seism_t[j] = seism[j];
     } else if (h.chan[2] == 'L' && h.chid == 4 && icount == 1) {
       // L component
       l_found = 1;
       h_l = h;
       for(j=0;j<h.ndata;j++) seism_l[j] = seism[j];
       icount   = 2;
       fprintf(stdout,"L-- %2s/%s/%3s ID= %d ok= %d icount= %d\n",
                  h.netw,h.stnm,h.chan,h.chid,ok_order,icount); 
     } else if (h.chan[2] == 'Z' && h.chid == 1 && icount == 2) {
       // Z component
       z_found = 1;
       h_z = h;
       for(j=0;j<h.ndata;j++) seism_z[j] = seism[j];
       icount   = 3;
       fprintf(stdout,"Z-- %2s/%s/%3s ID= %d ok= %d icount= %d\n",
                  h.netw,h.stnm,h.chan,h.chid,ok_order,icount); 
     } else {
       // Records are not in T,L,Z order ?
       fprintf(stderr,"Record %s %s : channel type: %s id= %d\n", h.netw,h.stnm,h.chan,h.chid); 
       icount = 0;
     }
     
     if (icount==3 && ok_order == 1) {
       if (z_found && l_found && t_found) {
         // Print out Z, L, T
         fprintf(stdout, "         WRITING %s %s ...\n", h.netw, h.stnm);
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
       } else {
         fprintf(stdout,"Read error for station %s %s ...\n", h.netw, h.stnm);
       }
       ok_order = 0;
       icount=0;
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
