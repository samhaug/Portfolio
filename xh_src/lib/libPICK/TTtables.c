/*
 * TTtables    - Reads in the travel time tables.
                 Interpolates between  depth...
   Travel times tables have 180 entries.
   Starting at 1 degrees; Ending at 180 degrees.
 *
 */

#include <stdio.h>
#include <string.h>

void TTtables(TTdir,depth, Ptime,pPtime,sPtime,PPtime,pPPtime,sPPtime,PPPtime,
                           PKPtime,pPKPtime,sPKPtime,
                           PKIKPtime,pPKIKPtime,sPKIKPtime,
                           Stime,pStime,sStime,ScStime,sScStime,ScSScStime,sScSScStime,
                           SStime,sSStime,SSStime,sSSStime,SKStime,pSKStime,sSKStime,
                           SKKStime,pSKKStime,sSKKStime,SKPtime,pSKPtime,sSKPtime,
                           PKStime,pPKStime,sPKStime,
                           SPtime,pSPtime,sSPtime,PStime,pPStime,sPStime)

   char    TTdir[];
   float   depth;
   float  *Ptime,*pPtime,*sPtime,*PPtime,*pPPtime,*sPPtime,*PPPtime;
   float  *PKPtime,*pPKPtime,*sPKPtime;
   float  *PKIKPtime,*pPKIKPtime,*sPKIKPtime;
   float  *Stime,*sStime,*pStime,*ScStime,*sScStime,*ScSScStime,*sScSScStime;
   float  *SStime,*sSStime,*SSStime,*sSSStime,*SKStime,*pSKStime,*sSKStime;
   float  *SKKStime,*pSKKStime,*sSKKStime,*SKPtime,*pSKPtime,*sSKPtime;
   float  *PKStime,*pPKStime,*sPKStime;
   float  *SPtime,*pSPtime,*sSPtime,*PStime,*pPStime,*sPStime;
{

int   i;
int dep1, dep2;

char phase[10];

void finddeps();
void openTable();
/*---------------------------------------------------------------------*/

/* Get dep1 and dep2 between which DEPTH lies ... */
finddeps(depth, &dep1, &dep2);

fprintf(stdout,"in TTtables: TTdir= %s\n", TTdir);
fprintf(stdout,"depth= %f   dep1= %d  dep2= %d:\n", depth,dep1,dep2);

/* -- Open travel time tables: */
strcpy(phase,"P");       openTable(TTdir, depth, dep1, dep2, phase,       Ptime);
strcpy(phase,"pP");      openTable(TTdir, depth, dep1, dep2, phase,      pPtime);
strcpy(phase,"sP");      openTable(TTdir, depth, dep1, dep2, phase,      sPtime);
strcpy(phase,"PP");      openTable(TTdir, depth, dep1, dep2, phase,      PPtime);
strcpy(phase,"pPP");     openTable(TTdir, depth, dep1, dep2, phase,     pPPtime);
strcpy(phase,"sPP");     openTable(TTdir, depth, dep1, dep2, phase,     sPPtime);
strcpy(phase,"PPP");     openTable(TTdir, depth, dep1, dep2, phase,     PPPtime);
strcpy(phase,"PKP");     openTable(TTdir, depth, dep1, dep2, phase,     PKPtime);
strcpy(phase,"pPKP");    openTable(TTdir, depth, dep1, dep2, phase,    pPKPtime);
strcpy(phase,"sPKP");    openTable(TTdir, depth, dep1, dep2, phase,    sPKPtime);
strcpy(phase,"PKIKP");   openTable(TTdir, depth, dep1, dep2, phase,   PKIKPtime);
strcpy(phase,"pPKIKP");  openTable(TTdir, depth, dep1, dep2, phase,  pPKIKPtime);
strcpy(phase,"sPKIKP");  openTable(TTdir, depth, dep1, dep2, phase,  sPKIKPtime);
strcpy(phase,"S");       openTable(TTdir, depth, dep1, dep2, phase,       Stime);
strcpy(phase,"pS");      openTable(TTdir, depth, dep1, dep2, phase,      pStime);
strcpy(phase,"sS");      openTable(TTdir, depth, dep1, dep2, phase,      sStime);
strcpy(phase,"ScS");     openTable(TTdir, depth, dep1, dep2, phase,     ScStime);
strcpy(phase,"sScS");    openTable(TTdir, depth, dep1, dep2, phase,    sScStime);
strcpy(phase,"ScSScS");  openTable(TTdir, depth, dep1, dep2, phase,  ScSScStime);
strcpy(phase,"sScSScS"); openTable(TTdir, depth, dep1, dep2, phase, sScSScStime);
strcpy(phase,"SS");      openTable(TTdir, depth, dep1, dep2, phase,      SStime);
strcpy(phase,"sSS");     openTable(TTdir, depth, dep1, dep2, phase,     sSStime);
strcpy(phase,"SSS");     openTable(TTdir, depth, dep1, dep2, phase,     SSStime);
strcpy(phase,"sSSS");    openTable(TTdir, depth, dep1, dep2, phase,    sSSStime);
strcpy(phase,"SKS");     openTable(TTdir, depth, dep1, dep2, phase,     SKStime);
strcpy(phase,"pSKS");    openTable(TTdir, depth, dep1, dep2, phase,    pSKStime);
strcpy(phase,"sSKS");    openTable(TTdir, depth, dep1, dep2, phase,    sSKStime);
strcpy(phase,"SKKS");    openTable(TTdir, depth, dep1, dep2, phase,    SKKStime);
strcpy(phase,"pSKKS");   openTable(TTdir, depth, dep1, dep2, phase,   pSKKStime);
strcpy(phase,"sSKKS");   openTable(TTdir, depth, dep1, dep2, phase,   sSKKStime);
strcpy(phase,"SKP");     openTable(TTdir, depth, dep1, dep2, phase,     SKPtime);
strcpy(phase,"pSKP");    openTable(TTdir, depth, dep1, dep2, phase,    pSKPtime);
strcpy(phase,"sSKP");    openTable(TTdir, depth, dep1, dep2, phase,    sSKPtime);
strcpy(phase,"PKS");     openTable(TTdir, depth, dep1, dep2, phase,     PKStime);
strcpy(phase,"pPKS");    openTable(TTdir, depth, dep1, dep2, phase,    pPKStime);
strcpy(phase,"sPKS");    openTable(TTdir, depth, dep1, dep2, phase,    sPKStime);
strcpy(phase,"SP");      openTable(TTdir, depth, dep1, dep2, phase,      SPtime);
strcpy(phase,"pSP");     openTable(TTdir, depth, dep1, dep2, phase,     pSPtime);
strcpy(phase,"sSP");     openTable(TTdir, depth, dep1, dep2, phase,     sSPtime);
strcpy(phase,"PS");      openTable(TTdir, depth, dep1, dep2, phase,      PStime);
strcpy(phase,"pPS");     openTable(TTdir, depth, dep1, dep2, phase,     pPStime);
strcpy(phase,"sPS");     openTable(TTdir, depth, dep1, dep2, phase,     sPStime);

return;
}


/*--------------------------------------------------*/
void openTable(TTdir,depth,dep1,dep2,phase,TTime)
float depth;
int dep1;
int dep2;
float *TTime;
char *phase;
char TTdir[];
{

FILE *fopen(), *fp1, *fp2;

char  TTable[20];
char  file1[150], file2[150];
char   ss[120];

int   i=0;


float T1time[180], T2time[180];
float fac, dT;

fac = (depth - dep1*1.0)/25.;

fprintf(stdout,"in openTable: TTdir= -%s-\n", TTdir);
fprintf(stdout,"in openTable: phase= -%s-\n", phase);

if (strlen(phase) == 1) {
  /* -- Open travel time table */
  if        (strncmp(phase,"P",1) == 0) {
    sprintf(file1,"%s/tt.P.%d",  TTdir,dep1);
    sprintf(file2,"%s/tt.P.%d",  TTdir,dep2);
  }
fprintf(stdout,"in openTable: Ptable dep1= -%s-\n", file1);
fprintf(stdout,"in openTable: Ptable dep2= -%s-\n", file2);
  if (strncmp(phase,"S",1) == 0) {
    sprintf(file1,"%s/tt.S.%d",  TTdir,dep1);
    sprintf(file2,"%s/tt.S.%d",  TTdir,dep2);
  }
}

if (strlen(phase) == 2) {
  if (strncmp(phase,"pP",2) == 0) {
    sprintf(file1,"%s/tt.pP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sP",2) == 0) {
    sprintf(file1,"%s/tt.sP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"pS",2) == 0) {
    sprintf(file1,"%s/tt.pS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sS",2) == 0) {
    sprintf(file1,"%s/tt.sS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"PP",2) == 0) {
    sprintf(file1,"%s/tt.PP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.PP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"SS",2) == 0) {
    sprintf(file1,"%s/tt.SS.%d",  TTdir,dep1);
    sprintf(file2,"%s/tt.SS.%d",  TTdir,dep2);
  }
  if (strncmp(phase,"SP",2) == 0) {
    sprintf(file1,"%s/tt.SP.%d",  TTdir,dep1);
    sprintf(file2,"%s/tt.SP.%d",  TTdir,dep2);
  }
  if (strncmp(phase,"PS",2) == 0) {
    sprintf(file1,"%s/tt.PS.%d",  TTdir,dep1);
    sprintf(file2,"%s/tt.PS.%d",  TTdir,dep2);
  }
}
  
if (strlen(phase) == 3) {
  if (strncmp(phase,"pPP",3) == 0) {
    sprintf(file1,"%s/tt.pPP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pPP.%d", TTdir,dep2);
  }  
  if (strncmp(phase,"sPP",3) == 0) {
    sprintf(file1,"%s/tt.sPP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sPP.%d", TTdir,dep2);
  }  
  if (strncmp(phase,"PPP",3) == 0) {
    sprintf(file1,"%s/tt.PPP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.PPP.%d", TTdir,dep2);
  }  
  if (strncmp(phase,"PKP",3) == 0) {
    sprintf(file1,"%s/tt.PKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.PKP.%d", TTdir,dep2);
  }  
  if (strncmp(phase,"ScS",3) == 0) {
    sprintf(file1,"%s/tt.ScS.%d",  TTdir,dep1);
    sprintf(file2,"%s/tt.ScS.%d",  TTdir,dep2);
  }
  if (strncmp(phase,"sSS",3) == 0) {
    sprintf(file1,"%s/tt.sSS.%d",  TTdir,dep1);
    sprintf(file2,"%s/tt.sSS.%d",  TTdir,dep2);
  }
  if (strncmp(phase,"SSS",3) == 0) {
    sprintf(file1,"%s/tt.SSS.%d",  TTdir,dep1);
    sprintf(file2,"%s/tt.SSS.%d",  TTdir,dep2);
  }
  if (strncmp(phase,"SKS",3) == 0) {
    sprintf(file1,"%s/tt.SKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.SKS.%d", TTdir,dep2);
  }  
  if (strncmp(phase,"SKP",3) == 0) {
    sprintf(file1,"%s/tt.SKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.SKP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"PKS",3) == 0) {
    sprintf(file1,"%s/tt.PKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.PKS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"pSP",3) == 0) {
    sprintf(file1,"%s/tt.pSP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pSP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sSP",3) == 0) {
    sprintf(file1,"%s/tt.sSP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sSP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"pPS",3) == 0) {
    sprintf(file1,"%s/tt.pPS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pPS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sPS",3) == 0) {
    sprintf(file1,"%s/tt.sPS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sPS.%d", TTdir,dep2);
  }
}

if (strlen(phase) == 4) {
  if (strncmp(phase,"pPKP",4) == 0) {
    sprintf(file1,"%s/tt.pPKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pPKP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sPKP",4) == 0) {
    sprintf(file1,"%s/tt.sPKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sPKP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sSSS",4) == 0) {
    sprintf(file1,"%s/tt.sSSS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sSSS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sScS",4) == 0) {
    sprintf(file1,"%s/tt.sScS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sScS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"pSKS",4) == 0) {
    sprintf(file1,"%s/tt.pSKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pSKS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sSKS",4) == 0) {
    sprintf(file1,"%s/tt.sSKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sSKS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"pSKP",4) == 0) {
    sprintf(file1,"%s/tt.pSKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pSKP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sSKP",4) == 0) {
    sprintf(file1,"%s/tt.sSKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sSKP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"pPKS",4) == 0) {
    sprintf(file1,"%s/tt.pPKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pPKS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sPKS",4) == 0) {
    sprintf(file1,"%s/tt.sPKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sPKS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"SKKS",4) == 0) {
    sprintf(file1,"%s/tt.SKKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.SKKS.%d", TTdir,dep2);
  }
}
  
if (strlen(phase) == 5) {
  if (strncmp(phase,"PKIKP",5) == 0) {
    sprintf(file1,"%s/tt.PKIKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.PKIKP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"pSKKS",5) == 0) {
    sprintf(file1,"%s/tt.pSKKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pSKKS.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sSKKS",5) == 0) {
    sprintf(file1,"%s/tt.sSKKS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sSKKS.%d", TTdir,dep2);
  }
}
  
if (strlen(phase) == 6) {
  if (strncmp(phase,"pPKIKP",6) == 0) {
    sprintf(file1,"%s/tt.pPKIKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.pPKIKP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"sPKIKP",6) == 0) {
    sprintf(file1,"%s/tt.sPKIKP.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sPKIKP.%d", TTdir,dep2);
  }
  if (strncmp(phase,"ScSScS",6) == 0) {
    sprintf(file1,"%s/tt.ScSScS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.ScSScS.%d", TTdir,dep2);
  }
}

if (strlen(phase) == 7) {
  if (strncmp(phase,"sScSScS",7) == 0) {
    sprintf(file1,"%s/tt.sScSScS.%d", TTdir,dep1);
    sprintf(file2,"%s/tt.sScSScS.%d", TTdir,dep2);
  }
}

  /*
  fprintf(stdout,"in openTable: file1 = %s\n", file1);
  fprintf(stdout,"in openTable: file2 = %s\n", file2);
  */

if ( (fp1 = fopen(file1,"r")) == NULL) 
    fprintf(stderr,"Error in opening %s\n", file1);
rewind(fp1);
if ( (fp2 = fopen(file2,"r")) == NULL)
    fprintf(stderr,"Error in opening %s\n", file2);
rewind(fp2);

for(i=0; i<180; ++i){
   fgets(ss,120,fp1); sscanf(ss,"%*f %*f %*s %f", &T1time[i]);
   fgets(ss,120,fp2); sscanf(ss,"%*f %*f %*s %f", &T2time[i]);
   dT = T2time[i] - T1time[i];
   if (T1time[i] < 0. || T2time[i] < 0.) {
      TTime[i] = -999.;
   } else {   
      TTime[i] = T1time[i] + fac*dT;
   }
}

fclose(fp1);
fclose(fp2);
}

