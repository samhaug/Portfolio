/*
 * TTtimes     - Determines the travel times and 
                 sample locations.
 *
 */

#include <stdio.h>
#include <string.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

/* ------------------------- External variables ------------------------- */
                                                                                                                                                       
extern float           Ptable[180],pPtable[180],sPtable[180];
extern float           PPtable[180],pPPtable[180],sPPtable[180];
extern float           PPPtable[180];
extern float           PKPtable[180],pPKPtable[180],sPKPtable[180];
extern float           PKIKPtable[180],pPKIKPtable[180],sPKIKPtable[180];
extern float           SKPtable[180],pSKPtable[180],sSKPtable[180];
extern float           PKStable[180],pPKStable[180],sPKStable[180];
extern float           Stable[180],pStable[180],sStable[180];
extern float           ScStable[180],sScStable[180],ScSScStable[180],sScSScStable[180];
extern float           SStable[180],sSStable[180],SSStable[180],sSSStable[180];
extern float           SKStable[180],pSKStable[180],sSKStable[180];
extern float           SKKStable[180],pSKKStable[180],sSKKStable[180];
extern float           SPtable[180],pSPtable[180],sSPtable[180];
extern float           PStable[180],pPStable[180],sPStable[180];
                                                                                                                                                       
extern float           Ptime,pPtime,sPtime;
extern float           PPtime,pPPtime,sPPtime;
extern float           PPPtime;
extern float           PKPtime,pPKPtime,sPKPtime;
extern float           PKIKPtime,pPKIKPtime,sPKIKPtime;
extern float           SKPtime,pSKPtime,sSKPtime;
extern float           PKStime,pPKStime,sPKStime;
extern float           Stime,pStime,sStime;
extern float           ScStime,sScStime,ScSScStime,sScSScStime;
extern float           SStime,sSStime,SSStime,sSSStime;
extern float           SKStime,pSKStime,sSKStime;
extern float           SKKStime,pSKKStime,sSKKStime;
extern float           SPtime,pSPtime,sSPtime;
extern float           PStime,pPStime,sPStime;
                                                                                                                                                       
extern float           dt, startsec;
extern float           evdep, gcarc;

extern int             Psample,pPsample,sPsample;
extern int             PPsample,pPPsample,sPPsample;
extern int             PPPsample;
extern int             PKPsample,pPKPsample,sPKPsample;
extern int             PKIKPsample,pPKIKPsample,sPKIKPsample;
extern int             SKPsample,pSKPsample,sSKPsample;
extern int             PKSsample,pPKSsample,sPKSsample;
extern int             Ssample,pSsample,sSsample;
extern int             ScSsample,sScSsample,ScSScSsample,sScSScSsample;
extern int             SSsample,sSSsample,SSSsample,sSSSsample;
extern int             SKSsample,pSKSsample,sSKSsample;
extern int             SKKSsample,pSKKSsample,sSKKSsample;
extern int             SPsample,pSPsample,sSPsample;
extern int             PSsample,pPSsample,sPSsample;

void TTtimes(dirTTable,i_tables)

    char    dirTTable[30];
    int    *i_tables;
{

void TTtables(), extractTTime();

//fprintf(stdout," in TTtimes: evdep= %f gcarc= %f\n", evdep, gcarc);
//fprintf(stdout," in TTtimes: i_tables= %d\n", *i_tables);
//fprintf(stdout," in TTtimes: dirTTable= %s\n", dirTTable);
//fprintf(stdout," in TTtimes: startsec= %f\n", startsec);

    /* Read TRAVEL TIME TABLES: -----------------------------------------*/
    if (*i_tables == 0) {
      TTtables(dirTTable,evdep,Ptable,pPtable,sPtable,PPtable,pPPtable,sPPtable,PPPtable,
                               PKPtable,pPKPtable,sPKPtable,
                               PKIKPtable,pPKIKPtable,sPKIKPtable,
                               Stable,pStable,sStable,ScStable,sScStable,ScSScStable,sScSScStable,
                               SStable,sSStable,SSStable,sSSStable,SKStable,pSKStable,sSKStable,
                               SKKStable,pSKKStable,sSKKStable,SKPtable,pSKPtable,sSKPtable,
                               PKStable,pPKStable,sPKStable,
                               SPtable,pSPtable,sSPtable,PStable,pPStable,sPStable);
      *i_tables = 1;
    }

//fprintf(stdout," in TTtimes: reading from Ptable\n");
//fprintf(stdout," in TTtimes: Ptable[32]= %f\n", Ptable[32]);
    extractTTime(Ptable,       gcarc, &Ptime);
//fprintf(stdout," in TTtimes: done reading from Ptable: Ptime= %f\n", Ptime);
    extractTTime(pPtable,      gcarc, &pPtime);
    extractTTime(sPtable,      gcarc, &sPtime);
    extractTTime(PPtable,      gcarc, &PPtime);
    extractTTime(pPPtable,     gcarc, &pPPtime);
    extractTTime(sPPtable,     gcarc, &sPPtime);
    extractTTime(PPPtable,     gcarc, &PPPtime);
    extractTTime(PKPtable,     gcarc, &PKPtime);
    extractTTime(pPKPtable,    gcarc, &pPKPtime);
    extractTTime(sPKPtable,    gcarc, &sPKPtime);
    extractTTime(PKIKPtable,   gcarc, &PKIKPtime);
    extractTTime(pPKIKPtable,  gcarc, &pPKIKPtime);
    extractTTime(sPKIKPtable,  gcarc, &sPKIKPtime);
    extractTTime(SKPtable,     gcarc, &SKPtime);
    extractTTime(pSKPtable,    gcarc, &pSKPtime);
    extractTTime(sSKPtable,    gcarc, &sSKPtime);
    extractTTime(PKStable,     gcarc, &PKStime);
    extractTTime(pPKStable,    gcarc, &pPKStime);
    extractTTime(sPKStable,    gcarc, &sPKStime);
//fprintf(stdout," in TTtimes: reading from Stable\n");
//fprintf(stdout," in TTtimes: Stable[32]= %f\n", Stable[32]);
    extractTTime(Stable,       gcarc, &Stime);
//fprintf(stdout," in TTtimes: done reading from Stable: Stime= %f\n", Stime);
    extractTTime(pStable,      gcarc, &pStime);
    extractTTime(sStable,      gcarc, &sStime);
    extractTTime(ScStable,     gcarc, &ScStime);
    extractTTime(sScStable,    gcarc, &sScStime);
    extractTTime(ScSScStable,  gcarc, &ScSScStime);
    extractTTime(sScSScStable, gcarc, &sScSScStime);
    extractTTime(SStable,      gcarc, &SStime);
    extractTTime(sSStable,     gcarc, &sSStime);
    extractTTime(SSStable,     gcarc, &SSStime);
    extractTTime(sSSStable,    gcarc, &sSSStime);
    extractTTime(SKStable,     gcarc, &SKStime);
    extractTTime(pSKStable,    gcarc, &pSKStime);
    extractTTime(sSKStable,    gcarc, &sSKStime);
    extractTTime(SKKStable,    gcarc, &SKKStime);
    extractTTime(pSKKStable,   gcarc, &pSKKStime);
    extractTTime(sSKKStable,   gcarc, &sSKKStime);
    extractTTime(SPtable,      gcarc, &SPtime);
    extractTTime(pSPtable,     gcarc, &pSPtime);
    extractTTime(sSPtable,     gcarc, &sSPtime);
    extractTTime(PStable,      gcarc, &PStime);
    extractTTime(pPStable,     gcarc, &pPStime);
    extractTTime(sPStable,     gcarc, &sPStime);
    Psample       = (int) ((Ptime       - startsec)/dt);
    pPsample      = (int) ((pPtime      - startsec)/dt);
    sPsample      = (int) ((sPtime      - startsec)/dt);
    PPsample      = (int) ((PPtime      - startsec)/dt);
    pPPsample     = (int) ((pPPtime     - startsec)/dt);
    sPPsample     = (int) ((sPPtime     - startsec)/dt);
    PPPsample     = (int) ((PPPtime     - startsec)/dt);
    PKPsample     = (int) ((PKPtime     - startsec)/dt);
    pPKPsample    = (int) ((pPKPtime    - startsec)/dt);
    sPKPsample    = (int) ((sPKPtime    - startsec)/dt);
    PKIKPsample   = (int) ((PKIKPtime   - startsec)/dt);
    pPKIKPsample  = (int) ((pPKIKPtime  - startsec)/dt);
    sPKIKPsample  = (int) ((sPKIKPtime  - startsec)/dt);
    Ssample       = (int) ((Stime       - startsec)/dt);
    pSsample      = (int) ((pStime      - startsec)/dt);
    sSsample      = (int) ((sStime      - startsec)/dt);
    SSsample      = (int) ((SStime      - startsec)/dt);
    sSSsample     = (int) ((sSStime     - startsec)/dt);
    ScSsample     = (int) ((ScStime     - startsec)/dt);
    sScSsample    = (int) ((sScStime    - startsec)/dt);
    ScSScSsample  = (int) ((ScSScStime  - startsec)/dt);
    sScSScSsample = (int) ((sScSScStime - startsec)/dt);
    SSSsample     = (int) ((SSStime     - startsec)/dt);
    sSSSsample    = (int) ((sSSStime    - startsec)/dt);
    SKSsample     = (int) ((SKStime     - startsec)/dt);
    pSKSsample    = (int) ((pSKStime    - startsec)/dt);
    sSKSsample    = (int) ((sSKStime    - startsec)/dt);
    SKKSsample    = (int) ((SKKStime    - startsec)/dt);
    pSKKSsample   = (int) ((pSKKStime   - startsec)/dt);
    sSKKSsample   = (int) ((sSKKStime   - startsec)/dt);
    SKPsample     = (int) ((SKPtime     - startsec)/dt);
    pSKPsample    = (int) ((pSKPtime    - startsec)/dt);
    sSKPsample    = (int) ((sSKPtime    - startsec)/dt);
    PKSsample     = (int) ((PKStime     - startsec)/dt);
    pPKSsample    = (int) ((pPKStime    - startsec)/dt);
    sPKSsample    = (int) ((sPKStime    - startsec)/dt);
    SPsample      = (int) ((SPtime      - startsec)/dt);
    pSPsample     = (int) ((pSPtime     - startsec)/dt);
    sSPsample     = (int) ((sSPtime     - startsec)/dt);
    PSsample      = (int) ((PStime      - startsec)/dt);
    pPSsample     = (int) ((pPStime     - startsec)/dt);
    sPSsample     = (int) ((sPStime     - startsec)/dt);

return;
}
