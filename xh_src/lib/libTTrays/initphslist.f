      subroutine initphslist

      include 'phslist.h'

      data chan/'LHZ','LHT','LHL','LHN','LHE','BHZ','BHT','BHL','BHN','BHE',
     1          'EHZ','EHT','EHL','EHN','EHE','VHZ','VHT','VHL','VHN','VHE',
     1          'LPZ','LPT','LPL','LPN','LPE','LHR'/

      parameter(NRP=16)
      character*10 pphs(NRP)
      data pphs/'P','Pdiff','PP','PPP','PPPP','PPPPP','PcP','PcP2','PcP3',
     1          'PKP','PKKP','PKPPKP','PcPPKP','pP','pPP','pPPP'/

      parameter(NRS=24)
      character*10 sphs(NRS)
      data sphs/'S','Sdiff','SS','SSS','SSSS','SSSSS','ScS','ScS2','ScS3',
     1          'SKS','SKKS','SKSSKS','ScSSKS','sS','sSdiff','sSS','sSSS',
     1          'sScS','sScS2','sScS3','sSKS','sSSSS','ScS4','sScS4'/

      parameter(NMX=21)
      character*10 mxphs(NMX)
      data mxphs/'SP','PS','SSP','SPS','PSS','PPS','PSP','PcS','ScP','PKS','SKP',
     1           'PKKS','SKSP','PcSPKP','ScSP','ScSPKP','PKPSKS','PKPPKS','sP',
     1           'sPP','sPPP'/

c     copy data into array phs
      do i=1,60+NMX
       lphs(i)=0
      enddo
      do i=1,NRP
       phs(i)=pphs(i)
       lphs(i)=istlen(phs(i))
      enddo
      do i=1,NRS
       ind=30+i
       phs(ind)=sphs(i)
       lphs(ind)=istlen(phs(ind))
      enddo
      do i=1,NMX
       ind=60+i
       phs(ind)=mxphs(i)
       lphs(ind)=istlen(phs(ind))
      enddo

      branch(1)=''
      branch(2)='ab'
      branch(3)='bc'
      branch(4)='cd'
      branch(5)='df'
      branch(6)='ac'
      branch(7)='4a'
      branch(8)='4b'

      dtacode(1)='Fiona Reid - differential travel time data SH-component'
      dtacode(2)='Steve Grand - picks from WWSSN records (SH-component)'    
      dtacode(3)='Jeroen Ritsema - picks from crosscorrelation down to 15s'
      dtacode(4)='Jeroen Ritsema - travel time picks'
      dtacode(5)='Jeroen Ritsema - automatic picks around 40s'

      crustcor(1)='Fiona correction for crust5.1'
      crustcor(2)='HJ corrections for crust5.1'
      crustcor(3)='HJ corrections for crust2.0'

      end
