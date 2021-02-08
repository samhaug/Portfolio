      Subroutine findraypremd1d2(ilin,iwave,dep1,dep2,ds,
     1                           p,grad,rarr,delarr,varr,dsarr,np)

c     dsarr(i) is the size of the step from dsarr(i-1) to dsarr(i)!!

      implicit double precision(a-h,o-z)
      dimension rarr(*),delarr(*),varr(*),dsarr(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

      gr=grad
c     last step is not implemented for up going ray!
      if(gr.eq.1) stop 'findrayprem is currently only set up for downgoing rays'
    
      eps=1.d0-1.d-11
      i=1
      dep=dep1
      rdep2=6371.d0-dep2
      r=rnorm-dep
      rarr(1)=r
      del=0
      delarr(1)=0
      sini=0.
      dssq=ds*ds
      dsarr(1)=0.
      dsfin=0.

c     dummy dr
      dr=1.d0

      do while(sini.lt.eps.and.dr.gt.1d-15.and.r.gt.rdep2)
       call getv(iwave,dep,v,dv,lay,ierr)
       if(ierr.ne.0) goto 1000
       varr(i)=v
       
c      store previous cosi in case cosi goes to zero
       cosiold=cosi
       oor=1.d0/r
       sini=p*v*oor
       if(sini.gt.1.d0) then
        cosi=0.d0
       else
        cosi=sqrt(1.d0-(sini*sini))
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
       del=del-gr*ddel
       delarr(i)=del
       dsarr(i)=ds
c      write(111,*) del,r,v,sini
      enddo

c     bring final point to dep2
      if(sini.lt.eps) then
       if(cosi.eq.0) cosi=cosiold
       rarr(i)=rdep2
       drfin=rarr(i-1)-rdep2
       dep=dep2
       call getv(iwave,dep,v,dv,lay,ierr)
       varr(i)=v
       dsfin=drfin/cosi
       dsarr(i)=dsfin
       ddelfin=dsfin*sini*oor
       delarr(i)=delarr(i-1)+ddelfin
      endif

      np=i-1

      return

1000  continue
      if (ierr.eq.1) stop 'asking for S-velocity in outer core!'

      end
      

