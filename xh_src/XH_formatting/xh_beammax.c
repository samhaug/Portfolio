#include "beamform.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char *argv[]){
    FILE *ifl;
    beamform beam;
    int ierr,i,j,k;
    float time,waterlevel,maxlevel;
    int i_num;
    int baz,inc;
    int tmin,tmax;
    int imin,imax;

    if (argc != 8){
       ierr = usage();
       exit(ierr);
    }

    ifl = fopen(argv[1],"rb");
    fread(&beam,sizeof(beam),1,ifl);

    waterlevel = atof(argv[2]);
    maxlevel = atof(argv[3]);

    tmin = (int)(atof(argv[4])/beam.delta);
    tmax = (int)(atof(argv[5])/beam.delta);

    imin = (int)(atof(argv[6])/beam.i_inc);
    imax = (int)(atof(argv[7])/beam.i_inc);
    //printf("%8.8f\n",waterlevel);

    i_num=(int)((float)(beam.baz_max-beam.baz_min)/(float)beam.baz_inc);
    //j_num=(int)((float)(beam.i_max-beam.i_min)/(float)beam.i_inc);
    
    //fprintf("%d %d",imin,imax);

    for (i=1;i<i_num-1;i++){
      for (j=imin+1;j<imax-1;j++){
        for (k=tmin+1;k<tmax-1;k++){
           if ((beam.dat2[i][j][k] > waterlevel) && (beam.dat2[i][j][k] < maxlevel)){
             time = ((float)k*beam.delta);
             baz = (int)(beam.baz_min + i*beam.baz_inc);
             inc = (int)(beam.i_min + j*beam.i_inc);
             //fprintf(stdout,"%4d %4d %8.2f %14.8f\n",baz,inc,time,beam.dat2[i][j][k]);
             if (
                 //Front face of cube
                 
                 (beam.dat2[i][j][k] > beam.dat2[i+1][j-1][k+1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i+1][j-1][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i+1][j-1][k-1]) && 

                 (beam.dat2[i][j][k] > beam.dat2[i+1][j][k+1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i+1][j][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i+1][j][k-1]) && 

                 (beam.dat2[i][j][k] > beam.dat2[i+1][j+1][k+1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i+1][j+1][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i+1][j+1][k-1]) && 

                 //Back face of cube
                 (beam.dat2[i][j][k] > beam.dat2[i-1][j-1][k+1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-1][j-1][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-1][j-1][k-1]) && 

                 (beam.dat2[i][j][k] > beam.dat2[i-1][j][k+1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-1][j][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-1][j][k-1]) && 

                 (beam.dat2[i][j][k] > beam.dat2[i-1][j+1][k+1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-1][j+1][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-1][j+1][k-1]) && 

                 //Top of cube
                 (beam.dat2[i][j][k] > beam.dat2[i][j][k+1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i][j+1][k+1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i][j-1][k+1]) && 

                 //Bottom of cube
                 (beam.dat2[i][j][k] > beam.dat2[i][j][k-1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i][j+1][k-1]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i][j-1][k-1]) && 

                 //sides
                 (beam.dat2[i][j][k] > beam.dat2[i][j-1][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i][j+1][k]) &&

                 //look +- 5 degress baz away to prevent zig-zag
                 (beam.dat2[i][j][k] > beam.dat2[i+2][j][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-2][j][k]) &&
                 (beam.dat2[i][j][k] > beam.dat2[i+3][j][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-3][j][k]) &&
                 (beam.dat2[i][j][k] > beam.dat2[i+4][j][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-4][j][k]) &&
                 (beam.dat2[i][j][k] > beam.dat2[i+5][j][k]) && 
                 (beam.dat2[i][j][k] > beam.dat2[i-5][j][k])){

                 //Add 400 seconds to account for time offset
                 fprintf(stdout,"%4d %4d %8.2f %14.8f\n",baz,inc,time+400,beam.dat2[i][j][k]);

             } // inner if 
           } // waterlevel if
         } // for k
       } // for j
     } // for i
    return(0);
} // main

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_beammax BEAMFILE waterlevel maxlevel tmin tmax imin imax\n");
    fprintf(stdout,"BEAMFILE is output binary file from xh_beamform or xh_3compbeamform\n");
    fprintf(stdout,"waterlevel: return all local maxima above this waterlevel\n");
    fprintf(stdout,"maxlevel: return all local maxima below this level\n");
    fprintf(stdout,"tmin/tmax: specify temporal bounds\n");
    fprintf(stdout,"imin/imax: specify incidence angle bounds\n");
    fprintf(stdout,"\n");
    fprintf(stdout,"OUTPUT: baz, inc, time, amplitude\n");
    return(0);
}





