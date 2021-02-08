#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#define MAX_DATA 360000

int main(int argc, char *argv[]){
  static float N_dat[MAX_DATA],E_dat[MAX_DATA],Z_dat[MAX_DATA],time[MAX_DATA];
  float L_dat,Q_dat,T_dat;
  FILE *N_file, *E_file, *Z_file, *L_file, *Q_file, *T_file;
  float baz,inc;
  int i,j,k,l,ierr;
  float t,dat;

  if (argc != 9){
    ierr = usage();
    exit(ierr);
  }

  baz = (atof(argv[1]))*M_PI/180.;
  inc = (atof(argv[2]))*M_PI/180.;

  if ((N_file = fopen(argv[3],"r")) == NULL) {
     fprintf(stdout,"Can't read N component!\n");
     exit(0);
  }

  if ((E_file = fopen(argv[4],"r")) == NULL) {
     fprintf(stdout,"Can't read E component!\n");
     exit(0);
  }

  if ((Z_file = fopen(argv[5],"r")) == NULL) {
     fprintf(stdout,"Can't read Z component!\n");
     exit(0);
  }

  if ((L_file = fopen(argv[6],"w")) == NULL) {
     exit(0);
  }

  if ((Q_file = fopen(argv[7],"w")) == NULL) {
     exit(0);
  }

  if ((T_file = fopen(argv[8],"w")) == NULL) {
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

  k = 0;
  while (!feof(Z_file)){
     fscanf(Z_file,"%f %f",&t,&dat);
     Z_dat[j] = dat;
     k++;
  }

  if ( i != j || i != k || j != k){
     fprintf(stdout,"All input records must have the same length!\n");
     exit(1);
  }

  for (l=0;l<i-1;l++){
     L_dat = Z_dat[l] * cos(inc) - N_dat[l] * sin(inc)*cos(baz) - E_dat[l] * sin(inc)*sin(baz);         
     Q_dat = Z_dat[l] * sin(inc) + N_dat[l] * cos(inc)*cos(baz) + E_dat[l] * cos(inc)*sin(baz);
     T_dat = E_dat[l] * cos(baz) - N_dat[l] * sin(baz);
     fprintf(L_file,"%0.8f %0.8e\n",time[l],L_dat);
     fprintf(Q_file,"%0.8f %0.8e\n",time[l],Q_dat);
     fprintf(T_file,"%0.8f %0.8e\n",time[l],T_dat);
  }

  fclose(N_file);
  fclose(E_file);
  fclose(Z_file);
  fclose(L_file);
  fclose(Q_file);
  fclose(T_file);

}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"ascii_rotate_nez_lqt produces L/Q/T records given N/E/Z input, back-azimuth and incidence angle.\n");
    fprintf(stdout,"Records must be two-column whitespace delimited: time data. (Specfem output)\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"L: aligned with P-wave motion\n");
    fprintf(stdout,"Q: aligned with SV-wave motion\n");
    fprintf(stdout,"T: aligned with SH-wave motion\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: ascii_rotate_nez_lqt baz inc N_in_file E_in_file Z_in_file L_out_file Q_out_file T_out_file\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"Maximum number of datapoints allowed is %d \n",MAX_DATA);
    fprintf(stdout,"\n");
    return 0;
}
