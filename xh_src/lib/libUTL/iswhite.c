#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/* returns the index with the first appearing blank */

int iswhite(str, j)
char str[];
int     *j;
{
	int  k=0;

        while (str[k] != ' ' && str[k] != '\0')
          k++;
        *j = k;

        return(1);
}
