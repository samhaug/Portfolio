#include <stdio.h>
#include <math.h>
#include <stdlib.h>

main(argc,argv)
int argc;
char *argv[];
{
int 	i, ierr, i_5s;
int     i_pck, i_slp, i_max1, i_max2;

float data[100];
int tpcks, qual=0;

char infile[80];
char ss[80];
FILE *ifl, *ofl, *fopen();

int usage();

// Command line input
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(-1);
}

for(i=0;i<30;i++) {
  fgets(ss,80,ifl);
  sscanf(ss,"%*d %f", &data[i]);
}

i_pck = 17;
// [-5,+5] second search window -- break as soon as maximum is found
i_5s = 5;

i_max1 = -1; 
i_max2 = -1; 
i_slp = slope(data[i_pck-1],data[i_pck]);
fprintf(stdout,"A10 beginning i_slp= %d\n",i_slp);
for (i=i_pck; i<i_pck+i_5s; i++) {
  fprintf(stdout,"------------------\n");
  fprintf(stdout,"A12 i= %d i_slp= %d\n",i,i_slp);
  fprintf(stdout,"A13 v1= %f v2= %f\n",data[i],data[i+1]);
  if ( slope(data[i],data[i+1]) != i_slp) {
    i_max1 = i; 
    fprintf(stdout,"A-- i= %d i_max1= %d\n", i, i_max1);
    break;
  } 
  fprintf(stdout,"A15 i= %d i_slp= %d\n", i, i_slp);
}
fprintf(stdout,"A19 i= %d i_max1= %d\n", i, i_max1);

fprintf(stdout,"\n");
i_slp = slope(data[i_pck],data[i_pck+1]);
fprintf(stdout,"B20 beginning i_slp= %d\n",i_slp);
for (i=i_pck;i>-i_5s;i--) {
  fprintf(stdout,"------------------\n");
  fprintf(stdout,"B22 i= %d i_slp= %d\n",i,i_slp);
  fprintf(stdout,"B23 v1= %f v2= %f\n",data[i-1],data[i]);
  if ( slope(data[i-1],data[i]) != i_slp) {
    i_max2 = i; 
    fprintf(stdout,"B-- i= %d i_max2= %d\n", i, i_max2);
    break;
  } 
  fprintf(stdout,"B25 i= %d i_slp= %d\n", i, i_slp);
}
fprintf(stdout,"B29 i= %d i_max2= %d\n", i, i_max2);

if        ( i_max1 == -1  )  { 
  if ( i_max2 != -1) {
    tpcks = i_max2;
  } else {
    fprintf(stderr,"Record -- i_max1=i_max2=-1\n");
    qual = -1;
  }
} else if ( i_max2 == -1  )  {
  if ( i_max1 != -1) {
    tpcks = i_max1;
  } else {
    fprintf(stderr,"Record -- i_max1=i_max2=-1\n");
    qual = -1;
  }
} else {
    fprintf(stderr,"Record -- closeby maxima\n");
    tpcks = i_pck;
    qual = -1;
}
fprintf(stdout,"i_max1= %d i_max2= %d\n",i_max1, i_max2);
fprintf(stdout,"tpcks= %d qual= %d\n",tpcks, qual);
    

fclose (ifl);
}


int slope(v1,v2)
float v1,v2;
{
  int i_slp = 0;

  if ( v2>v1 ) i_slp =  1;
  if ( v2<v1 ) i_slp = -1;
  return(i_slp);
}



int usage()
        {
        fprintf(stderr,"Usage: xh_Palignment in_XH out_XH [-t T1 T2]\n");
        return(0);
}
