      subroutine phs2ttcd(phin,iph,ibr,ierr)

      character*(*) phin
      character*2 estr
      character*12 check

c     for common block
      include 'phslist.h'

      lph=istlen(phin)
      lphin=lph
c     write(6,*) 'phin= ', phin, ' lph= ', lph
      if(lph.le.2) then
       ibr=1
      else 
       ibr=1
       estr=phin(lph-1:lph)
       do i=2,MXNRBR
        if(estr.eq.branch(i)) then
         ibr=i
         lph=lph-2
        endif
       enddo
      endif

      i=0
      ifnd=0
      do while (ifnd.eq.0.and.i.lt.MXNRPHS)
       i=i+1
c      write(6,*) ' lph_i= ', lphs(i), phs(i)
       if(lphs(i).eq.lph) then
        if(phs(i)(1:lph).eq.phin(1:lph)) then
         ifnd=1
         iph=i
        endif
       endif
      enddo

c     check result
      lbr=istlen(branch(ibr))
      check=phs(iph)(1:lphs(iph))//branch(ibr)(1:lbr)
      lch=lphs(iph)+lbr
      if(check(1:lch).eq.phin(1:lphin)) then
       ierr=0
      else
       ierr=1
      endif
        
      end
