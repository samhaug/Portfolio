#include "beamform_zcomp.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define deg2rad M_PI/180.
int usage();

int main(int argc,char *argv[]){
    FILE *ifl, *ofl;
    beamform beam;
    int ierr;

    if (argc != 9){
       ierr = usage();
       exit(ierr);
    }

    if (!(ifl = fopen(argv[1],"rb"))) usage();
    if (!(ofl = fopen(argv[2],"wb"))) usage();

    float baz_min     = atof(argv[3]);
    float baz_max     = atof(argv[4]);
    float i_min       = atof(argv[5]);
    float i_max       = atof(argv[6]);
    float t_start     = atof(argv[7]);
    float t_end       = atof(argv[8]);

    float maxamp = 0.;

    while(!feof(ifl)){
       fread(&beam,sizeof(beam),1,ifl);
       // disregard baz out of limits
       if ((beam.baz > baz_max) || (beam.baz < baz_min)) continue;
       // disregard inc out of limits
       if ((beam.inc > i_max) || (beam.inc < i_min)) continue;
       int i_start = (int)(t_start/beam.delta_t);
       int i_end   = (int)(t_end/beam.delta_t);
       for (int i=i_start;i<i_end;i++){
           if (fabs(beam.dat[i]) > maxamp) maxamp=fabs(beam.dat[i]);
       }
    }
    rewind(ifl);

    while(!feof(ifl)){
       fread(&beam,sizeof(beam),1,ifl);
       for (int i=0;i<beam.ndata;i++){
           beam.dat[i] = beam.dat[i]/maxamp;
       }
       fwrite(&beam,sizeof(beam),1,ofl);
    }
    fclose(ifl);
    fclose(ofl);

}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_beamnorm_zcomp BEAM_IN BEAM_OUT baz_min baz_max i_min i_max t_start t_end\n");
    fprintf(stdout,"BEAM_IN is input binary file from xh_beamform_zcomp\n");
    fprintf(stdout,"BEAM_OUT will be normalized BEAM_IN\n");
    fprintf(stdout,"baz_min/max: search for maxima between baz limits\n");
    fprintf(stdout,"i_min/max: search for maxima between incidence angle limits\n");
    fprintf(stdout,"t_start/end: search for maxima between time limits\n");
    fprintf(stdout,"\n");
    return(0);
    exit(-1);
}





