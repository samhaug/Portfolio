      subroutine getrayup(phs,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      real psngl,hdepmx
      character*(*) phs,mod
      dimension rad(*),del(*),vel(*),ds(*)
      dimension delbnc(10)
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

      if(phs(1:1).eq.'S'.or.phs(1:1).eq.'s') then
       iwave=3
       grad=1.d0
      else if(phs(1:1).eq.'P'.or.phs(1:1).eq.'p') then
       iwave=2
       grad=1.d0
      else
       stop 'getray: unknown phase type'
      endif

      ibnc=0
      if(phs(1:2).eq.'sS'.or.phs(1:2).eq.'pP') ibnc=1
      if(phs(1:3).eq.'sSS'.or.phs(1:3).eq.'pPP') ibnc=2
      if(phs(1:4).eq.'sSSS'.or.phs(1:4).eq.'pPPP') ibnc=3
      if(phs(1:5).eq.'sSSSS'.or.phs(1:5).eq.'pPPPP') ibnc=4

      ilin=2
      call findraypremup(ilin,iwave,hdep,p,grad,ibnc,dsstp,npt,rad,del,vel,ds)

c     write(6,*) 'NP1, NP2, NPT',np1,np2,npt

      end

