#include <stdio.h>
#include "xhhead.h"

int main(){
    xhhed h;
    double j=1.234122;
    double k=1.2340;
    printf("%lu\n",sizeof(h));
    printf("%lu\n",sizeof(int));
    printf("%lu\n",sizeof(long int));
    printf("%lu\n",sizeof(float));
    printf("%lu\n",sizeof(double));
    printf("%lu\n",sizeof(long double));
    printf("%5.3f%6.3f\n", j,k);
    return(1);
}

