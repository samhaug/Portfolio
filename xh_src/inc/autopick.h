/* --- Global variables: -------------------*/

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

int             usefulrec = 1;
int             jlog=0, jrvw=0, one=1, null=0;

int             Wlength, Mshift, decim;

int             i10s=10, i20s=20, i30s=30, i50s=50, i40s=40, i70s=70, i80s= 80;
int             i100s=100, i150s=150, i250s=250, i400s=400;

int             Psample,pPsample,sPsample;
int             PPsample,pPPsample,sPPsample,PPPsample;
int             PKPsample,pPKPsample,sPKPsample;
int             PKIKPsample,pPKIKPsample,sPKIKPsample;
int             SKPsample,pSKPsample,sSKPsample;
int             PKSsample,pPKSsample,sPKSsample;
int             Ssample,pSsample,sSsample;
int             ScSsample,sScSsample,ScSScSsample,sScSScSsample;
int             SSsample,sSSsample,SSSsample,sSSSsample;
int             SKSsample,pSKSsample,sSKSsample;
int             SKKSsample,pSKKSsample,sSKKSsample;
int             SPsample,pSPsample,sSPsample,PSsample,pPSsample,sPSsample;

int             bandpass[4];

/*---- Directory with TRAVEL TIME TABLES  -------------------*/
char            stnam[10], chnam[6], netwk[6];

/* DATCODE is the first 7 characters of DATNAME (usualy CMT event code) */
char            datcode[8];


float           stlat,stlon,stelv,  evlat,evlon,evdep, gcarc,az,baz;
float           dt;
float           startsec=0.;

/*---- Noise related variables : ----------------------------*/
float           Z_noise, L_noise, T_noise;
float           Z_noise_window, L_noise_window, T_noise_window;
float           Z_noise_winMin, L_noise_winMin, T_noise_winMin;

float           envAmpRatio, envAmpRatio_Min;
float           SignalToNoise;

float           data[npts_dat],synt[npts_dat],env_data[npts_dat];
float           data_sp[npts_dat],synt_sp[npts_dat];
float           data_ps[npts_dat],synt_ps[npts_dat];
float           env_sp[npts_dat],env_ps[npts_dat];

/*----- Travel times: ---------------------------------------*/
float           Ptable[180],pPtable[180],sPtable[180];
float           PPtable[180],pPPtable[180],sPPtable[180],PPPtable[180];
float           PKPtable[180],pPKPtable[180],sPKPtable[180];
float           PKIKPtable[180],pPKIKPtable[180],sPKIKPtable[180];
float           SKPtable[180],pSKPtable[180],sSKPtable[180];
float           PKStable[180],pPKStable[180],sPKStable[180];
float           Stable[180],pStable[180],sStable[180];
float           ScStable[180],sScStable[180],ScSScStable[180],sScSScStable[180];
float           SStable[180],sSStable[180],SSStable[180],sSSStable[180];
float           SKStable[180],pSKStable[180],sSKStable[180];
float           SKKStable[180],pSKKStable[180],sSKKStable[180];
float           SPtable[180],pSPtable[180],sSPtable[180];
float           PStable[180],pPStable[180],sPStable[180];

float           Ptime,pPtime,sPtime;
float           PPtime,pPPtime,sPPtime,PPPtime;
float           PKPtime,pPKPtime,sPKPtime;
float           PKIKPtime,pPKIKPtime,sPKIKPtime;
float           SKPtime,pSKPtime,sSKPtime;
float           PKStime,pPKStime,sPKStime;
float           Stime,pStime,sStime;
float           ScStime,sScStime,ScSScStime,sScSScStime;
float           SStime,sSStime,SSStime,sSSStime;
float           SKStime,pSKStime,sSKStime;
float           SKKStime,pSKKStime,sSKKStime;
float           SPtime,pSPtime,sSPtime,PStime,pPStime,sPStime;

float           SP_amp, PS_amp;

float           PhaseSepTime;
