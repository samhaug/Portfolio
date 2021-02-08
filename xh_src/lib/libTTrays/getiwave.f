      subroutine getiwave(phs,nund,iwave)

      character*(*) phs
      dimension iwave(*)

      parameter(MXPH=9)
      character*20 phstore(MXPH)
      data phstore/'SKKS','PKKP','PKKS','SKKP','SKP','PKS',
     1             'ScP','PcS','sSKS'/

      dimension istore(6,MXPH)
      data istore/4,1,9,9,9,-1,
     1            4,1,2,2,2,-1,
     1            4,1,2,9,9,-1,
     1            4,1,9,2,2,-1,
     1            3,0,9,2,2,-1,
     1            3,0,2,9,9,-1,
     1            3,-1,9,2,0,-1,
     1            3,-1,2,9,0,-1,
     1            4,0,9,9,9,9 /

      ifnd=0
      i=0
      do while(ifnd.eq.0.and.i.lt.MXPH)
       i=i+1
       len=istore(1,i)
       if(phs(1:len).eq.phstore(i)(1:len)) then
        nund=istore(2,i)
        do j=1,4
         iwave(j)=istore(2+j,i)
        enddo
        ifnd=1
       endif
      enddo

      end
