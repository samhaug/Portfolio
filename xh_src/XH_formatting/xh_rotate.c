// xh_rotate - rotate NS and EW channales into Radial and Transverse
// It is assumed that the XH file contains 3 records per stations: Z,N,E
// grouped together ... !!!
//
// OUTPUT is Z,R,T

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"
#include "time.h"

int main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    float     seism_z[XH_NPTS], seism_n[XH_NPTS], seism_e[XH_NPTS];
    float     seism_r[XH_NPTS], seism_t[XH_NPTS];
    xhhed     h_z, h_n, h_e;
    xhhed     h_r, h_t;
    xhhed     h;
    int       still_reading_data = 1;
    int       z_found=0, n_found=0, e_found=0;
    int       i_zne = 0;
    int	      j, ierr;
    int       ib, nsamp;
    int       jdebug = 1; // set to 0 to suppress output
    float     td;
    float     delta,az,baz;
    float     rad;
    FILE     *ifl, *ofl, *fopen();
//    int timdif();
//    int distaz();
//    int usage();
//    int xh_readhead();

rad = 4.*atan(1.)/180.;
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

// Loop over traces on stdin
// They MUST be in the order z, n, e!
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

     i_zne++;
     if (jdebug==1 && i_zne==1) {
       fprintf(stdout,"\n----------------------------\n");
       fprintf(stdout,"EVT lat/lon= %5.1f/%6.1f ---- STA lat/lon= %5.1f/%6.1f\n",h.elat,h.elon,h.slat,h.slon); 
     }
     if (jdebug ) {
       fprintf(stdout,"i_zne=%d %2s/%s/%3s ",i_zne,h.netw,h.stnm,h.chan); 
       fprintf(stdout,"ID= %d SENSOR AZM= %6.2f ",h.chid,h.azim); 
     }

     // i_zne is 1, 2, or 3
     // check that we are still in Z/N/E order
     // and that h.chan have proper names
     if (i_zne != h.chid ) {
       fprintf(stderr,"xh_rotate(): not in order near --%s--%s--\n",h.evtcd,h.stnm); 
       exit(-1);
     }
     // check that the component name is either Z, N, or E.
     if ( h.chan[2] != 'Z' && h.chan[2] != 'N' && h.chan[2] != 'E' ) {
       fprintf(stderr,"xh_rotate(): rename channel name --%s--%s--%s--\n",h.evtcd,h.stnm,h.chan); 
       exit(-1);
     }
     // All seems fine .....
     if        ( h.chan[2]=='Z'                     && h.chid==1 ) {
       // Z  component
       z_found = 1;
       h_z = h;
       for(j=0;j<h.ndata;j++) seism_z[j] = seism[j];
     } else if ( (h.chan[2]=='N' || h.chan[2]=='1') && h.chid==2 ) {
       // NS component
       n_found = 1;
       h_n = h;
       for(j=0;j<h.ndata;j++) seism_n[j] = seism[j];
     } else if ( (h.chan[2]=='E' || h.chan[2]=='2') && h.chid==3 ){
       // EW component
       e_found = 1;
       h_e = h;
       for(j=0;j<h.ndata;j++) seism_e[j] = seism[j];
     } else {
       // Records are already rotated ?
       fprintf(stderr,"Record --%s--%s-- ", h.netw, h.stnm); 
       fprintf(stderr,"not NS or EW: channel type: %s AZM= %4.1f\n", h.chan, h.azim); 
       exit(-1);
     }
     if (jdebug) {
        fprintf(stdout,"i_zne=%d z/n/e found: %d/%d/%d\n",i_zne,z_found,n_found,e_found); 
     }
     
     if (i_zne==3 && strncmp(h_z.stnm,h_n.stnm,3)==0 && strncmp(h_z.stnm,h_e.stnm,3)==0) {
       if (z_found && n_found && e_found) {
         // Print out the VERT component first
         if (! xh_writehead(ofl,h_z))
           exit(-1);
         if (! xh_writedata(ofl,h_z,seism_z))
           exit(-1);
         // Get backazimuth baz (degrees)
         if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
           exit(-1) ;
         // Subtract h_n.azim from baz -----------------------------!!!!!
         
         if (jdebug)
           fprintf(stdout,"SENSOR alignment= %5.2f\n", h_n.azim);
         baz = baz - h_n.azim;
         // Get the start time difference between the NS and EW records:
         if (! xh_tsdiff(h_n,h_e,&td) == 1)
           exit(-1);
         fprintf(stdout,"td= %5.2f\n", td);
         fprintf(stdout,"%s az= %f baz= %f  dist= %f\n", h.stnm,az,baz,delta);
         if         (td >=0.) {
           // NS has latest start time:
           h_t = h_n;
           h_r = h_n;
           ib = td/h_n.delta;
           if (h_n.ndata >= h_e.ndata-ib) { 
             fprintf(stdout,"%s case 1\n", h_n.stnm);
             nsamp     = h_e.ndata-ib;
             h_r.ndata = nsamp;
             h_t.ndata = nsamp;
           } else {
             fprintf(stdout,"%s case 2\n", h_n.stnm);
             nsamp     = h_n.ndata;
             h_r.ndata = nsamp;
             h_t.ndata = nsamp;
           }
           for(j=0;j<nsamp;j++) {
             seism_r[j] = -1.0*cos(baz*rad)*seism_n[j]-sin(baz*rad)*seism_e[j+ib];
             seism_t[j] =     sin(baz*rad)*seism_n[j]-cos(baz*rad)*seism_e[j+ib];
             // following the conventions in excit_M() (Luis Rivera)
             seism_t[j] = -1.0*seism_t[j];
           }
         } else if (td < 0.) {
           // EW has latest start time:
           h_t = h_e;
           h_r = h_e;
           ib = -1.0*td/h_n.delta;
           fprintf(stdout,"ib= %d\n",ib);
           if (h_e.ndata >= h_n.ndata-ib) { 
             nsamp     = h_n.ndata-ib;
             h_r.ndata = nsamp;
             h_t.ndata = nsamp;
           } else {
             nsamp     = h_e.ndata;
             h_r.ndata = nsamp;
             h_t.ndata = nsamp;
           }
           for(j=0;j<nsamp;j++) {
             seism_r[j] = -1.0*cos(baz*rad)*seism_n[j+ib]-sin(baz*rad)*seism_e[j];
             seism_t[j] =      sin(baz*rad)*seism_n[j+ib]-cos(baz*rad)*seism_e[j];
             // following the conventions in excit_M() (Luis Rivera)
             seism_t[j] = -1.0*seism_t[j];
           }
         }
         h_r.chan[2] = 'R'; h_r.chid = 4;
         h_t.chan[2] = 'T'; h_t.chid = 5;
         if (! xh_writehead(ofl,h_r))
           exit(-1);
         if (! xh_writedata(ofl,h_r,seism_r))
           exit(-1);
         if (! xh_writehead(ofl,h_t))
           exit(-1);
         if (! xh_writedata(ofl,h_t,seism_t))
           exit(-1);
         // reset
         i_zne=0;
         z_found = 0;
         n_found = 0;
         e_found = 0;
       } else {
         fprintf(stderr,"Read error for station --%s--%s-- ", h_z.netw, h_z.stnm);
         fprintf(stderr,"i_zne=%d z/n/e found: %d/%d/%d\n",i_zne,z_found,n_found,e_found); 
       }
    }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_rotate in_XH out_XH \n");
fprintf(stderr,"  XH data must be in order Z/N/E\n");
return(-1);
}
