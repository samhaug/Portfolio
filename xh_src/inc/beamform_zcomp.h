/* 
 * Structure to define saved time-dependent beamform on a single back-azimuth. To 
 * be stacked in-between a list of floats
 * */
 
#define SAMP 6200
#define NPCKS 20
typedef struct {
                float    t_start;       // starting time
                float    delta_t ;	/* 1/sampling_rate  */
                int      ndata ;	/* number of trace samples  */
                int      baz_min;
                int      baz_max;
                int      baz_inc;
                int      i_min;         // incidence angle min
                int      i_max;         // incidence angle max
                int      i_inc;
                float    p_min;         // slowness min
                float    p_max;         // slowness max
                int      filt[4];       // filter cutoffs
                float    gcarc;         // distance from source to array center (deg)
                float    sr_baz;        // back-azimuth from source to array along great circle
                float    sr_az;         // back-azimuth from source to array along great circle
                float    evdp;          // eq depth
                float    slat;          // array lat
                float    slon;          // array lon
                float    elat;          // event lat
                float    elon;          // event lon
                float    baz;           // back azimuth of this current beam
                float    inc;           // incidence angle of this current beam
                float    p;             // slowness of this current beam
                float    dat[SAMP];      // beam data
                float    flts[NPCKS];    // beam data
                float    ints[NPCKS];    // beam data
} beamform;



