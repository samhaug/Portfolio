#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#define MAX_DATA 360000

int main(int argc, char *argv[]){
  static float N_dat[MAX_DATA],E_dat[MAX_DATA],time[MAX_DATA];
  float R_dat,T_dat;
  FILE *N_file, *E_file, *R_file, *T_file;
  float baz;
  int i,j,k,ierr;
  float t,dat;

  if (argc != 6){
    ierr = usage();
    exit(ierr);
  }

  baz = (atof(argv[1]))*M_PI/180.-180;

  if ((N_file = fopen(argv[2],"r")) == NULL) {
     fprintf(stdout,"Can't read N component!\n");
     exit(0);
  }

  if ((E_file = fopen(argv[3],"r")) == NULL) {
     fprintf(stdout,"Can't read E component!\n");
     exit(0);
  }

  if ((R_file = fopen(argv[4],"w")) == NULL) {
     exit(0);
  }

  if ((T_file = fopen(argv[5],"w")) == NULL) {
     exit(0);
  }

  i = 0;
  while (!feof(N_file)){
     fscanf(N_file,"%f %f",&t,&dat);
     N_dat[i] = dat;
     time[i] = t;
     i++;
  }

  j = 0;
  while (!feof(E_file)){
     fscanf(E_file,"%f %f",&t,&dat);
     E_dat[j] = dat;
     j++;
  }
  if ( i != j ){
     fprintf(stdout,"N and E are not the same length!\n");
     exit(1);
  }

  for (k=0;k<i-1;k++){
     R_dat = E_dat[k] * sin(baz) + N_dat[k] * cos(baz);
     T_dat = E_dat[k] * cos(baz) - N_dat[k] * sin(baz);
     fprintf(R_file,"%0.8f %0.8e\n",time[k],R_dat);
     fprintf(T_file,"%0.8f %0.8e\n",time[k],T_dat);
  }

  fclose(R_file);
  fclose(T_file);
  fclose(N_file);
  fclose(E_file);
}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"ascii_rotate_ne_rt produces R/T records given N/E input and back-azimuth.\n");
    fprintf(stdout,"Records must be two-column whitespace delimited: time data. (Specfem output)\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: ascii_rotate_ne_rt baz N_in_file E_in_file R_out_file T_out_file\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"Maximum number of datapoints allowed is %d \n",MAX_DATA);
    fprintf(stdout,"\n");
    return 0;
}
