#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/file.h>
#include "ndk.h"

int read_cmtheader(code, h)
char code[];
cmthed *h;
{
   char  HVDCATALOG[130];
   FILE *fp;

   sprintf(HVDCATALOG,"/geo/home/jritsema/Utils/CMT_catalog/cmt.bin");

   if ((fp = fopen(HVDCATALOG, "r"))==NULL) {
      fprintf(stderr,"\nError opening %s\n",HVDCATALOG);
      fprintf(stderr,"Exiting !! \n");
      return(0);
   }

   fread(h,sizeof(*h),1,fp);
   while (strncmp((*h).evtcd,code,7) != 0) {
      if ( fread(h,sizeof(*h),1,fp) == 0) 
        break;
   }
   fclose(fp);
   return(1);
}
