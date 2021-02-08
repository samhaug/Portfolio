#include <string.h>
#include <stdio.h>
#include <math.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

main(argc,argv)
int     argc;
char    **argv;
{


float           t[npts_dat],data[npts_dat],envl[npts_dat],synt[npts_dat];

int             i, k, index, nsamp;

char            flnam[120], datcode[50], stnam[6],   chnam[6];
char            ss[120],     station[6], channel[6];

FILE           *fopen(),*ifl,*dta,*env,*snt;
/*--------------------------------------------------------------------*/



/* --- Command line input: -------------------------------------------*/
if (argc < 2 ){
  fprintf(stderr,"Usage: tracer [-i datcode] [-s station] [-c chan]\n");
  exit( -1 );
}

while ( ++index < argc && argv[index][0] == '-' ) {
   switch ( argv[index][1] ) {
      case 'i':
           if ( sscanf( argv[++index], "%s", datcode ) != 1 ) {
               fprintf(stderr, "ERROR: Illegal parameter file name ...\n" );
               exit( -1 );
           }
           break;
      case 's':
           if ( sscanf( argv[++index], "%s", stnam ) != 1 ) {
               fprintf(stderr, "ERROR: Illegal parameter file name ...\n" );
               exit( -1 );
           }
           break;
      case 'c':
           if ( sscanf( argv[++index], "%s", chnam ) != 1 ) {
               fprintf(stderr, "ERROR: Illegal parameter file name ...\n" );
               exit( -1 );
           }
           break;
       default:
           fprintf( stderr, "Usage: tracer [-i datcode] [-s station] [-c chan]\n");
           exit( -1 );
   }
}
/*--------------------------------------------------------------------*/

  i = strspace(stnam);   stnam[i]   = '\0';
  i = strspace(chnam);   chnam[i]   = '\0';
  i = strspace(datcode); datcode[i] = '\0';


sprintf(flnam,"%s.trc",datcode);
if ( (ifl = fopen(flnam,"r")) == NULL ){
           fprintf(stderr," INPUT: %s cannot be opened ...\n", flnam);
           exit(-1.);
}

k = 0;
while ( fgets(ss,120,ifl) != NULL ) {
  k=k+1;
  sscanf(ss,"%s %s %d",station, channel, &nsamp);
  i = strspace(station);  station[i] = '\0';
  i = strspace(channel);  channel[i] = '\0';
  fprintf(stdout,"station= %s channel= %s nsamp = %d\n", station,channel,nsamp);

  for (i=0; i< nsamp; ++i) {
    fgets(ss,120,ifl);
    sscanf(ss,"%f %f %f %f", &t[i],&data[i],&synt[i],&envl[i]);
  }
  if ( strcmp(station,stnam) == 0 && strcmp(channel,chnam) == 0) {
    sprintf(flnam,"%s.%s.data",stnam, chnam);
    dta = fopen(flnam,"w");
    sprintf(flnam,"%s.%s.synt",stnam, chnam);
    snt = fopen(flnam,"w");
    sprintf(flnam,"%s.%s.env", stnam, chnam);
    env = fopen(flnam,"w");
    fprintf(stdout,"station= %s channel= %s nsamp = %d\n", station,channel,nsamp);

    for (i=0; i< nsamp; ++i) {
      fprintf(dta,"%7.1f %f\n", t[i], data[i]);
      fprintf(snt,"%7.1f %f\n", t[i], synt[i]);
      fprintf(env,"%7.1f %f\n", t[i],  envl[i]);
    }
  goto cont;
  }
}


cont:
fclose(ifl);
fclose(dta);
fclose(snt);
fclose(env);
}
