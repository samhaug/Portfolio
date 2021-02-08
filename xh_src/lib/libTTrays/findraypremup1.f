      subroutine findraypremup1(ilin,iwave,srcdep,ds,p,grad,rarr,
     1                          delarr,varr,dsarr,np)

      implicit double precision(a-h,o-z)
      dimension rarr(*),delarr(*),varr(*),dsarr(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     initialise at the first depth

      gr=grad
c     last step is not implemented for up goinf ray!
      if(gr.eq.-1) stop 'findraypremup is set up for upgoing rays'
    
      np=0
      eps=1.d0-1.d-11
      i=1
      dep=srcdep
      r=rnorm-dep
      rarr(1)=r
      del=0.d0
      delarr(1)=0.d0
      dsarr(1)=0.d0
      sini=0.d0
      dssq=ds*ds


c     dummy dr
      dr=1.d0

      do while(sini.lt.eps.and.dr.gt.1d-15.and.r.le.6371.d0)
       call getv(iwave,dep,v,dv,lay,ierr)
       if(ierr.ne.0) goto 1000
       varr(i)=v
       
       oor=1.d0/r
       sini=p*v*oor
       if(sini.gt.1.d0) then
        cosi=0.d0
       else
        cosi=dsqrt(1.d0-(sini*sini))
       endif
       

c      use 2nd order 
c      find curvature: (Ben Menahem 7.91) di/ds
       rh=-p*dv*oor

       if(ilin.eq.1) then
        ddel=sini*ds*oor
        dr=cosi*ds
       else
        ddel=sini*ds*oor+(-oor*oor*cosi*sini+oor*cosi*rh)*dssq
        dr=cosi*ds-(sini*rh*dssq)
       endif

   
       i=i+1
       r=r+gr*dr
       dep=dep-gr*dr
       rarr(i)=r
       del=del+gr*ddel
       delarr(i)=del
       dsarr(i)=ds
c      write(111,*) del,r,v,sini
      enddo

c     include last part of the ray to 6371
c     velocity is still given by velocity at rarr(np-1)
c     same for sini and cosi
      np=i
      if(rarr(np).ne.6371.d0.or.srcdep.eq.0.d0) then
       rarr(np)=rnorm
       dr=rnorm-rarr(np-1)
       dsfin=dr/cosi
       dsarr(np)=dsfin
       ddel=sini*dsfin*oor
       delarr(np)=delarr(np-1)+ddel
       call getv(iwave,0.,v,dv,lay,ierr)
       if(ierr.ne.0) goto 1000
       varr(np)=v
      endif
        
      return

1000  continue
      if (ierr.eq.1) stop 'asking for S-velocity in outer core!'

      end
      

