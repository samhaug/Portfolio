#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* 
 Makes a Tukey window
 alpha=0 is rectangular
 alpha=1 is a Hann window
*/

int tukey();

void main(){
    double w[1000];
    float alpha=1.0;
    int i;
    int npts=1000;

    tukey(alpha,npts,w);
    for (i=0;i<npts;i++){
        printf("%f\n",w[i]);
    }
    //if(tukey(alpha,npts,w) == 1){
    //  for (i=0;i<npts;i++){
    //      printf("%f\n",w[i]);
    // }
    //}
}

int tukey(alpha, npts, w)
    float alpha;
    int npts;
    double *w;
{

    int n;
    for (n=0; n<npts; n++) { 
        if (n >=0 && n < alpha*(npts-1)/2.){
            w[n] = 0.5*(1+cos(M_PI*((2*n)/(alpha*(npts-1))-1)));

        }
        if (n >= alpha*(npts-1)/2. && n <= (npts-1)*(1-alpha/2.)){
            w[n] = 1. ;

        }
        if (n > (npts-1)*(1-alpha/2.) && n <= (npts-1)){
            w[n] = 0.5*(1+cos(M_PI*((2*n)/(alpha*(npts-1))-(2/alpha)+1)));

        }
    }

return(1);

}
