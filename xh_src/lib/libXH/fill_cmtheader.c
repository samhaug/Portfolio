/* Reads event info for event CODE from CMT
   catalogue "$UTILS/CMT_catalog/cmt.bin"
   and puts it in the CMT header h
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <sys/file.h>
#include "ndk.h"

int fill_cmtheader(code,h)
char  code[];
cmthed *h;
{

cmthed h1;  /* temporary CMT header */
char  HVDCATALOG[130];
FILE *fp;

//fprintf(stderr,"entering fill_cmtheader() ....\n");
sprintf(HVDCATALOG,"%s/%s",getenv("UTILS"),"CMT_catalog/cmt.bin");
//fprintf(stdout,"in fill_cmtheader() HVDCATALOG= --%s--\n", HVDCATALOG);

if ((fp = fopen(HVDCATALOG, "r"))==NULL) {
    fprintf(stderr,"\n\nError opening %s\n",HVDCATALOG);
    return(0);
}
//fprintf(stdout,"in fill_cmtheader() b2\n");

if (fread(&h1,sizeof(h1),1,fp) != 1) {
    fprintf(stderr,"in fill_cmtheader a1\n");
   return(0);
}
//fprintf(stdout,"in fill_cmtheader() b3\n");
while (strncmp(h1.evtcd,code,7) != 0) {
   //fprintf(stdout,"--%s-- --%s--\n",h1.evtcd,code);
   if (fread(&h1,sizeof(h1),1,fp) != 1) {
     fprintf(stderr,"in fill_cmtheader a2\n");
     return(0);
   }
} 
*h = h1;
fclose(fp);
//fprintf(stdout,"exiting fill_cmtheader() ....\n");
return(1);
}
