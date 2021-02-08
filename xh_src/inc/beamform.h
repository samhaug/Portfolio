/* 
 * Structure to define saved time-dependent beamform
 * */
 
typedef struct {
                float    delta ;	/* 1/sampling_rate  */
                float    a_lat ;	/* array centroid latitude  */
                float    a_lon ;	/* array centroid longitude  */
                float    e_lat ;	/* event longitude  */
                float    e_lon ;	/* event longitude  */
                float    e_dep ;	/* event depth  */
                int      ndata ;	/* number of trace samples  */
                int      baz_min ;	/* baz_min  */
                int      baz_max ;	/* baz_max  */
                int      baz_inc ;	/* baz increment*/
                int      i_min ;	/* i_min  */
                int      i_max ;	/* i_max  */
                int      i_inc ;	/* incidence angle increment  */
                float    dat1[361][41][4000]; /* baz,inc,time dependent data  */
                float    dat2[361][41][4000]; /* baz,inc,time dependent data  */
                float    dat3[361][41][4000]; /* baz,inc,time dependent data  */
             } beamform;



