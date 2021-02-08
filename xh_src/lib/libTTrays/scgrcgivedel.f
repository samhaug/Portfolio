c -----------------------------------------------------------------
      subroutine scgrcgivedel(ths,phs,thr,phr,del,ndel,MXP,pnts,idb,epd,imima)
 
c     This subroutine calculates points for epicentral distances
c     given in array del alongh the
c     great circle path from source to receiver
c     the epicentral distance may slightly over- or undershoot
c     the position of the receiver
c     ths = elat, phs = elon, thr = stlat, phr = stlon

      dimension del(*)
 
      dimension pnts(2,MXP)
 
      qpi=atan(1.d0)
      hpi=2.*qpi
      tpi=8.*qpi
 
c    transform to xyz coord.
      call cxyz(ths,phs,xs,ys,zs)
      call cxyz(thr,phr,xr,yr,zr)
 
      if(idb.eq.1) write(6,*) ths,phs,xs,ys,zs
      if(idb.eq.1) write(6,*) thr,phr,xr,yr,zr
 
c    calc. angle between two vectors
      xsixr=xs*xr+ys*yr+zs*zr
      omr=acos(xsixr)
      epd=omr*360/tpi
      if(ndel.gt.MXP) stop 'increase maxp'
 
      if(idb.eq.1) write(6,*) 'omr= ',omr
 
c    calc. vector perpend. to xs in greatc plane
      f1=xs*xs+ys*ys+zs*zs
      if(idb.eq.1) write(6,*) 'length = ',f1
      a=-xsixr
      xd=xr+a*xs
      yd=yr+a*ys
      zd=zr+a*zs
      xdixs=xd*xs+yd*ys+zd*zs
      if(idb.eq.1) write(6,*) 'xdixs =',xdixs
      rl=1./(sqrt(xd*xd+yd*yd+zd*zd))
      if(idb.eq.1) write(6,*) 'rl =',rl
 
      xb=xd*rl
      yb=yd*rl
      zb=zd*rl
 
      xbixr=xb*xr+yb*yr+zb*zr
      if(idb.eq.1) write(6,*)'xbixr = ', xbixr
      if(abs(xbixr)-1.lt.000001) then
       ang=hpi
      else
       ang=acos(xbixr)
      endif
      if(idb.eq.1) write(6,*) 'ang = ',ang
      If(abs(ang).gt.hpi) Then
       xb=-xb
       yb=-yb
       zb=-zb
      Endif
 
      Do i=1,ndel
       if(imima.eq.1) then
        d=del(i)
       else
        d=tpi-del(i)
       endif
       xp=cos(d)*xs+sin(d)*xb
       yp=cos(d)*ys+sin(d)*yb
       zp=cos(d)*zs+sin(d)*zb
       call ctp(xp,yp,zp,thp,php)
       pnts(1,i)=php
       pnts(2,i)=thp
      Enddo
 
      End
 
c ---------------------------------------------------------------

