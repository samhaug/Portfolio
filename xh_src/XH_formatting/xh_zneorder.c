// xh_zneorder //
// Reorder xh stream to be in Z,N,E format.
// This prepares it for use with xh_rotate.
// 
// Samuel Haugland March 2019

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

int check_list(char *carray[],char *statname);

main(int argc, char *argv[]){
    float   seism_z_in[XH_NPTS];
    float   seism_n_in[XH_NPTS];
    float   seism_e_in[XH_NPTS];
    xhhed   h_z_in;
    xhhed   h_n_in;
    xhhed   h_e_in;
    int     still_reading_zdata = 1;
    int     still_reading_ndata = 1;
    int     still_reading_edata = 1;
    int     h_n_found;
    int     h_e_found;
    int	    j=0, ierr, k;
    FILE    *zifl, *eifl, *nifl, *ofl, *fopen();

    if (argc != 5){
        ierr = usage();
        exit(ierr);
    }
    // Read Z component
    if ((zifl = fopen(argv[1],"r")) == NULL) {
        fprintf(stdout,"Z comp not found\n");
        ierr = usage();
        exit(-1);
    }
    // Read N component
    if ((nifl = fopen(argv[2],"r")) == NULL) {
        fprintf(stdout,"N comp not found\n");
        ierr = usage();
        exit(-1);
    }
    // Read E component
    if ((eifl = fopen(argv[3],"r")) == NULL) {
        fprintf(stdout,"E comp not found\n");
        ierr = usage();
        exit(-1);
    }
    // open output for writing
    if ((ofl = fopen(argv[4],"w")) == NULL) {
        ierr = usage();
        exit(-1);
    }
    // Outside loop looks for Z component
    while (still_reading_zdata){
        if (!xh_readhead(zifl,&h_z_in)){
           still_reading_zdata = 0;
           exit(0);
        } 
        else {
            if (!xh_readdata(zifl,h_z_in,seism_z_in)){
               still_reading_zdata = 0;
               exit(0);
            }
            if (!xh_checkheader(h_z_in)){
               still_reading_zdata = 0;
               exit(0);
            }
        }
        // Check for North component
        while (still_reading_ndata){
            if (!xh_readhead(nifl,&h_n_in)){
               still_reading_ndata = 0;
            } 
            else {
                if (!xh_readdata(nifl,h_n_in,seism_n_in)){
                   still_reading_ndata = 0;
                }
                if (!xh_checkheader(h_n_in)){
                   still_reading_ndata = 0;
                }
            }

            if(h_n_in.chan[2] == 'N'){
            }
            if (
                h_n_in.chan[2] == 'N' && 
                h_n_in.chid == 2 && 
                h_n_in.locc == h_z_in.locc && 
                !strcmp(h_z_in.netw,h_n_in.netw) &&
                !strcmp(h_z_in.stnm,h_n_in.stnm)){ 
                h_n_found = 1;
                break;
            }
            else{
                h_n_found = 0;
            }
        }
        // Check for East component
        while (still_reading_edata){
            if (!xh_readhead(eifl,&h_e_in)){
               still_reading_edata = 0;
            } 
            else {
                if (!xh_readdata(eifl,h_e_in,seism_e_in)){
                   still_reading_edata = 0;
                }
                if (!xh_checkheader(h_e_in)){
                   still_reading_edata = 0;
                }
            }
            if (
                h_e_in.chan[2] == 'E' && 
                h_e_in.chid == 3 && 
                h_e_in.locc == h_z_in.locc && 
                !strcmp(h_z_in.netw,h_e_in.netw) &&
                !strcmp(h_z_in.stnm,h_e_in.stnm)){
                h_e_found = 1;
                break;
            }
            else{
                h_e_found = 0;
            }
        }
        if (h_n_found == 1 && h_e_found == 1){
           fprintf(stdout,"WRITING  %s %s\n",h_z_in.netw,h_z_in.stnm); 
           if (! xh_writehead(ofl,h_z_in))            exit(-1);
           if (! xh_writedata(ofl,h_z_in,seism_z_in)) exit(-1);
           if (! xh_writehead(ofl,h_n_in))            exit(-1);
           if (! xh_writedata(ofl,h_n_in,seism_n_in)) exit(-1);
           if (! xh_writehead(ofl,h_e_in))            exit(-1);
           if (! xh_writedata(ofl,h_e_in,seism_e_in)) exit(-1);
           fseek(nifl,0,SEEK_SET);
           fseek(eifl,0,SEEK_SET);
           h_e_found = 0;
           h_n_found = 0;
           still_reading_ndata=1;
           still_reading_edata=1;
        }
        else if (h_n_found == 0){
           fprintf(stdout,"    N not found %s %s\n",
                   h_z_in.netw,h_z_in.stnm); 
           fseek(nifl,0,SEEK_SET);
           fseek(eifl,0,SEEK_SET);
           still_reading_ndata=1;
           still_reading_edata=1;
        }
        else if (h_e_found == 0){
           fprintf(stdout,"    E not found %s %s\n",
                   h_z_in.netw,h_z_in.stnm); 
           fseek(nifl,0,SEEK_SET);
           fseek(eifl,0,SEEK_SET);
           still_reading_ndata=1;
           still_reading_edata=1;
        }
    } // big while
    fclose(zifl);
    fclose(eifl);
    fclose(nifl);
    fclose(ofl);
    exit(0);
} // main

int usage(){
    fprintf(stderr,"Usage:\n");
    fprintf(stderr,"\n");
    fprintf(stderr,"     xh_zneorder Z_xh N_xh E_xh out_XH \n");
    fprintf(stderr,"\n");
    fprintf(stderr,"Use xh_grepchan to split xh files.\n");
return(-1);
}



