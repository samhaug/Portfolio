/*
#-- Format PDE.h; includes event characteristics
#-- summarized in the PDE catalog (ASCII).
#-- This catalog is produced by the NEIC.
#--
#-- Version 0.95 -- November 2003
#-- Jeroen Ritsema
#-- Departement de Sismologie
#-- IPG Paris
*/

#define PDE_HDR_VERSION		0.95
#define PDE_HDRSIZE		128

#define NPDE            12

typedef struct {
  float   version;	/* format version #	*/
  int	     nhdr;	/* # of bytes in header	*/

  float       lat;	/* latitude	*/
  float       lon;	/* longitude	*/
  float       dep;	/* depth	*/

  int          yr;	/* year         */
  int          mo;	/* month        */
  int         day;	/* day          */
  int          hr;	/* hour         */
  int          mn;	/* minute       */
  float       sec;	/* second       */

  float 	mb;	/* body wave mag	 */
  float 	ms;	/* surface wave mag      */
  float 	mw;     /* moment magnatide      */	
  float 	mu;     /* Unknown magnatide     */	
 
  char    pdecd[NPDE];	/* pde code	  */
  char    padding[54]; /* Fill up header */

  } pdehed;
