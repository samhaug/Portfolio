/* program to scan the PDE file
   "$UTILS/PDE_catalog/pde.bin" for particular events*/

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/file.h>
#define TRUE 1
#define FALSE 0

#include "pde.h"

void usage( );

int fill_pdeheader(code,h)
char  code[11];
pdehed *h;
{

pdehed h1;  /* temporary PDE header */
char  PDECATALOG[130];
FILE *fp;

sprintf(PDECATALOG,"%s","/home/jeroen/Utils/PDE_catalog/pde.bin");

if ((fp = fopen(PDECATALOG, "r"))==NULL) {
    printf("\n\nError opening %s\n",PDECATALOG);
    printf("Exiting !! \n");
    return(0);
}

fread(&h1,sizeof(h1),1,fp);
while (strncmp(h1.pdecd,code,10) != 0) {
  if ( fread(&h1,sizeof(h1),1,fp) != 1) {
    fprintf(stderr,"fill_pdeheader() EOF reached ...\n");
    return(0);
  }
} 

fprintf(stdout,"FILL_PDEheader %s %02d/%02d/%02d %02d:%02d:%04.1f",
  h1.pdecd,h1.yr,h1.mo,h1.day,h1.hr,h1.mn,h1.sec);
fprintf(stdout,"  H= %5.1f Mb= %3.1f Ms= %3.1f Mw= %3.1f\n",
  h1.dep,h1.mb,h1.ms,h1.mw);


*h = h1;

return(1);
}
