/*
 * openah   Opnening an ah file
 *
 */

#include <stdio.h>
#include <strings.h>

int openah(fileid, mode,infile)
	FILE **fileid;
	char  *infile;
	int *mode;
{

if (*mode == 1) {
  *fileid = fopen(infile,"r");
  rewind(*fileid);
} else if (*mode == 2) { 
  *fileid = fopen(infile,"a");
} else {
  printf("In OPENAH: Mode number not equal to 1 or 2\n");
  return (0);
}

return (1);

}
