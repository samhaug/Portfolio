/* 
   Extracts region for event CODE from CMT
   catalogue "$UTILS/CMT_catalog/cmt.bin"
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <sys/file.h>
#include "ndk.h"

int get_cmt_region(code,region)
char  code[8];
char  *region;
{

cmthed h;  /* temporary CMT header */
char  HVDCATALOG[130];
FILE *fp;

sprintf(HVDCATALOG,"%s/%s",getenv("UTILS"),"CMT_catalog/cmt.bin");

if ((fp = fopen(HVDCATALOG, "r"))==NULL) {
    fprintf(stderr,"\n\nError opening %s\n",HVDCATALOG);
    return(0);
}

fprintf(stdout,"in get_cmt_region()  code= %s\n", code);

if (fread(&h,sizeof(h),1,fp) != 1) {
   fprintf(stdout,"in get_cmt_region()  evtcd= %s\n", h.evtcd);
   return(0);
}
while (strncmp(h.evtcd,code,7) != 0) {
   if (fread(&h,sizeof(h),1,fp) != 1) 
      return(0);
} 
strcpy(region,h.region);
fclose(fp);
return(1);
}
