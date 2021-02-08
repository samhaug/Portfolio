// xh_sp_polariz - cuts the LHZ and LHR trace around the SP phase
// and projects the waveforms on the polarization angle of SP.
// Assumes that the DATA are in order: Z, R, T

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "time.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    float     seism_z[XH_NPTS];
    float     seism_r[XH_NPTS];
    float     seism_t[XH_NPTS];
    xhhed     h;
    xhhed     h_z;
    xhhed     h_r;
    xhhed     h_t;
    int       still_reading_data = 1;
    int       z_found=0;
    int       r_found=0;
    int       t_found=0;
    int       icount=0;
    int	      j, ierr;
    float     delta,az,baz;
    float     angle_i, angle_j;
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
fprintf(stdout,"\n");

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
     fprintf(stdout,"---- Record %2s/%s/%3s ID= %d SENSOR AZM= %4.1f \n",h.netw,h.stnm,h.chan,h.chid,h.azim); 
     if (h.chid == 1)
       fprintf(stdout,"---- EVT lat/lon= %5.1f/%6.1f ---- STA lat/lon= %5.1f/%6.1f\n",h.elat,h.elon,h.slat,h.slon); 
     if        (h.chan[2] == 'Z') {
       // Z  component
       z_found = 1;
       h_z = h;
       for(j=0;j<h.ndata;j++) seism_z[j] = seism[j];
     } else if (h.chan[2] == 'R' || h.chan[2] == '4') {
       // R component
       r_found = 1;
       h_r = h;
       for(j=0;j<h.ndata;j++) seism_r[j] = seism[j];
     } else if (h.chan[2] == 'T' || h.chan[2] == '5') {
       // T component
       t_found = 1;
       h_t = h;
       for(j=0;j<h.ndata;j++) seism_t[j] = seism[j];
     } else {
       // Records are in wrong order ??
       fprintf(stderr,"Record %s %s not R or T: channel type: %s AZM= %4.1f \n", h.netw, h.stnm, h.chan, h.azim); 
       return(-1);
     }
     
     if (icount==3) {
       if (z_found && r_found && t_found) {
         // Print out the VERT component first
         if (! xh_writehead(ofl,h_z))
           exit(-1);
         if (! xh_writedata(ofl,h_z,seism_z))
           exit(-1);
         if (! xh_writehead(ofl,h_r))
           exit(-1);
         if (! xh_writedata(ofl,h_r,seism_r))
           exit(-1);
         // Get epicentral distance
         if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
           exit(-1) ;
         
         angle_i = asinf(9.1/111.195*6.);
         angle_j = asinf(9.1/111.195*4.);
         fprintf(stdout,"angle_i= %f angle_j= %f\n",angle_i,angle_j);
         for(j=0;j<h_z.ndata;j++) {
           seism[j] = cosf(angle_i)*seism_z[j] + sinf(angle_i)*seism_r[j];
         }
         h.chan[2] = 'X'; h.chid = 0;
         if (! xh_writehead(ofl,h))
           exit(-1);
         if (! xh_writedata(ofl,h,seism))
           exit(-1);
         for(j=0;j<h_z.ndata;j++) {
           seism[j] = sinf(angle_i)*seism_z[j] - cosf(angle_i)*seism_r[j];
         }
         h.chan[2] = 'Y'; h.chid = 0;
         if (! xh_writehead(ofl,h))
           exit(-1);
         if (! xh_writedata(ofl,h,seism))
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
fprintf(stderr,"Usage: xh_sp_polariz in_XH out_XH \n");
return(-1);
}
