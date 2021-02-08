/*
#-- Format XH; a revision of AH that is no longer supported.
#-- Many of the features of AH have been inherited,
#-- See ahhead.h to inspect the AH header.
#--
#-- XH is adapted from the binary header
#-- used by Robert Clayton at Caltech.
#--
#-- Version 0.95 -- November 2003
#-- Version 0.96 -- May 2006
#-- Version 0.97 -- June 2008
#--
#-- Jeroen Ritsema
#-- Departement de Sismologie
#-- IPG Paris
*/

/* THIS VERSION IS USED IN 97to98 conversion of XH data */

/* ----------------------------------
 Additions and modification from 0.96
 ------------------------------------

(-) CHARSIZE=8 in version 0.97
(-) NPCKS=20 in version 0.97
(-) h.locc is the location code for the station
    h.locc = 9 for ""
    h.locc = 0 for "00"
    h.locc = 1 for "10"
    h.locc = 2 for "20"
    h.locc = 3 for "30"
    h.locc = 4 for "40"
    h.locc = 5 for "50"
(-) h.flt[NPCKS]
(-) h.intg[NPCKS]
*/

#define X_VERSION97   0.97

#define X_HDRSIZE   1024
#define I_12345678  12345678
#define F_12345678  12345678.0

#define XH_NPTS97	524288

#define NPCKS          20
#define NOCALPTS       30
#define CHARSIZE        8
#define COMMENTSIZE    72
#define NCMT           14
#define NPADS97          29


typedef struct  {
		float        r;	
		float        i;	
		} complx97;

struct xhtime97   {
                int          yr;
                int          mo;
                int         day;
                int          hr;
                int          mn;
                float       sec;
                };

typedef struct {
	float   version;	/* format version #		*/
	int	nhdr;		/* # of bytes in header		*/
	int	i12345678;	/* byte-order test int		*/

	float 	elat;		/* source latitude (degs)	*/
	float 	elon;		/* source longitude (degs)	*/
	float 	edep;		/* source depth			*/
	float 	Mb;		/* Mb				*/
	float 	Ms;		/* Mb				*/
	float 	Mw;		/* Mb				*/
	float 	slat;		/* receiver latitude (degs)	*/
	float 	slon;		/* receiver longitude (degs)	*/
	float 	elev;		/* receiver elevation		*/
        // Typically:
        // Z: azim=0. inc=-90  N: azim=0 inc=0  E: azim=90 inc=0.
	float 	azim;		/* sensor alignment from north	*/
	float 	incl;		/* sensor inclination from hori	*/

	struct  xhtime97  ot;		/* ref/origin time (sec)	*/
	struct  xhtime97  tstart;	/* seismogram start time (sec)	*/
        int     ndata;		/* number of samples		*/
	float   delta;		/* sample rate: sample/sec	*/
	float   tshift;		/* static time shift (sec)	*/
	float   maxamp;		/* maximum amplitude		*/
	int	qual;		/* waveform quality		*/
        int     chid;		/* channel id    	 
				0= NOT A SEISMOGRAM
				1= vertical
				2= north-south
				3= east-west
				4= radial
				5= transverse                    */
        int     locc;		/* location code
				9 =  ""
				0 =  "00"
				1 =  "10"
				2 =  "20"
				3 =  "30"
				4 =  "40"
				5 =  "50"			*/

        complx97 pole[NOCALPTS];	/* instrument poles	*/
        complx97 zero[NOCALPTS];	/* instrument zeroes	*/
        float   DS;
        float   A0;

	float   f12345678;		/* byte-order test flt	*/
	
	char    cmtcd[NCMT];		/* cmt code		*/
	char    evtcd[CHARSIZE];	/* My evt code		*/
	char    netw[CHARSIZE];		/* network names	*/
	char    stnm[CHARSIZE];		/* station name		*/
	char    chan[CHARSIZE];		/* seed channel name	*/
	char    rcomment[COMMENTSIZE];	/* record info		*/
	char    wavf[CHARSIZE];		/* waveform type: 
					 unprocessed:	"raw"
					 displacement:	"dis"
					 velocity:	"vel"
					 acceleration:	"acc"  */

    float   tpcks[NPCKS];		/* phase picks		*/
	float   flt[NPCKS];		/* floats		*/
	int     intg[NPCKS];		/* integers		*/

	char    padding[NPADS97];		/* padding the header up to X_HDRSIZE	*/
   } xhhed97;
