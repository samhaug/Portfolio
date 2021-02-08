#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#define MAX_DATA 360000

int main(int argc, char *argv[]){
  static float N_dat,E_dat,time[MAX_DATA];
  float R_dat[MAX_DATA],T_dat[MAX_DATA];
  FILE *N_file, *E_file, *R_file, *T_file;
  float baz;
  int i,j,k,ierr;
  float t,dat;

  if (argc != 6){
    ierr = usage();
    exit(ierr);
  }

  baz = (atof(argv[1]))*M_PI/180.;
  baz = 360. - baz;
  baz = baz-180.;

  if ((R_file = fopen(argv[2],"r")) == NULL) {
     fprintf(stdout,"Can't read R component!\n");
     exit(0);
  }

  if ((T_file = fopen(argv[3],"r")) == NULL) {
     fprintf(stdout,"Can't read T component!\n");
     exit(0);
  }

  if ((N_file = fopen(argv[4],"w")) == NULL) {
     exit(0);
  }

  if ((E_file = fopen(argv[5],"w")) == NULL) {
     exit(0);
  }

  i = 0;
  while (!feof(R_file)){
     fscanf(R_file,"%f %f",&t,&dat);
     R_dat[i] = dat;
     time[i] = t;
     i++;
  }

  j = 0;
  while (!feof(T_file)){
     fscanf(T_file,"%f %f",&t,&dat);
     T_dat[j] = dat;
     j++;
  }
  if ( i != j ){
     fprintf(stdout,"R and T are not the same length!\n");
     exit(1);
  }

  for (k=0;k<i-1;k++){
     N_dat = T_dat[k] * sin(baz) + R_dat[k] * cos(baz);
     E_dat = T_dat[k] * cos(baz) - R_dat[k] * sin(baz);
     fprintf(N_file,"%0.8f %0.8e\n",time[k],N_dat);
     fprintf(E_file,"%0.8f %0.8e\n",time[k],E_dat);
  }

  fclose(R_file);
  fclose(T_file);
  fclose(N_file);
  fclose(E_file);
}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"ascii_rotate_rt_ne produces N/E records given R/T input and back-azimuth.\n");
    fprintf(stdout,"Records must be two-column whitespace delimited: time data. (Specfem output)\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: ascii_rotate_ne_rt baz R_in_file T_in_file N_out_file E_out_file\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"Maximum number of datapoints allowed is %d \n",MAX_DATA);
    fprintf(stdout,"\n");
    return 0;
}
