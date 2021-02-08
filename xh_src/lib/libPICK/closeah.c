/*
 * closeah   Closing an ah file
 *
 */

#include <stdio.h>
#include <strings.h>

int closeah( fileid, infile)
	FILE **fileid;
	char  *infile;
{

fclose(*fileid);
return (1);

}
