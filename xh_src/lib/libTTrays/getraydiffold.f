      subroutine getraydiff(phs,mod,hdep,delt,dsstp,npt,rad,del,vel,ds,icall)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      character*(*) phs,mod
      dimension rad(*),del(*),vel(*),ds(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

      data pi/3.1415926535898d0/
      radian=180.0d0/pi

      if(icall.ne.999) then
       call readin
       icall=999
      endif

c     initialise for distinguishing between main phase and diffracted phase
c     and check phase
      call dchkdiff(phs,hdep,delt,phs)
      if(phs(2:5).ne.'diff') stop 'this phase is not diffracted!'

      if(mod.ne.'prem') stop 'getraypremdiff: models other than prem not yet implemented in findrayprem --> findray1)'

      if(phs(1:1).eq.'S') then
       iwave=3
       dellegrad=0.8961369805145758d0
       grad=-1.d0
      else if(phs(1:1).eq.'P') then
       iwave=2
       dellegrad=0.8584379714505559d0
       grad=-1.d0
      else
       stop 'getray: unknown phase type'
      endif

      rcmb=3480.d0
      dcmb=6371.d0-rcmb
      call getv(iwave,dcmb,vcmb,dv,lay,ierr)
      p=rcmb/vcmb
      write(6,*) 'setting ray parameter to ',p

      ilin=2
c     find ray
      write(6,*) 'voor findraypremdiff :'
      write(6,*) ilin,iwave,hdep,dsstp,p,grad
      call findraypremdiff(ilin,iwave,hdep,delt,dellegrad,dsstp,
     1                     p,grad,rad,del,vel,np1,dsfin)
      
      npt=np1

c     store ds steps
      do i=1,npt
       ds(i)=dsstp
      enddo
      if(dsfin.ne.0) ds(np1)=dsfin

      end

