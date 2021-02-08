#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// sorting an array of integers in ascending order

int intcmp(const void *v1, const void *v2);

int intsort(array,n)

int array[];
int n;
{
int i, j;

qsort(array,n,sizeof(array[0]),intcmp);

return(1);

}

int intcmp(const void *v1, const void *v2)
 {
     return (*(int *)v1 - *(int *)v2);
 }
