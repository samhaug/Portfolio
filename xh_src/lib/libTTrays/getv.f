C      SUBROUTINE TO CALCULATE Vs PREM
      subroutine getv(iwave,dep,vsp,dvsp,lay,ierr)
      implicit double precision(a-h,o-z)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm
      double precision temp(4)

      ierr=0
      if(dep.lt.0.0d0) then
          dep=0.001d0
          ierr=5
      endif
      r=rnorm-dep
      rn=r/rnorm

c     find layer number
      do  l=12,1,-1
          if (xb(l).lt.r.and.xt(l).ge.r) lay=l
      enddo

c     is depth in outer core for s-wave?
      ierr=0
      if(lay.eq.2.and.(iwave.eq.3.or.iwave.eq.7)) then
       ierr=1
      endif

c     iwave=9 for SKS type phase: P velocity in core
c     S velocity in mantle
      if(iwave.eq.9) then
       if(lay.gt.2) then
        iw=3
       else 
        iw=2
       endif
      else
       iw=iwave
      endif

      if(ierr.eq.0) then
       vsp=0.0d0
       dvsp=0.0d0
       fac=1.0d0
       do j=1,4
           temp(j)=cofno(lay,iw,j)
           vsp=vsp+temp(j)*fac
           fac=fac*rn
       enddo
       fac=1.0d0
       do j=2,4
           dvsp=dvsp+temp(j)*1.569612306d-4*fac*(j-1)
           fac=fac*rn
       enddo

      endif
 
      end

