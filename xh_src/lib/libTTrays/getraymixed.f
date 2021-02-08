      subroutine getraymixed(phs,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      real psngl,hdepmx
      character*(*) phs,mod
      dimension rad(*),del(*),vel(*),ds(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     to check whether phase file has been read
      character*1 ch1,ch2
      character*20 phsold
      common/oldphs/phsold,lphsold

c     some logicals
      logical log1,log2

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

      if(phs(1:2).eq.'SP') then
       iwave1=3
       iwave2=2
       grad=-1.d0
      else if(phs(1:2).eq.'PS') then
       iwave1=2
       iwave2=3
       grad=-1.d0
      else if(phs(1:2).eq.'sP') then
       iwave1=3
       iwave2=2
       grad=1.d0
      else if(phs(1:2).eq.'pS') then
       iwave1=2
       iwave2=3
       grad=1.d0
      else
       stop 'getraymixed: unknown phase type'
      endif

      call getnbnc(phs,nbnc,ibtyp)
      ibnc=nbnc-1 ! no additional bounce after initial conversion bounce
c      check whether all the same type after initial conversion bounce
c      do i=2,lphs-1
c       ch1=phs(i:i)
c       ch2=phs(i+1:i+1)
c       log1=((ch1.eq.'S'.or.ch1.eq.'P').and.(ch2.eq.'S'.or.ch2.eq.'P'))
c       log2=(ch1.ne.ch2)
c       if(log1.and.log2) stop 'not yet working for more than 1 conversion'
c      enddo
c      ibnc=lphs-2
c     endif

      ilin=2
      call findraypremmixed(ilin,iwave1,iwave2,hdep,dsstp,p,grad,rad,del,vel,ds,npt,ibnc)

c     write(6,*) 'NP1, NP2, NPT',np1,np2,npt

      end

