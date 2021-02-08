#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/types.h>
#include <time.h>

/* returns the index with the first appearing blank */

#define NRAND 100001

int randnumbers(fp,nsamp,nboot)

FILE *fp;
int nsamp, nboot;
{
int i, j;
int boot[NRAND];
float r;

time_t t1;

(void) time(&t1);

srand48((long) t1); /* use time in seconds to set seed */

if (nsamp > NRAND) {
  fprintf(stderr, "randnumber() -- nsamp is larger than %d\n", NRAND);
  return(0);
}

for (i=0; i<nboot; i++) {
  for (j=0; j<nsamp; j++) {
    r = lrand48();
    r = r/(RAND_MAX * 1.);
    r = r*nsamp;
    boot[j] = floorf(r);
    fprintf(fp,"%d\n", boot[j]);
  }
}
return(1);

}

