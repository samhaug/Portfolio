/*
#-- Format att.h; traveltime picks
#--
*/

#define ATT_VERSION		0.95
#define ATT_HDRSIZE		256

#define CHARLN          10

typedef struct {
	float   version;	/* format version #	  */
	int	nhdr;		/* # of bytes in header	  */

	float 	elat, elon, edep;		
	float 	slat, slon, selv;		
	float 	mlat, mlon;		
	float 	gcarc, az, baz;		
        float   snr, enr;
        float   t, t_err;
        float   a1, a2;
        float   dtcrust,dtellip,dtqcor,dtmod,dtreloc;

        int     Fit, WvShape;
        int     iSecondMax, iTraceMax, iUseful;

	char    evtcd[CHARLN];		/* HARVARD cmt code	*/
	char    phase[CHARLN];		/* Phase name	        */
	char    stnam[CHARLN];	        /* Station name	        */
	char    chnam[CHARLN];	        /* Channel name  	*/
	char    padding[100];	        /* Fill up header	*/

   } atthed;
