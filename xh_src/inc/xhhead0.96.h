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
#--
#-- Jeroen Ritsema
#-- Departement de Sismologie
#-- IPG Paris
*/

#define X_VERSION	0.96

#define X_HDRSIZE	1024
#define I_12345678	12345678
#define F_12345678	12345678.0

#define XH_NPTS		524288

#define NPCKS          15
#define NOCALPTS       30
#define CHARSIZE        6
#define COMSIZE        72
#define NCMT           14
#define NEXTRAS       222


typedef struct  {
		float        r;		/* real      part */
		float        i;		/* imaginary part */
		} complex;
typedef struct  {
		double       r;		/* real      part */
		double       i;		/* imaginary part */
		} dcomplex;

struct xhtime  {
                int          yr;	/* year         */
                int          mo;	/* month        */
                int         day;	/* day          */
                int          hr;	/* hour         */
                int          mn;	/* minute       */
                float       sec;	/* second       */
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

	struct  xhtime  ot;		/* ref/origin time (sec)	*/
	struct  xhtime  tstart;	/* seismogram start time (sec)	*/
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

        complex pole[NOCALPTS];	/* instrument poles	*/
        complex zero[NOCALPTS];	/* instrument zeroes	*/
        float   DS;
        float   A0;

	float   f12345678;		/* byte-order test flt	*/
	
	char    cmtcd[NCMT];		/* cmt code		*/
	char    evtcd[8];		/* My evt code		*/
	char    netw[CHARSIZE];		/* network names	*/
	char    stnm[CHARSIZE];		/* station name		*/
	char    chan[CHARSIZE];		/* seed channel name	*/
	char    rcomment[COMSIZE];	/* record info		*/
	char    wavf[CHARSIZE];		/* waveform type: 
					 unprocessed:	"raw"
					 displacement:	"dis"
					 velocity:	"vel"
					 acceleration:	"acc"  */

        float   tpcks[NPCKS];		/* phase picks		*/
/*--------------------------------------------------------------
		0=P,Pdiff
		1=pP
		2=sP
		3=PP
		4=PKPdf
		5=S,Sdiff
		6=sS
		7=SS
		8=ScS
		9=SKS
		10=SKKS
		11=SP
		12=SKP
		13=PKS
		14=pick
----------------------------------------------------------------*/

	char    padding[NEXTRAS];	/* padding the header up to X_HDRSIZE	*/
   } xhhed;

/* mark position for byte swapping */
#define X_NSWAP	50

/* to be added:
centroid time shift
*/
