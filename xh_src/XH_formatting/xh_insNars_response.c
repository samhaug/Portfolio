#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures
#include "cmt.h"		// CMT  structure
#include "time.h"		// TIME structure

// Inserts NARS-Baja instrument response

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;
int npoles, nzeros;
int century=1900;

int fill_cmtheader();

cmthed  cmt;
int still_reading_data = 1;
float seism[XH_NPTS];

float tdiff;

char infile[80];
FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 3) usage("");
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,seism))
      exit(0);
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);

  // Instrument Response Info: */
  //if ( strncmp(h.netw,"NR",2) == 0 && lrint(h.pole[0].r) <= 0 && lrint(h.zero[0].r) <= 0 ) {
  if ( strncmp(h.netw,"NR",2) == 0 ) {
    // fprintf(stdout,"Adding STS-II resp: %s %s\n",h.stnm,h.chan);
    // fprintf(stdout,"Adding STS-II resp: %s %s\n",h.stnm,h.chan);
    h.DS = 419430.0;
    h.A0 = 1500.;
    for(i=0; i<30; ++i) {
       h.pole[i].r = 0.;
       h.pole[i].i = 0.;
       h.zero[i].r = 0.;
       h.zero[i].i = 0.;
    }
    h.pole[0].r = 2.;
    h.zero[0].r = 3.;
    h.pole[1].r = -0.0370036;
    h.pole[1].i =  0.0370036;
    h.pole[2].r = -0.0370036;
    h.pole[2].i = -0.0370036;
  }

  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit(-1);
} // while 

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_insNars_response in_XHfile out_XHfile\n");
        return(-1);
}
