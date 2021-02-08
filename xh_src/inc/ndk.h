/*
#-- Format NDK.h; includes source characteristics
#-- summarized in 5 lines of ASCII for each event of the CMT catalog.
#-- This catalog is produced by HARVARD and is called "allorder.ndk".
#-- See ftp://ftp.saf.harvard.edu
#-- 
#-- The NDK file follows the NEW CMT format used by Harvard 
#--
#-- Version 0.95 -- November 2003
#-- Jeroen Ritsema
#-- Departement de Sismologie
#-- IPG Paris
#--
#-- Modifed April 2006
*/

#define CMT_HDR_VERSION		0.95
#define CMT_HDRSIZE		512

#define CHARREGN       54
#define NCMT           14

struct loctime {
         float       lat;	/* latitude	*/
         float       lon;	/* longitude	*/
         float       dep;	/* depth	*/

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

	float 	mb;		/* body wave mag	  */
	int     period_b;       /* body wave period       */
	int     num_stat_b;     /* # stat for BW analysis */
	int     num_rec_b;      /* # rec for BW analysis */
	float 	ms;		/* surface wave mag	  */
	int     period_s;       /* surface wave period    */
	int     num_stat_s;     /* # stat for SW analysis */
	int     num_rec_s;      /* # rec for SW analysis */
	int     period_m;       /* mantle wave period    */
	int     num_stat_m;     /* # stat for MW analysis */
	int     num_rec_m;      /* # rec for MW analysis */

	int     mttype;	        /* Momment tensor type */

	float 	Mrr;		/* Moment tensor */
	float 	Mrr_err;	
	float 	Mtt;		
	float 	Mtt_err;	
	float 	Mpp;		
	float 	Mpp_err;	
	float 	Mrt;		
	float 	Mrt_err;	
	float 	Mrp;		
	float 	Mrp_err;	
	float 	Mtp;		
	float 	Mtp_err;	

	float 	centroid_time;
	float 	centroid_time_err;		
	float 	centroid_lat;		
	float 	centroid_lat_err;		
	float 	centroid_lon;		
	float 	centroid_lon_err;		
	float 	centroid_dep;		
	float 	centroid_dep_err;		
	float 	halfdur;		
	float 	M0;		
	int 	expo;		

	float 	eigval1;		
	float 	eigval2;		
	float 	eigval3;		
	int 	plg1;		
	int 	plg2;		
	int 	plg3;		
	int 	str1;		
	int 	str2;		
	int 	str3;		
	int 	strike1;		
	int 	dip1;		
	int 	rake1;		
	int 	strike2;		
	int 	dip2;		
	int 	rake2;		

	struct  loctime  cat;	/* Location and time accord to CATALOG	*/

	char    cmtcd[NCMT];		/* cmt code		*/
        char    evtcd[8];               /* MY evt CODE          */
	char    cmtcddata;		/* cmt code Data-type (B,S,M,C)	*/
	char    region[CHARREGN];	/* source region	*/
	char    hypocat[5];	        /* Hypocenter catalog	*/
	char 	stftype[6];		/* Type of STF (TRIHD, BOXHD) */	
	char    depcnstr[5];	        /* Type of depth constraint (FREE,FIX) */
	char    timestamp[16];	        /* Hypocenter catalog	*/
	char    padding[165];	        /* Fill up header	*/

   } cmthed;
