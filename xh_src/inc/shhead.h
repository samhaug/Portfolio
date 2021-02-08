/*
#-- Format SH; a shorter version of XH
#-- with only redimentray entries
#--
*/

#define X_VERSION	0.96

#define X_HDRSIZE	1024
#define I_12345678	12345678
#define F_12345678	12345678.0

#define NPTS		262144

#define ARLEN          100
#define CHRSIZE        6
#define CMSIZE        72
#define PADS        82

typedef struct {
	float   version;	/* format version #		*/
	int	nhdr;		/* # of bytes in header		*/
	int	i12345678;	/* byte-order test int		*/

	float 	lat;		/* source latitude (degs)	*/
	float 	lon;		/* source longitude (degs)	*/

        int     ndata;		/* number of samples		*/
	float   delta;		/* sample rate: sample/sec	*/
	int	qual;		/* waveform quality		*/

	float   f12345678;		/* byte-order test flt	*/
	
	char    code[8];		/* My evt code		*/
	char    netw[CHRSIZE];		/* network names	*/
	char    stnm[CHRSIZE];		/* station name		*/
	char    chan[CHRSIZE];		/* seed channel name	*/
	char    rcomment[CMSIZE];	/* record info		*/
	char    wavf[CHRSIZE];		/* waveform type: 
					 unprocessed:	"raw"
					 displacement:	"dis"
					 velocity:	"vel"
					 acceleration:	"acc"  */

        float   ipcks[ARLEN];		/* integer array	*/
        float   fpcks[ARLEN];		/* float array		*/

	char    padding[PADS];	/* padding the header up to X_HDRSIZE	*/
   } shhed;

