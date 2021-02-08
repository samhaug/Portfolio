#include "beamform_zcomp.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define deg2rad M_PI/180.
int usage();

int main(int argc,char *argv[]){
    FILE *ifl;
    beamform beam;
    int ierr;

    if (argc != 5){
       ierr = usage();
       exit(ierr);
    }

    if (!(ifl = fopen(argv[1],"rb"))) usage();

    float baz     = atof(argv[2]);
    float t_start = atof(argv[3]);
    float t_end   = atof(argv[4]);

    while(!feof(ifl)){
       fread(&beam,sizeof(beam),1,ifl);
       if (beam.baz != baz) continue;
       int i_start = (int)(t_start/beam.delta_t);
       int i_end   = (int)(t_end/beam.delta_t);
       int j=0;
       for (int i=i_start;i<i_end;i++){
           printf("%9.4f %9.4f %9.4f %9.5f\n",t_start+(j*beam.delta_t),beam.inc,beam.p,beam.dat[i]);
           j++;
       }
    }
}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_beamvesp_zcomp BEAMFILE baz t_start t_end\n");
    fprintf(stdout,"BEAMFILE is output binary file from xh_beamform or xh_3compbeamform\n");
    fprintf(stdout,"baz: back-azimuth from which to compte vespagram\n");
    fprintf(stdout,"t_start: start time of vespagram\n");
    fprintf(stdout,"t_end: end time of vespagram\n");
    fprintf(stdout,"\n");
    return(0);
    exit(-1);
}





