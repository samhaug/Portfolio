
/*
 * Input    - Gets input parameters from pick.par
 *
 */

#include <stdio.h>
#include <string.h>

void input()

{
/* --- External variables: -----------------*/
extern int             ENVELOPE; /* Take envelope  of the trace? */
extern int             RETREND;  /* Detrend           the trace? */
extern int             FILTER;   /* Apply a filter to the trace? */
extern char            dirTTable[];

extern float           bandpass[];
/*--------------------------------------------------------------------*/

FILE     *inf, *fopen();
char      ss[120];

if( (inf = fopen("pick.par","r")) == NULL ){
           printf(" INPUT: pick.par cannot be opened ...\n");
           exit(-1.);
        }

 fgets(ss,90,inf);
 sscanf(ss,"%s",dirTTable);
 fgets(ss,90,inf);
 sscanf(ss,"%d",&ENVELOPE);
 fgets(ss,90,inf);
 sscanf(ss,"%d",&RETREND);
 fgets(ss,90,inf);
 sscanf(ss,"%d %f %f %f %f",&FILTER,
            &bandpass[0], &bandpass[1], &bandpass[2], &bandpass[3]);

}
