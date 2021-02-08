      subroutine getray(phs,mod,hdep,delt,dsstp,npt,rad,del,vel,ds,icall)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      real psngl
      character*(*) phs,mod
      dimension rad(*),del(*),vel(*),ds(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     to check whether phase file has been read
      character*20 phsold
      common/oldphs/phsold,lphsold

      data pi/3.1415926535898d0/
      radian=180.0d0/pi

      if(icall.ne.999) then
       call readin
       icall=999
      endif

c     initialise for distinguishing between main phase and diffracted phase
c     and check phase
      call dchkdiff(phs,hdep,delt,phs)
      if(phs(2:5).eq.'diff') stop 'diffracted phases cannot be calculated yet'

c     write(6,*) 'voor istlen',mod,phs
      lmd=istlen(mod)
      lph=istlen(phs)

      if(mod.ne.'prem') stop 'getray: models other than prem not yet implemented in findrayprem --> findray1)'

c     get ray-parameter
c     write(6,*) 'voor readphs'
      lphs=istlen(phs)
      if(phs(1:lphs).ne.phsold(1:lphs).or.lphs.ne.lphsold) then
c      write(6,*) 're-initialising phase file'
       call readphs(mod,lmd,phs,lph)
       phsold=''
       phsold=phs(1:lphs)
       lphsold=istlen(phsold)
      endif
c     write(6,*) 'voor dgetphsp',delt
      call getphsp(sngl(delt),sngl(hdep),psngl)
      p=radian*dble(psngl)
c     write(6,*) 'na getphsp',p,radian,psngl

      if(phs(1:1).eq.'S') then
       iwave=3
       grad=-1.d0
      else if(phs(1:1).eq.'P') then
       iwave=2
       grad=-1.d0
      else
       stop 'getray: unknown phase type'
      endif

      ibnc=0
      if(phs(1:2).eq.'SS'.or.phs(1:2).eq.'PP') ibnc=1

      ilin=2
c     find ray
c     write(6,*) 'voor findrayprem',iwave
      call findrayprem(ilin,iwave,hdep,dsstp,p,grad,rad,del,vel,np1,dsfin)
c     write(6,*) 'na findrayprem',np1
      
c     continue ray after bounce:
      if(ibnc.eq.1) then
       bncdep=0.
       delbnc=del(np1)
c      write(6,*) 'voor findrayprem'
       call findrayprem(ilin,iwave,bncdep,dsstp,p,grad,rad(np1),del(np1),vel(np1),np2,dsfin)
c     write(6,*) 'na findrayprem',np2
       npt=np1+np2-1
       do i=np1,npt
        del(i)=del(i)+delbnc
       enddo
      else
       npt=np1
      endif

c     write(6,*) 'NP1, NP2, NPT',np1,np2,npt

c     store ds steps
      do i=1,npt
       ds(i)=dsstp
      enddo
      if(dsfin.ne.0) ds(np1)=dsfin

      end

