      subroutine getraycore(phs,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      real psngl,hdepmx
      dimension iwarr(10)
      character*(*) phs,mod
      dimension rad(*),del(*),vel(*),ds(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     to check whether phase file has been read
      character*20 phsold
      common/oldphs/phsold,lphsold

      data pi/3.1415926535898d0/
      radian=180.0d0/pi

c     write(6,*) 'voor istlen',mod,phs
      lph=istlen(phs)
      lmd=istlen(mod)

c     get ray-parameter
      lphs=istlen(phs)
      if(phs(1:lphs).ne.phsold(1:lphs).or.lphs.ne.lphsold) then
c      write(6,*) 're-initialising phase file'
       call readphs(mod,lmd,phs,lph,hdepmx)
       phsold=''
       phsold=phs(1:lphs)
       lphsold=istlen(phsold)
      endif
      call getphsp(sngl(delt),sngl(hdep),psngl)
      p=radian*dble(psngl)

      ilin=2
      if(phs(1:1).eq.'P'.or.phs(1:1).eq.'S') then
       grad=-1.d0
      else if(phs(1:1).eq.'p'.or.phs(1:1).eq.'s') then
       grad=1.d0
      else
       pause 'getraycore: unknown phase'
      endif
       

      if(phs(1:3).eq.'SKS'.or.phs(1:3).eq.'PKP') then
       if(phs(1:1).eq.'S') then
        iwave=9
       else if(phs(1:1).eq.'P') then
        iwave=2
       endif

       call findrayprem(ilin,iwave,hdep,dsstp,p,grad,rad,del,vel,ds,npt)
      else
       depund=2891.d0
       call getiwave(phs,nund,iwarr)
       call findraypremund(ilin,iwarr,hdep,nund,depund,dsstp,p,grad,rad,del,vel,ds,npt)
      endif

      end


