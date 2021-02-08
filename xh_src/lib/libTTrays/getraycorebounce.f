      subroutine getraycorebounce(phs,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      real psngl,hdepmx
      character*(*) phs,mod
      character*1 chsbnc
      dimension rad(*),del(*),vel(*),ds(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     to check whether phase file has been read
      character*20 phsold
      common/oldphs/phsold,lphsold

      data pi/3.1415926535898d0/
      radian=180.0d0/pi

c     write(6,*) 'voor istlen',mod,phs
      lmd=istlen(mod)

c     get ray-parameter
      lphs=istlen(phs)
      if(phs(1:lphs).ne.phsold(1:lphs).or.lphs.ne.lphsold) then
c      write(6,*) 're-initialising phase file'
       call readphs(mod,lmd,phs,lphs,hdepmx)
       phsold=''
       phsold=phs(1:lphs)
       lphsold=istlen(phsold)
      endif
      call getphsp(sngl(delt),sngl(hdep),psngl)
      p=radian*dble(psngl)

      if(phs(1:1).eq.'S') then
       iwave=3
       grad=-1.d0
      else if(phs(1:1).eq.'s') then
       iwave=3
       grad=1.d0
      else if(phs(1:1).eq.'P') then
       iwave=2
       grad=-1.d0
      else if(phs(1:1).eq.'p') then
       iwave=2
       grad=1.d0
      else
       stop 'getray: unknown phase type'
      endif

      ilin=2

c     determine number of surface bounces
      isbnc=0
      if(phs(1:1).ne.'s'.and.phs(1:1).ne.'p') then
       if(lphs.gt.3) then
        chsbnc=phs(4:4)
        read(chsbnc,*) isbnc
        isbnc=isbnc-1
       endif
      else
       if(lphs.gt.4) then
        chsbnc=phs(5:5)
        read(chsbnc,*) isbnc
        isbnc=isbnc-1
       endif
      endif


c     find ray
      if(grad.eq.-1.d0) then
       call findraypremcorebounce(ilin,iwave,isbnc,hdep,dsstp,p,grad,rad,del,vel,ds,npt)
      else if(grad.eq.1.d0) then
c      add in the surface bounce above source
       isbnc=isbnc+1
       call findraypremupcorebnc(ilin,iwave,hdep,p,grad,isbnc,dsstp,npt,rad,del,vel,ds)
      endif
      
c     write(6,*) 'NP1, NP2, NPT',np1,np2,npt

      end

