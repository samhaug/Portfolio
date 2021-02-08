#include <stdio.h>
#include <stdlib.h>
#include <math.h>


/* Recognize leap years */
int isleap(yr)
int     yr;
{
        int     l;

        if (yr < 0) yr++;
        l = (yr%4 == 0);
        l = l && (yr%100 != 0 || yr%400 == 0);
        return l;
}

