#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

/* Reads the header of an XH file and checks whether it
the data are ordered in a Z/R/T sequence */


main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	i, ierr;

int sequence = 1;
int i_chan = 1;

int still_reading_data = 1;
float seism[XH_NPTS];

float     delta,az,baz;


char infile[80];
char stnm[6];
FILE *inf, *fopen();

int usage();

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    still_reading_data = 0;
    fprintf(stdout,"%d\n", 1);
    exit(-1);
  } else {	
    if (! xh_readdata(inf,h,seism)) {
      still_reading_data = 0;
      exit(-1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);

    // fprintf(stdout,"%d %s %-4s %-2s %-3s %d\n", i_chan,h.evtcd,h.stnm,h.netw,h.chan,h.chid);
    if        (h.chan[2] == 'Z') {
       strcpy(stnm,h.stnm);
       if (i_chan == 1) {
         i_chan++;
       } else {
        //fprintf(stderr,"ICHAN= %d STNM= %4s CHAN= %s are not matching  ...\n", i_chan,h.stnm,h.chan);
        fprintf(stdout,"%d\n", 0);
        exit(-1);
       }   
    } else if (h.chan[2] == 'R') {
       if (i_chan == 2 && strncmp(stnm,h.stnm,3) == 0) {
         i_chan++;
       } else {
        //fprintf(stderr,"ICHAN= %d STNM= %3s %3s CHAN= %s are not matching  ...\n", i_chan,h.stnm,stnm,h.chan);
        fprintf(stdout,"%d\n", 0);
        exit(-1);
       }   
    } else if (h.chan[2] == 'T') {
       if (i_chan == 3 && strncmp(stnm,h.stnm,3) == 0) {
         i_chan = 1;
       } else {
        //fprintf(stderr,"ICHAN= %d STNM= %4s CHAN= %s are not matching  ...\n", i_chan,h.stnm,h.chan);
        fprintf(stdout,"%d\n", 0);
        exit(-1);
       }   
    }   
  }
} // while

fclose (inf);
}

int usage(flnm)
char *flnm;
{
fprintf(stderr,"Cannot read XH file: %s\n",flnm);
return(-1);
}
