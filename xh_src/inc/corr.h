/*
#-- Format CORR.h; output of crosscor (Nolet's code in src/crosscor_nolet)
#-- 
*/

#define CORR_HDR_VERSION	0.91
#define CORR_HDRSIZE		128
#define NCORR           14

typedef struct {
	float   version;	// format version #	

    float   period;
    float   effperiod;
    float   slat, slon, gcarc, azi;
    float   chi2, rel, rms;
    float   t_arr, t_prd, delay, sigma, avcor;

	int	    nhdr;		// #-of-bytes in header
    int     pband;
    int     icor;

    int     i_st;		// station number 
    char    evtcd[8];	// MY evt CODE
    char    stnm[8];	// station name

 	char    padding[36]; // Fill up header

   } corrhed;
