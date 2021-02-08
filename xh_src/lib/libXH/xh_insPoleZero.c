#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include <math.h>
#include "xhhead.h"	/* XH format structures */

// inserts the PoleZeros of an instrument.
// See also sac_2xh.c.
//
// I was unable to write XH data using RDSEED for
// SEED data requested from netdc@seismo.berkeley.edu
// XH data are (for now?) made using sac_2xh after
// first retrieving SAC files from the SEED data. 
//
// J. Ritsema, IPGP, March 2004.


int xh_insPoleZero(pzfile,h)
char *pzfile;
xhhed *h;
{

int ierr=1;
FILE *ifl, *fopen();
char ss[80];
char str[80];

int i;
int nzeros;
int npoles;
float constant;


// fprintf(stdout,"in xh_insPoleZero() \n");
fprintf(stdout,"pzfile= %s\n", pzfile);
if ((ifl = fopen(pzfile,"r")) == NULL) {
  fprintf(stderr,"xh_insPoleZero(): %s not found\n", pzfile);  
  return(0);
}

// number of zeroes
fgets(ss,80,ifl);
sscanf(ss,"%s %d", str, &nzeros);
if ( strncmp(str,"ZEROS",5) != 0) {
  fprintf(stderr,"xh_insPoleZero(): first line does not provide");
  fprintf(stderr,"number of ZEROS: first entry should be \"ZEROS\"\n");
  return(0);
} else {
  h->zero[0].r = nzeros*1.0;
  h->zero[0].i = 0.;
}
fprintf(stdout,"number of zeros= %f\n", h->zero[0].r);

// number of poles
fgets(ss,80,ifl);
sscanf(ss,"%s %d", str, &npoles);
if ( strncmp(str,"POLES",5) != 0) {
  fprintf(stderr,"xh_insPoleZero(): second line does not provide");
  fprintf(stderr,"number of POLES: first entry should be \"POLES\"\n");
  return(0);
} else {
  h->pole[0].r = npoles*1.0;
  h->pole[0].i = 0.;
}
fprintf(stdout,"number of poles= %f\n", h->pole[0].r);

// values of the poles
for (i=1;i<=npoles;i++) {
  fgets(ss,80,ifl);
  sscanf(ss,"%f %f", &h->pole[i].r, &h->pole[i].i);
}

// constant (ds*a0)
fgets(ss,80,ifl);
sscanf(ss,"%s %e", str, &constant);
if ( strncmp(str,"CONSTANT",8) != 0) {
  fprintf(stderr,"xh_insPoleZero(): Constant not properly read");
  return(0);
} else {
  h->A0 = constant;
  h->DS = 1.;
}


return(1);
}
