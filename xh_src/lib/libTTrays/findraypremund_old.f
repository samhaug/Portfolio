      subroutine findraypremund(ilin,iwave,srcdep,nund,depund,ds,p,grad,
     1                            rarr,delarr,varr,dsarr,npt)

      implicit double precision(a-h,o-z)
      dimension iwave(*)
      dimension rarr(*),delarr(*),varr(*),dsarr(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     find ray down to depth of underside reflection
      iwind=1
      call findraypremd1d2(ilin,iwave(iwind),srcdep,depund,ds,
     1                     p,grad,rarr,delarr,varr,dsarr,np1)
      dsstore=dsarr(np1)
      delund=delarr(np1)

c     now find ray from depund to turning point
      if(nund.ge.0) then
       iwind=iwind+1
       call findraypremd1d2(ilin,iwave(iwind),depund,6371.d0,ds,
     1                      p,grad,rarr(np1),delarr(np1),varr(np1),dsarr(np1),np2)
       dsarr(np1)=dsstore
       npbot=np1+np2-1
       do i=np1,npbot
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

       npup=npbot+np2-1

c      now create underside reflection by copying points from np1 to npup
       if(nund.eq.1) then
        ddel=delarr(npup)-delarr(np1)
        npcp=npup-np1
        ncpstart=np1
        do i=1,npcp
         indcpfrom=ncpstart+i
         indcpto=npup+i
         rarr(indcpto)=rarr(indcpfrom)
         varr(indcpto)=varr(indcpfrom)
         delarr(indcpto)=delarr(indcpfrom)+ddel
         dsarr(indcpto)=dsarr(indcpfrom)
        enddo
        npup=npup+npcp
       endif

      else
       npup=np1
      endif

c     find ray down to depth of underside reflection
      iwind=iwind+1
      gradup=1.d0
      delup=delarr(npup)
      dsstore=dsarr(npup)
      call findraypremup1(ilin,iwave(iwind),depund,ds,p,gradup,rarr(npup),
     1                          delarr(npup),varr(npup),dsarr(npup),npend)

      dsarr(npup)=dsstore
      npt=npup+npend-1
      do i=npup,npt
       delarr(i)=delarr(i)+delup
      enddo

      end

