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

    if (argc != 2){
       ierr = usage();
       exit(ierr);
    }

    if (!(ifl = fopen(argv[1],"rb"))) usage();

    fread(&beam,sizeof(beam),1,ifl);
    printf("ndata:      %8d\n",beam.ndata);        // number of trace samples  
    printf("baz_min:    %8d\n",beam.baz_min);      
    printf("baz_max:    %8d\n",beam.baz_max);      
    printf("baz_inc:    %8d\n",beam.baz_inc);       
    printf("i_min:      %8d\n",beam.i_min);         
    printf("i_max:      %8d\n",beam.i_max);         
    printf("i_inc:      %8d\n",beam.i_inc);         
    printf("p_min:      %8.2f\n",beam.p_min);        // distance from source to array center (deg)
    printf("p_max:      %8.2f\n",beam.p_max);        // distance from source to array center (deg)
    printf("gcarc:      %8.2f\n",beam.gcarc);        // distance from source to array center (deg)
    printf("sr_baz:     %8.2f\n",beam.sr_baz);       // back-azimuth from source to array along great circle
    printf("sr_az:      %8.2f\n",beam.sr_az);      // back-azimuth from source to array along great circle
    printf("evdp:       %8.2f\n",beam.evdp);      // eq depth
    printf("slat:       %8.2f\n",beam.slat);      // array lat
    printf("slon:       %8.2f\n",beam.slon);      // array lon
    printf("elat:       %8.2f\n",beam.elat);      // event lat
    printf("elon:       %8.2f\n",beam.elon);      // event lon
    printf("filter:     %4d %4d %4d %4d\n",beam.filt[0],beam.filt[1],beam.filt[2],beam.filt[3]); //filter cutoffs

    fclose(ifl);
}

int usage(){
    fprintf(stdout,"\n");
    fprintf(stdout,"USAGE: xh_describe_zcomp BEAM_IN \n");
    fprintf(stdout,"\n");
    return(0);
    exit(-1);
}





