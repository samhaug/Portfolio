      subroutine inelcor(phin,ifnd)

      character*(*) phin

      parameter(NPHC=67)
      character*8 phcod(NPHC),dumphs
      dimension lphc(NPHC)
      data phcod/
     1 "Pup   ","P     ","Pdiff ","PKPab ","PKPbc ","PKPdf ",
     1 "PKiKP ","pP    ","pPKPab","pPKPbc","pPKPdf","pPKiKP",
     1 "sP    ","sPKPab","sPKPbc","sPKPdf","sPKiKP","PcP   ",
     1 "ScP   ","SKPab ","SKPbc ","SKPdf ","SKiKP ","PKKPab",
     1 "PKKPbc","PKKPdf","SKKPab","SKKPbc","SKKPdf","PP    ",
     1 "P'P'  ","Sup   ","S     ","Sdiff ","SKSac ","SKSdf ",
     1 "pS    ","pSKSac","pSKSdf","sS    ","sSKSac","sSKSdf",
     1 "ScS   ","PcS   ","PKSab ","PKSbc ","PKSdf ","PKKSab",
     1 "PKKSbc","PKKSdf","SKKSac","SKKSdf","SS    ","S'S'  ",
     1 "SP    ","PS    ","PnS   ",
     1 "SP4a  ","SP4b  ","SPab  ","SPbc  ","SPcd  ",
     1 "PS4a  ","PS4b  ","PSab  ","PSbc  ","PScd  "/

c     find length of phases
      do i=1,NPHC
       lphc(i)=istlen(phcod(i))
      enddo

      lphin=istlen(phin)
      ifnd=0
      i=0
      do while(i.lt.NPHC.and.ifnd.eq.0)
       i=i+1
       if(lphin.eq.lphc(i)) then
        dumphs=phcod(i)
        if(phin(1:lphin).eq.dumphs(1:lphin)) then
         ifnd=1
        endif
       endif
      enddo

      end


       
