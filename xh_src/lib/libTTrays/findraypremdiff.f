      Subroutine findraypremdiff(ilin,iwave,srcdep,delt,dellegrad,ds,
     1                           p,grad,rarr,delarr,varr,dsarr,np)

      implicit double precision(a-h,o-z)
      dimension rarr(*),delarr(*),varr(*),dsarr(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

      data pi/3.1415926535898d0/
      radian=180.0d0/pi
      delrad=delt/radian

      gr=grad
c     last step is not implemented for up going ray!
      if(gr.eq.1) stop 'findrayprem is currently only set up for downgoing rays'
    
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

      do while(sini.lt.eps.and.dr.gt.1d-15.and.r.gt.3480.d0)
       call getv(iwave,dep,v,dv,lay,ierr)
       if(ierr.ne.0) goto 1000
       varr(i)=v
       
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

c     get velocity in bottom point
      if(r.lt.6371) then
       call getv(iwave,dep,v,dv,lay,ierr)
       if(ierr.ne.0) then
        write(6,*) 'resetting bottom point'
        r=3480.d0
        dep=6371.d0-r
        rarr(i)=r
        call getv(iwave,dep,v,dv,lay,ierr)
       endif
       varr(i)=v
       np=i
       npbot=np
      else
       np=i-1
      endif

c     continue ray along the CMB
      delbot=delarr(npbot)
      deldiff=delrad-delbot-dellegrad
      rcmb=3480.d0
      dcmb=6371.d0-rcmb
      call getv(iwave,dcmb,vcmb,dv,lay,ierr)
      dsrad=ds/3480.d0
      npdiff=int(deldiff/dsrad)
      do j=1,npdiff
       ind=npbot+j
       delarr(ind)=delarr(ind-1)+dsrad
       dsarr(ind)=ds
       varr(ind)=vcmb
       rarr(ind)=3480
      enddo
      npup=npbot+npdiff

      if(gr.lt.0.) then
c      let ray go up now:
       dbot=delarr(npbot)
       dbot2=2*dbot+npdiff*dsrad
       do i=1,np-1
        delarr(npup+i)=dbot2-delarr(np-i)
        varr(npup+i)=varr(np-i)
        rarr(npup+i)=rarr(np-i)
        dsarr(npup+i)=ds
       enddo
       np=2*np-1+npdiff

c      continue to the surface if source depth > 0
       if(srcdep.ne.0.) then
c       write(6,*) 'extending to the surface'
        gr=1.d0
        i=np
        del=delarr(np)
        r=rarr(np)
        dep=6371.d0-r
        do while(r.le.6371)
         call getv(iwave,dep,v,dv,lay,ierr)
         if(ierr.ne.0) goto 1000
         varr(i)=v
   
         oor=1.d0/r
         sini=p*v*oor
         if(sini.gt.1.d0) then
          cosi=0.d0
         else
          cosi=sqrt(1.d0-(sini*sini))
         endif

c       use 2nd order
c       find curvature: (Ben Menahem 7.91) di/ds
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
        enddo

c       include last part of the ray to 6371
c       velocity is still given by velocity at rarr(np-1)
c       same for sini and cosi
        np=i
        rarr(np)=rnorm
        dr=rnorm-rarr(np-1)
        dsfin=dr/cosi
        dsarr(i)=dsfin
        ddel=sini*dsfin*oor
        delarr(np)=delarr(np-1)+ddel
        call getv(iwave,0.,v,dv,lay,ierr)
        if(ierr.ne.0) goto 1000
        varr(np)=v
        
       endif

      endif

      return

1000  continue
      if (ierr.eq.1) stop 'asking for S-velocity in outer core!'

      end
      

