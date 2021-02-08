      subroutine getraydiff(phs,hdep,delt,dsstp,npt,rad,del,vel,ds)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      character*(*) phs
      dimension rad(*),del(*),vel(*),ds(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

      if(phs(1:1).eq.'S') then
       iwave=3
       dellegrad=0.8961369805145758d0
       grad=-1.d0
      else if(phs(1:1).eq.'s') then
       iwave=3
       dellegrad=0.8961369805145758d0
       grad=1.d0
      else if(phs(1:1).eq.'P') then
       iwave=2
       dellegrad=0.8584379714505559d0
       grad=-1.d0
      else if(phs(1:1).eq.'p') then
       iwave=2
       dellegrad=0.8584379714505559d0
       grad=1.d0
      else
       stop 'getraydiff: unknown phase type'
      endif

      rcmb=3480.d0
      dcmb=6371.d0-rcmb
      call getv(iwave,dcmb,vcmb,dv,lay,ierr)
      p=rcmb/vcmb

      ilin=2
c     find ray
      if(grad.eq.1.d0) then
       call findraypremupdiff(ilin,iwave,hdep,delt,dellegrad,dsstp,
     1                     p,grad,rad,del,vel,ds,npt)
      else 
       call findraypremdiff(ilin,iwave,hdep,delt,dellegrad,dsstp,
     1                     p,grad,rad,del,vel,ds,npt)
      endif
      
      end

