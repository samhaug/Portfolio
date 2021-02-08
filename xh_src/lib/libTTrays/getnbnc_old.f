      subroutine getnbnc(phin,nbnc,ibtyp)

      character*(*) phin

      parameter(NPHS=73)
      character*20 phslist(NPHS),dumphs
      dimension lphslist(NPHS),nbnclist(NPHS),ibtyplist(NPHS)
      data phslist/'P','PP','PPP','PPPP','PcP','PcP2','PcP3','Pdiff',
     1             'S','SS','SSS','SSSS','ScS','ScS2','ScS3','Sdiff',
     1             'sScS','sScS2',
     1             'pP','pPP','sS','sSS','Sup','Pup',
     1             'ScS4','sScS3','sScS4','sSSS','sSSSS',
     1             'sSdiff','pPdiff',
     1             'ScP','PcS','SKSac','SKScd','SKSdf',
     1             'SKKSac','SKKScd','SKKSdf','SKPab','SKPbc',
     1             'SKPcd','SKPdf','PKSab','PKSbc',
     1             'PKScd','PKSdf','SKKPac','SKKPcd','SKKPdf',
     1             'PKKSac','PKKScd','PKKSdf','PKPab','PKPbc',
     1             'PKPcd','PKPdf','PKKPab','PKKPbc',
     1             'PKKPcd','PKKPdf',
     1             'SP4a','SP4b','SPab','SPbc','SPcd',
     1             'PS4a','PS4b','PSab','PSbc','PScd',
     1             'sP','sPP'/

      data nbnclist/0,1,2,3,0,1,2,0,0,1,2,3,0,1,2,0,
     1              1,2,1,2,1,2,0,0,3,3,4,3,4,1,1,
     1              0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1              0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1              1,1,1,1,1,1,1,1,1,1,1,2/

      data ibtyplist/0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1               0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1               1,1,1,1,1,11,11,11,11,11,1,10/

      

c     find length of phases
      do i=1,NPHS
       lphslist(i)=istlen(phslist(i))
      enddo

      lphin=istlen(phin)
      ifnd=0
      i=0
      do while(i.lt.NPHS.and.ifnd.eq.0)
       i=i+1
       if(lphin.eq.lphslist(i)) then
        dumphs=phslist(i)
        if(phin(1:lphin).eq.dumphs(1:lphin)) then
         ifnd=i
        endif
       endif
      enddo

      if(ifnd.eq.0) then
       nbnc=999
      else
       nbnc=nbnclist(ifnd)
       ibtyp=ibtyplist(ifnd)
      endif

      end


