c ------------------------------------------------------

      subroutine rspthead(nfil,mtyp,lmax,mp1,iparsw,ipardps)
 
      parameter(MXPARTYP=7)
      dimension iparsw(MXPARTYP),ipardps(2,MXPARTYP)
      character*3 ctyp
 
      read(nfil,'(a3)') mtyp
      read(nfil,10) lmax,mp1,(iparsw(i),i=1,mp1)
      if(mp1.gt.MXPARTYP) stop'cannot store more than MXPARTYP parameter types'
10    format(i2,x,i2,x,10i1)
      do i=1,mp1
       if(iparsw(i).eq.1) then
        read(nfil,*) ipardps(1,i),ipardps(2,i)
       endif
      enddo
 
      end

