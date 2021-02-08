#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures
#include "ndk.h"		// CMT  structure
#include "time.h"		// TIME structure

// Inserts CNSN instrument response

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
  if ( strncmp(h.netw,"CN",2) == 0 ) {
    fprintf(stdout,"Adding RESP: %s %s\n",h.stnm,h.chan);

    if (strncmp(h.stnm,"GAC",3) == 0) {
	   fprintf(stderr,"Working on station: %s %s\n", h.netw, h.stnm);
           h.DS = 4.79302E+10;
           h.A0 = 978.935;
           /* POLES: */
           h.pole[0].r = 4.;
           h.pole[0].i = 0.;
           h.pole[1].r = -0.2221;
           h.pole[1].i = -0.2221;
           h.pole[2].r = -0.2221;
           h.pole[2].i =  0.2221;
           h.pole[3].r = -19.5878;
           h.pole[3].i = -24.5617;
           h.pole[4].r = -19.5878;
           h.pole[4].i =  24.5617;
           /* ZEROES: */
           h.zero[0].r = 3.;
           h.zero[0].i = 0.;
           h.zero[1].r = 0.;
           h.zero[1].i = 0.;
           h.zero[2].r = 0.;
           h.zero[2].i = 0.;
           h.zero[3].r = 0.;
           h.zero[3].i = 0.;
        }
        if (strncmp(h.stnm,"CBB",3) == 0) {
	   fprintf(stderr,"Working on station: %s %s\n", h.netw, h.stnm);
           h.DS = 1.67552E+10;
           h.A0 = 314.263;
           /* POLES: */
           h.pole[0].r = 3.;
           h.pole[0].i = 0.;
           h.pole[1].r = -0.1481;
           h.pole[1].i =  0.1481;
           h.pole[2].r = -0.1481;
           h.pole[2].i = -0.1481;
           h.pole[3].r = -314.2;
           h.pole[3].i =   0.0000;
           /* ZEROES: */
           h.zero[0].r = 3.;
           h.zero[0].i = 0.;
           h.zero[1].r = 0.;
           h.zero[1].i = 0.;
           h.zero[2].r = 0.;
           h.zero[2].i = 0.;
           h.zero[3].r = 0.;
           h.zero[3].i = 0.;
        }
        if (strncmp(h.stnm,"BBB",3)  == 0 || strncmp(h.stnm,"BMBC",4) == 0 ||
            strncmp(h.stnm,"EDM",3)  == 0 || strncmp(h.stnm,"FCC",3)  == 0 ||
            strncmp(h.stnm,"FNBC",4) == 0 || strncmp(h.stnm,"INK",3)  == 0 ||
            strncmp(h.stnm,"KAPO",4) == 0 || strncmp(h.stnm,"LLLB",4) == 0 ||
            strncmp(h.stnm,"LMN",3)  == 0 || strncmp(h.stnm,"LMQ",3)  == 0 ||
            strncmp(h.stnm,"MOBC",4) == 0 || strncmp(h.stnm,"PGC",3)  == 0 ||
            strncmp(h.stnm,"PHC",3)  == 0 || strncmp(h.stnm,"PNT",3)  == 0 ||
            strncmp(h.stnm,"RES",3)  == 0 || strncmp(h.stnm,"SADO",4) == 0 ||
            strncmp(h.stnm,"SCHQ",4) == 0 || strncmp(h.stnm,"SLEB",4) == 0 ||
            strncmp(h.stnm,"ULM",3)  == 0 || strncmp(h.stnm,"WALA",4) == 0 ||
            strncmp(h.stnm,"WHY",3)  == 0 || strncmp(h.stnm,"DAWY",4) == 0 ||
            strncmp(h.stnm,"DLBC",4) == 0) {
	   fprintf(stderr,"Working on station: %s %s\n", h.netw, h.stnm);
           h.DS = 3.14159E+10;
           if (strncmp(h.stnm,"PHC",3) == 0) {
             h.DS = 3.92699E+09;
           }
           h.A0 = 98752.4;
           /* POLES: */
           h.pole[0].r = 4.;
           h.pole[0].i = 0.;
           h.pole[1].r = -0.0314;
           h.pole[1].i =  0.0000;
           h.pole[2].r = -0.2094;
           h.pole[2].i =  0.0000;
           h.pole[3].r = -222.1110;
           h.pole[3].i = -222.178;
           h.pole[4].r = -222.1110;
           h.pole[4].i =  222.178;
           /* ZEROES: */
           h.zero[0].r = 3.;
           h.zero[0].i = 0.;
           h.zero[1].r = 0.;
           h.zero[1].i = 0.;
           h.zero[2].r = 0.;
           h.zero[2].i = 0.;
           h.zero[3].r = 0.;
           h.zero[3].i = 0.;
        }
        if (strncmp(h.stnm,"DRLN",4) == 0 || strncmp(h.stnm,"FRB",3)  == 0  ||
            strncmp(h.stnm,"YKW1",4) == 0 || strncmp(h.stnm,"YKW2",4) == 0 ||
            strncmp(h.stnm,"YKW3",4) == 0 || strncmp(h.stnm,"YKW4",4) == 0 ) {
	   fprintf(stderr,"Working on station: %s %s\n", h.netw, h.stnm);
           h.DS = 5.18300E+10;
           if (strncmp(h.stnm,"YKW1",4) == 0) {
             h.DS = 2.86119E+10;
           }
           if (strncmp(h.stnm,"YKW2",4) == 0) {
             h.DS = 2.86119E+10;
           }
           if (strncmp(h.stnm,"YKW3",4) == 0) {
             h.DS = 2.48249E+10;
           }
           if (strncmp(h.stnm,"YKW4",4) == 0) {
             h.DS =  2.86119E+10;
           }
           h.A0 = 3936.82;
           /* POLES: */
           h.pole[0].r = 4.;
           h.pole[0].i = 0.;
           h.pole[1].r = -0.0123;
           h.pole[1].i = -0.0123;
           h.pole[2].r = -0.0123;
           h.pole[2].i =  0.0123;
           h.pole[3].r = -39.1142;
           h.pole[3].i = -49.1485;
           h.pole[4].r = -39.1142;
           h.pole[4].i =  49.1485;
           /* ZEROES: */
           h.zero[0].r = 3.;
           h.zero[0].i = 0.;
           h.zero[1].r = 0.;
           h.zero[1].i = 0.;
           h.zero[2].r = 0.;
           h.zero[2].i = 0.;
           h.zero[3].r = 0.;
           h.zero[3].i = 0.;
        }
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
