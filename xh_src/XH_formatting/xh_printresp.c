#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

// Reads the header of an XH file and prints response info


main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	i, j,ierr;
int     itr=0, nstns=0;
int     index = 0;

int still_reading_data = 1;
float seism[XH_NPTS];

char infile[80];
char kstations[200][6];
FILE *inf, *fopen();

int usage();

if (argc < 4) {
  ierr = usage();
  exit(ierr);
}

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage(argv[1]);
   exit(ierr);
}
index = 1;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 's':
        index++;
        j=0;
        while(index<=argc) {
          sprintf(kstations[j], "%s", argv[index]);
          index++;
          j++;
        }
        nstns=j-1;
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}


while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    still_reading_data = 0;
    exit(-1);
  } else {	
    if (! xh_readdata(inf,h,seism)) {
      still_reading_data = 0;
      exit(-1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);
    itr++;
     for (j=0;j<nstns;j++) {
         if (strncmp(h.stnm,kstations[j],strlen(kstations[j])) == 0 ||
             strncmp("all",kstations[0],3) == 0) {
            fprintf(stdout,"\n%7s %-4s %-2s %-3s PZ %ld/%ld\n",
              h.cmtcd,h.stnm,h.netw,h.chan,lrint(h.pole[0].r),lrint(h.zero[0].r));
            fprintf(stdout,"%4.0f POLES\n", h.pole[0].r);  
            for (i=1; i<=lrint(h.pole[0].r); i++)
              fprintf(stdout,"h.pole[%i].r = %11.3e; h.pole[%i].i = %11.3e;\n",i,h.pole[i].r,i,h.pole[i].i);  
            fprintf(stdout,"%4.0f ZEROS\n", h.zero[0].r);  
            for (i=1; i<=lrint(h.zero[0].r); i++)
              fprintf(stdout,"h.zero[%i].r = %11.3e; h.zero[%i].i = %11.3e;\n",i,h.zero[i].r,i,h.zero[i].i);  
            fprintf(stdout,"h.A0= %11.3e;\n", h.A0);  
            fprintf(stdout,"h.DS= %11.3e;\n", h.DS);  
         }
     }
  }
} // while

fclose (inf);
fflush(stdout);
}

int usage(flnm)
char *flnm;
{
fprintf(stderr,"Usage: xh_printresp in_XH -s STNM\n");
fprintf(stderr,"or:    xh_printresp in_XH -s all\n");
return(-1);
}
