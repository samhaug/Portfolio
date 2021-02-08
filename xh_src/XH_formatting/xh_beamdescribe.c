#include "beamform.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
    FILE *ifl;
    beamform beam;
    int ierr;
    float dat1max=-1e9,dat1min=1e9,dat2max=-1e9,dat2min=1e9,dat3max=-1e9,dat3min=1e9;
    int i,j,k;
    int baz_lim,i_lim;

    if (argc != 2){
       ierr = usage();
       exit(ierr);
    }

    ifl = fopen(argv[1],"rb");
    fread(&beam,sizeof(beam),1,ifl);
    fprintf(stdout,"delta: %5.3f\n",beam.delta);
    fprintf(stdout,"ndata: %d\n",beam.ndata);
    fprintf(stdout,"array_centroid_lat: %5.3f\n",beam.a_lat);
    fprintf(stdout,"array_centroid_lon: %5.3f\n",beam.a_lon);
    fprintf(stdout,"event_lat: %5.3f\n",beam.e_lat);
    fprintf(stdout,"event_lon: %5.3f\n",beam.e_lon);
    fprintf(stdout,"event_depth: %5.3f\n",beam.e_dep);
    fprintf(stdout,"baz_min: %d\n",beam.baz_min);
    fprintf(stdout,"baz_max: %d\n",beam.baz_max);
    fprintf(stdout,"baz_inc: %d\n",beam.baz_inc);
    fprintf(stdout,"i_min: %d\n",beam.i_min);
    fprintf(stdout,"i_max: %d\n",beam.i_max);
    fprintf(stdout,"i_inc: %d\n",beam.i_inc);
    baz_lim = (int)((beam.baz_max-beam.baz_min)/(float)beam.baz_inc);
    i_lim = (int)((beam.i_max-beam.i_min)/(float)beam.i_inc);
    fprintf(stdout,"baz_lim: %d\n",baz_lim);
    fprintf(stdout,"i_lim: %d\n",i_lim);
    for (i=0;i<baz_lim;i++){
      for (j=0;j<i_lim;j++){
        for (k=0;k<beam.ndata;k++){
           if (beam.dat1[i][j][k] > dat1max){
             dat1max = beam.dat1[i][j][k]; 
           }
           if (beam.dat2[i][j][k] > dat2max){
             dat2max = beam.dat2[i][j][k]; 
           }
           if (beam.dat3[i][j][k] > dat3max){
             dat3max = beam.dat3[i][j][k]; 
           }
           if (beam.dat1[i][j][k] < dat1min){
             dat1min = beam.dat1[i][j][k]; 
           }
           if (beam.dat2[i][j][k] < dat2min){
             dat2min = beam.dat2[i][j][k]; 
           }
           if (beam.dat3[i][j][k] < dat3min){
             dat3min = beam.dat3[i][j][k]; 
           }
        }
      }   
    }
    fprintf(stdout,"dat1 min/max: %8.4f %8.4f\n",dat1min,dat1max);
    fprintf(stdout,"dat2 min/max: %8.4f %8.4f\n",dat2min,dat2max);
    fprintf(stdout,"dat3 min/max: %8.4f %8.4f\n",dat3min,dat3max);


}

int usage(){
    fprintf(stdout,"USAGE: xh_beamdescribe BEAMFILE\n");
    fprintf(stdout,"BEAMFILE is output binary file from xh_beamform\n");
    fprintf(stdout,"\n");
    return(0);
}





