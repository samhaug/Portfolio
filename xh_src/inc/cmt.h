/*
#-- Format CMT.h; includes source characteristics
#-- summarized in 4 lines of ASCII for each event of the CMT catalog.
#-- This catalog is produced by HARVARD and is called "allorder.dek".
#-- See ftp://ftp.saf.harvard.edu
#-- The complete "dek" file, which includes the 
#-- MONTHLY solutions, is called "new.dek".
#--
#-- Version 0.95 -- November 2003
#-- Jeroen Ritsema
#-- Departement de Sismologie
#-- IPG Paris
*/

#define CMT_HDR_VERSION		0.95
#define CMT_HDRSIZE		512

#define CHARREGN       54
#define NCMT            8

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

	float 	Mrr;		/* Moment tensor */
	float 	Mrr_err;	
	float 	Mss;		
	float 	Mss_err;	
	float 	Mee;		
	float 	Mee_err;	
	float 	Mrs;		
	float 	Mrs_err;	
	float 	Mre;		
	float 	Mre_err;	
	float 	Mse;		
	float 	Mse_err;	

	float 	centroid_time;
	float 	centroid_time_err;		
	float 	centroid_lat;		
	float 	centroid_lat_err;		
	float 	centroid_lon;		
	float 	centroid_lon_err;		
	float 	centroid_dep;		
	float 	centroid_dep_err;		
	float 	dur;		
	float 	M0;		
	int 	expo;		

	float 	eigval1;		
	float 	eigval2;		
	float 	eigval3;		
	float 	plg1;		
	float 	plg2;		
	float 	plg3;		
	float 	str1;		
	float 	str2;		
	float 	str3;		
	float 	strike1;		
	float 	dip1;		
	float 	rake1;		
	float 	strike2;		
	float 	dip2;		
	float 	rake2;		

	struct  loctime  cat;	/* Location and time accord to CATALOG	*/

	char    cmtcd[NCMT];		/* HARVARD cmt code	*/
	char    region[CHARREGN];	/* source region	*/
	char    catalog[4];	        /* Fill up header	*/
	char    padding[216];	        /* Fill up header	*/

   } cmthed;
