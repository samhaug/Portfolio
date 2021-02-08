// xh_synch - Gives the Z,N,E (or Z,R,T) component seismograms 
// the same tstart and ndata
// It is assumed that the 3 records are grouped together ... !!!

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
    float     seism_z[XH_NPTS];
    float     seism_n[XH_NPTS];
    float     seism_e[XH_NPTS];
    xhhed     h;
    xhhed     h_z;
    xhhed     h_n;
    xhhed     h_e;
    xh_time   begtime,endtime;
    int       still_reading_data = 1;
    int       z_found=0;
    int       n_found=0;
    int       e_found=0;
    int       icount=0;
    int	      j, ierr;
    int       ib, ie, nsamp;
    float     dt;
    float     str_ne,str_nz,str_ez;
    float     end_ne,end_nz,end_ez;
    float     delta,az,baz;
    float     rad;
    FILE     *ifl, *ofl, *fopen();
    int timdif();
    int distaz();

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

while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     // check header
     if (! xh_checkheader(h))
       exit(-1);
     icount = icount+1;
     if        (h.chan[2] == 'Z') {
       // Z  component
       z_found = 1;
       h_z = h;
       for(j=0;j<h.ndata;j++) seism_z[j]=seism[j];
     } else if (h.chan[2]=='N' || h.chan[2]=='1' || h.chan[2]=='R') {
       // NS or R component
       n_found = 1;
       h_n = h;
       for(j=0;j<h.ndata;j++) seism_n[j]=seism[j];
     } else if (h.chan[2]=='E' || h.chan[2]=='2' || h.chan[2]=='T') {
       // EW or T component
       e_found = 1;
       h_e = h;
       for(j=0;j<h.ndata;j++) seism_e[j]=seism[j];
     } else {
       fprintf(stderr,"Record not NS (R) or EW (T): channel: %s\n", h.chan); 
       fprintf(stdout,"Record not NS (R) or EW (T): channel: %s\n", h.chan); 
       exit(-1);
     }
     
     if (icount==3) {
       if (z_found && n_found && e_found) {
         // check that each record as the same sampling time
         if (h_z.delta!=h_n.delta || h_z.delta!=h_e.delta) {
           fprintf(stderr,"Records do not the same dt ..\n"); 
           exit(-1);
         }
         dt = h_z.delta;
         // Get the start time difference between the NS and EW records:
         if (! xh_tsdiff(h_n,h_e,&str_ne)) {
            fprintf(stderr,"Error in xh_synch()  %s/%s/%s\n", h_n.netw,h_n.stnm,h_n.chan);
            exit(-1);
         }
         // Get the start time difference between the NS and Z  records:
         if (! xh_tsdiff(h_n,h_z,&str_nz)) {
            fprintf(stderr,"Error in xh_synch()  %s/%s/%s\n", h_n.netw,h_n.stnm,h_n.chan);
            exit(-1);
         }
         // Get the start time difference between the EW and Z  records:
         if (! xh_tsdiff(h_e,h_z,&str_ez)) {
            fprintf(stderr,"Error in xh_synch()  %s/%s/%s\n", h_n.netw,h_n.stnm,h_n.chan);
            exit(-1);
         }
         // Get the end time difference between the NS and EW records:
         if (! xh_tediff(h_n,h_e,&end_ne)) {
            fprintf(stderr,"Error in xh_synch()  %s/%s/%s\n", h_n.netw,h_n.stnm,h_n.chan);
            exit(-1);
         }
         // Get the end time difference between the NS and Z  records:
         if (! xh_tediff(h_n,h_z,&end_nz)) {
            fprintf(stderr,"Error in xh_synch()  %s/%s/%s\n", h_n.netw,h_n.stnm,h_n.chan);
            exit(-1);
         }
         // Get the end time difference between the EW and Z  records:
         if (! xh_tediff(h_e,h_z,&end_ez)) {
            fprintf(stderr,"Error in xh_synch()  %s/%s/%s\n", h_n.netw,h_n.stnm,h_n.chan);
            exit(-1);
         }

         if (str_ne >=0.) {
           if (str_nz>=0.) {
             // NS has latest start time:
             if (! xh_copytime_ts(&begtime, h_n)) exit(-1);
           } else {
             // Z has latest start time:
             if (! xh_copytime_ts(&begtime, h_z)) exit(-1);
           }
         } else {
           if (str_ez >=0.) {
             // EW has latest start time:
             if (! xh_copytime_ts(&begtime, h_e)) exit(-1);
           } else {
             // Z has latest start time:
             if (! xh_copytime_ts(&begtime, h_z)) exit(-1);
           }
         }
         if (end_ne <=0.) {
           if (end_nz<=0.) {
             // NS has earliest end time:
             if (! xh_copytime_te(&endtime, h_n)) exit(-1);
           } else {
             // Z has earliest endtime time:
             if (! xh_copytime_te(&endtime, h_z)) exit(-1);
           }
         } else {
           if (end_ez <=0.) {
             // EW has earliest end time:
             if (! xh_copytime_te(&endtime, h_e)) exit(-1);
           } else {
             // Z has earliest end time:
             if (! xh_copytime_te(&endtime, h_z)) exit(-1);
           }
         }
         fprintf(stdout,"xh_synch() working on %s/%s/%s\n", h_z.netw,h_z.stnm,h_z.chan);
         if (! xh_cutrecord(begtime,endtime,h_z,seism_z,ofl))
             fprintf(stdout,"xh_synch() problem with %s/%s/%s\n", h_z.netw,h_z.stnm, h_z.chan);
         if (! xh_cutrecord(begtime,endtime,h_n,seism_n,ofl))
             fprintf(stdout,"xh_synch() problem with %s/%s/%s\n", h_n.netw,h_n.stnm, h_n.chan);
         if (! xh_cutrecord(begtime,endtime,h_e,seism_e,ofl))
             fprintf(stdout,"xh_synch() problem with %s/%s/%s\n", h_e.netw,h_e.stnm, h_e.chan);
         icount=0;
       } else {
         fprintf(stderr,"Read error for station %s  icount= %d  ...\n", h.stnm,icount);
         fprintf(stdout,"Read error for station %s  icount= %d  ...\n", h.stnm,icount);
         return(-1);
       }
    }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_synch in_XH out_XH \n");
return(-1);
}
