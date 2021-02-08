#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

/* Gives a quick statistical overview of an xh file */

float mean(int m, float a[]);
float median(int n, float x[]);
int mode(int n, float a[]);
float calculateSD(int n, float data[]);

main(int argc,char *argv[]){
    xhhed  	 h;
    int      icount=1;
    int      n,i,j=0, ierr;
    int      still_reading_data = 1;
    float    seism[XH_NPTS];
    float    delta,az,baz;
    float    uuu;
    char     infile[80];
    char     lat, lon;
    char     region[23];
    FILE     *inf, *fopen();
    float    ndata_array[10000];
    float    az_array[10000];
    float    delta_array[10000];
    float    ndata_mean=0;
    float    az_mean=0;
    float    delta_mean=0;
    int      usage();
    int      distaz();
    float    mean_az,mean_delta,mean_ndata;
    float    med_az,med_delta,med_ndata;
    float    mode_az,mode_delta,mode_ndata;
    float    std_az,std_delta,std_ndata;

    if ((inf = fopen(argv[1],"r")) == NULL) {
        ierr = usage(argv[1]);
        return(ierr);
    }
    i=0;
    while (still_reading_data){
        if (! xh_readhead(inf,&h)){
            still_reading_data = 0;
        } 
        else{	
            if (! xh_readdata(inf,h,seism)){
                still_reading_data = 0;
            }
            if (! xh_checkheader(h)){
            }
            if (! starttime(h,&uuu)){
                fprintf(stderr,"Error in starttime() ...\n");
            }
            if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz)){
            }
        }

        az_array[i] = az;
        delta_array[i] = delta;
        ndata_array[i] = h.ndata;
        az_mean+= az;
        delta_mean+= delta;
        ndata_mean+= h.ndata;
        i++;
    } // while

    az_mean *= 1./(float)i;
    delta_mean *= 1./(float)i;
    ndata_mean *= 1./(float)i;

    med_az = median(i,az_array);
    med_delta = median(i,delta_array);
    med_ndata = median(i,ndata_array);

    mode_az = mode(i,az_array);
    mode_delta = mode(i,delta_array);
    mode_ndata = mode(i,ndata_array);

    std_az = calculateSD(i,az_array);
    std_delta = calculateSD(i,delta_array);
    std_ndata = calculateSD(i,ndata_array);

    fprintf(stdout,"__________________________________________________________________________________________\n");
    fprintf(stdout,"                                                                                          \n");
    fprintf(stdout,"lat:%5.2f lon:%5.2f depth:%5.2f no.:%d\n",h.elat,h.elon,h.edep,i);
    fprintf(stdout,"__________________________________________________________________________________________\n");
    fprintf(stdout,"                                                                                          \n");
    fprintf(stdout,"%15s%15s%15s%15s%15s\n","","MEAN","MEDIAN","MODE","STD");
    fprintf(stdout,"__________________________________________________________________________________________\n");
    fprintf(stdout,"                                                                                          \n");
    fprintf(stdout,"%15s%15.2f%15.2f%15.2f%15.2f\n","AZIMUTH (deg) #",az_mean,med_az,mode_az,std_az);
    fprintf(stdout,"%15s%15.2f%15.2f%15.2f%15.2f\n","DELTA (deg)   #",delta_mean,med_delta,mode_delta,std_delta);
    fprintf(stdout,"%15s%15.2f%15.2f%15.2f%15.2f\n","No. DATA      #",ndata_mean,med_ndata,mode_ndata,std_ndata);
    fprintf(stdout,"__________________________________________________________________________________________\n");
    fprintf(stdout,"                                                                                          \n");

    fclose (inf);
    fflush(stdout);
    exit(0);
}

int usage(char *flnm){
    fprintf(stderr,"Cannot read XH file: %s\n",flnm);
    return(-1);
}

float median(int n, float x[]){
    int temp;
    int i, j;
    // the following two loops sort the array x in ascending order
    for(i=0; i<n-1; i++) {
        for(j=i+1; j<n; j++) {
            if(x[j] < x[i]) {
                // swap elements
                temp = x[i];
                x[i] = x[j];
                x[j] = temp;
            }
        }
    }

    if(n%2==0) {
        // if there is an even number of elements, return mean of the two elements in the middle
        return((x[n/2] + x[n/2 - 1]) / 2.0);
    } else {
        // else return the element in the middle
        return x[n/2];
    }
}

int mode(int n, float a[]) {
   int maxValue = 0, maxCount = 0, i, j;
   for (i = 0; i < n; ++i) {
      int count = 0;
      for (j = 0; j < n; ++j) {
         if (a[j] == a[i])
         ++count;
      }
      if (count > maxCount) {
         maxCount = count;
         maxValue = a[i];
      }
   }
   return maxValue;
}

float calculateSD(int n,float data[]){
    float sum = 0.0, mean, standardDeviation = 0.0;
    int i;
    for(i=0; i<n; ++i){
        sum += data[i];
    }
    mean = sum/n;
    for(i=0; i<n; ++i)
        standardDeviation += pow(data[i]-mean,2);
    return sqrt(standardDeviation/n);
}



