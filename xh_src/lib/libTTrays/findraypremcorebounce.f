      Subroutine findraypremcorebounce(ilin,iwave,isbnc,srcdep,ds,
     1                                 p,grad,rarr,delarr,varr,dsarr,np)

c     dsarr(i) is the size of the step from dsarr(i-1) to dsarr(i)!!

      implicit double precision(a-h,o-z)
      dimension rarr(*),delarr(*),varr(*),dsarr(*),delbnc(20)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

      gr=grad
c     last step is not implemented for up going ray!
      if(gr.eq.1) stop 'findrayprem is currently only set up for downgoing rays'
    
      eps=1.d0-1.d-11
      i=1
      dep=srcdep
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

      do while(sini.lt.eps.and.dr.gt.1d-15.and.r.gt.3480.d0)
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

c     bring final point to cmb
      if(cosi.eq.0) cosi=cosiold
      rcmb=3480.d0
      rarr(i)=rcmb
      drfin=rarr(i-1)-rcmb
      dep=2891.d0
      call getv(iwave,dep,v,dv,lay,ierr)
      varr(i)=v
      dsfin=drfin/cosi
      dsarr(i)=dsfin
      ddelfin=dsfin*sini*oor
      delarr(i)=delarr(i-1)+ddelfin

      np=i
      npbot=np
      npup=npbot

      if(gr.lt.0.) then
c      let ray go up now:
       dbot=delarr(npbot)
       dbot2=2.d0*dbot
       do i=1,np-1
        delarr(npup+i)=dbot2-delarr(np-i)
        varr(npup+i)=varr(np-i)
        rarr(npup+i)=rarr(np-i)
        dsarr(npup+i)=dsarr(np-i+1)
       enddo
       np=2*npbot-1

C      continue to the surface if source depth > 0
       if(srcdep.ne.0.) then
c       write(6,*) 'extending to the surface'
        gr=1.d0
        i=np
        del=delarr(np)
        r=rarr(np)
        dep=6371.d0-r
        do while(r.lt.6371)
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

      npt=np
      if(isbnc.ge.1) then
       do jj=1,isbnc
        delbnc(jj)=delarr(npt)
        if(jj.eq.1) then

c        ray back down
         nptold=npt
         nplastbnc=npt
         delsbnc=delarr(nptold)
      
         np2=npt-npup
         do i=1,np2
          indcpfrom=npt-i
          indcpto=npt+i
          rarr(indcpto)=rarr(indcpfrom)
          varr(indcpto)=varr(indcpfrom)
          delarr(indcpto)=(delsbnc-delarr(indcpfrom))+delsbnc
          dsarr(indcpto)=dsarr(indcpfrom+1)
         enddo
         npt=npt+np2

c        and up

         nptold=npt
         delsbnc=delarr(nptold)
         do i=1,np2
          indcpfrom=npt-i
          indcpto=npt+i
          rarr(indcpto)=rarr(indcpfrom)
          varr(indcpto)=varr(indcpfrom)
          delarr(indcpto)=(delsbnc-delarr(indcpfrom))+delsbnc
          dsarr(indcpto)=dsarr(indcpfrom+1)
         enddo
         npt=npt+np2
        else
         npcp=npt-nplastbnc
         ddel=delbnc(jj)-delbnc(jj-1)
         do i=1,npcp
          indcpfrom=nplastbnc+i
          indcpto=npt+i
          rarr(indcpto)=rarr(indcpfrom)
          varr(indcpto)=varr(indcpfrom)
          delarr(indcpto)=delarr(indcpfrom)+ddel
          dsarr(indcpto)=dsarr(indcpfrom+1)
         enddo
         nplastbnc=npt
         npt=npt+npcp
        endif
       enddo
      endif
      np=npt

      return

1000  continue
      if (ierr.eq.1) stop 'asking for S-velocity in outer core!'

      end
      

