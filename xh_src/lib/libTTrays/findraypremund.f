      subroutine findraypremund(ilin,iwave,srcdep,nund,depund,ds,p,grad,
     1                            rarr,delarr,varr,dsarr,npt)

      implicit double precision(a-h,o-z)
      dimension iwave(*)
      dimension rarr(*),delarr(*),varr(*),dsarr(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

      iwind=0
c     if rays goes up, first find upgoing ray to surface
      if(grad.eq.1.d0) then
       iwind=iwind+1
c      write(6,*) 'calling findraypremup1 ',ilin,iwave(iwind),srcdep,ds,p,grad
       call findraypremup1(ilin,iwave(iwind),srcdep,ds,p,grad,rarr,delarr,varr,dsarr,npup)
       grad=-1.d0
       dsstore=dsarr(npup)
       delup=delarr(npup)
       dep1=0.d0
      else
       npup=1
       delup=0.d0
       dep1=srcdep
      endif

c     find ray down to depth of underside reflection
      iwind=iwind+1
      call findraypremd1d2(ilin,iwave(iwind),dep1,depund,ds,
     1                     p,grad,rarr(npup),delarr(npup),varr(npup),dsarr(npup),np1)

      dsarr(npup)=dsstore
      npund=npup+np1-1
      do i=npup,npund
       delarr(i)=delarr(i)+delup
      enddo

      dsstore=dsarr(npund)
      delund=delarr(npund)

c     now find ray from depund to turning point
      if(nund.ge.0) then
       iwind=iwind+1
       call findraypremd1d2(ilin,iwave(iwind),depund,6371.d0,ds,
     1                      p,grad,rarr(npund),delarr(npund),varr(npund),dsarr(npund),np2)
       dsarr(npund)=dsstore
       npbot=npund+np2-1
       do i=npund,npbot
        delarr(i)=delarr(i)+delund
       enddo

c      copy ray back up to depund
       ncpstart=npbot
       do i=1,np2-1
        indcpfrom=ncpstart-i
        indcpto=ncpstart+i
        rarr(indcpto)=rarr(indcpfrom)
        varr(indcpto)=varr(indcpfrom)
        ddel=delarr(ncpstart)-delarr(indcpfrom)
        delarr(indcpto)=delarr(ncpstart)+ddel
       enddo
       do i=1,np2-1
        indcpfrom=ncpstart-i+1
        indcpto=ncpstart+i
        dsarr(indcpto)=dsarr(indcpfrom)
       enddo

       npup2=npbot+np2-1

c      now create underside reflection by copying points from npund to npup2
       if(nund.eq.1) then
        ddel=delarr(npup2)-delarr(npund)
        npcp=npup2-npund
        ncpstart=npund
        do i=1,npcp
         indcpfrom=ncpstart+i
         indcpto=npup2+i
         rarr(indcpto)=rarr(indcpfrom)
         varr(indcpto)=varr(indcpfrom)
         delarr(indcpto)=delarr(indcpfrom)+ddel
         dsarr(indcpto)=dsarr(indcpfrom)
        enddo
        npup2=npup2+npcp
       endif

      else
       npup2=npund
      endif

c     find ray from depth of underside reflection to the surface
      iwind=iwind+1
      gradup=1.d0
      delup=delarr(npup2)
      dsstore=dsarr(npup2)
      call findraypremup1(ilin,iwave(iwind),depund,ds,p,gradup,rarr(npup2),
     1                          delarr(npup2),varr(npup2),dsarr(npup2),npend)

      dsarr(npup2)=dsstore
      npt=npup2+npend-1
      do i=npup2,npt
       delarr(i)=delarr(i)+delup
      enddo

      end

