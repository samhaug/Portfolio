/*
#-- Format XH; a revision of AH that is no longer supported.
#-- Many of the features of AH have been inherited,
#-- See ahhead.h to inspect the AH header.
#--
#-- XH is adapted from a the binary header
#-- used by Robert Clayton at Caltech.
#--
#-- Version 0.95 -- November 2003
#--
#-- Jeroen Ritsema
#-- Departement de Sismologie
#-- IPG Paris
*/

#define X_VERSION_95	0.95

#define X_HDRSIZE_95	1024
#define I_12345678_95	12345678
#define F_12345678_95	12345678.0

#define XH_NPTS_95		262144

/*
#define UNKNOWN	0
#define FLOAT   1
#define COMPLEX 2 
#define VECTOR  3
#define TENSOR  4
#define INT	5
#define DOUBLE  6
*/

#define NPCKS_95          15
#define NOCALPTS_95       30
#define CHARSIZE_95        6
#define COMSIZE_95        72
#define NCMT_95            8
#define NEXTRAS_95       246

#define TYPEMIN_95 1
#define TYPEMAX_95 6

/*
typedef struct  {
		float        r;	
		float        i;
		} complex;
typedef struct  {
		double       r;
		double       i;
		} dcomplex;

struct xhtime  {
                int          yr;
                int          mo;
                int         day;
                int          hr;
                int          mn;
                float       sec;
                };
*/

typedef struct {
	float   version_95;	/* format version #		*/
	int	nhdr_95;		/* # of bytes in header		*/
	int	i12345678_95;	/* byte-order test int		*/

	float 	elat_95;		/* source latitude (degs)	*/
	float 	elon_95;		/* source longitude (degs)	*/
	float 	edep_95;		/* source depth			*/
	float 	magn_95;		/* source size (mag for eqs)	*/
	float 	slat_95;		/* receiver latitude (degs)	*/
	float 	slon_95;		/* receiver longitude (degs)	*/
	float 	elev_95;		/* receiver elevation		*/
        // Typically:
        // Z: azim=0. inc=-90  N: azim=0 inc=0  E: azim=90 inc=0.
	float 	azim_95;		/* sensor alignment from north	*/
	float 	incl_95;		/* sensor inclination from hori	*/

	struct  xhtime  ot_95;		/* ref/origin time (sec)	*/
	struct  xhtime  tstart_95;	/* seismogram start time (sec)	*/
        int     ndata_95;		/* number of samples		*/
	float   delta_95;		/* sample rate: sample/sec	*/
	float   tshift_95;		/* static time shift (sec)	*/
	float   maxamp_95;		/* maximum amplitude		*/
	int	qual_95;		/* waveform quality		*/
        int     chid_95;		/* channel id    	 
				0= NOT A SEISMOGRAM
				1= vertical
				2= north-south
				3= east-west
				4= radial
				5= transverse                    */

        complex pole_95[NOCALPTS_95];	/* instrument poles	*/
        complex zero_95[NOCALPTS_95];	/* instrument zeroes	*/
        float   DS_95;
        float   A0_95;

	float   f12345678_95;		/* byte-order test flt	*/
	
	char    cmtcd_95[NCMT_95];		/* cmt code		*/
	char    netw_95[CHARSIZE_95];		/* network name		*/
	char    stnm_95[CHARSIZE_95];		/* station name		*/
	char    chan_95[CHARSIZE_95];		/* seed channel name	*/
	char    rcomment_95[COMSIZE_95];	/* record info		*/
	char    wavf_95[CHARSIZE_95];		/* waveform type: 
					 unprocessed:	"raw",
					 displacement:	"dis",
					 velocity:	"vel",
					 acceleration:	"acc".  */

        float   tpcks_95[NPCKS_95];		/* phase picks		*/
/*--------------------------------------------------------------
		0=P,Pdiff
		1=pP
		2=sP
		3=PP
		4=PKPdf
		5=S,Sdiff
		6=sS
		7=ScS
		8=SKS
		9=SKKS
		10=SP
		11=PSS
		12=SKP
		13=PKS
		14=pick
----------------------------------------------------------------*/

	char    padding_95[NEXTRAS_95];	/* padding the header up to X_HDRSIZE	*/
   } xhhed95;

/* mark position for byte swapping */
/*
#define X_NSWAP	50
*/
