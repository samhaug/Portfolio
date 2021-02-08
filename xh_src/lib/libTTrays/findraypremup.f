      subroutine findraypremup(ilin,iwave,hdep,p,grad,ibnc,dsstp,npt,rad,del,vel,ds)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      dimension rad(*),del(*),vel(*),ds(*)
      dimension delbnc(10)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     to check whether phase file has been read
      character*20 phsold
      common/oldphs/phsold,lphsold

      data pi/3.1415926535898d0/
      radian=180.0d0/pi

c     find ray
      call findraypremup1(ilin,iwave,hdep,dsstp,p,grad,rad,del,vel,ds,np1)
      
c     continue ray after bounce:
      grad=-1.d0
      if(ibnc.ge.1) then
       dsnpstore=ds(np1)
       bncdep=0.d0
       delbnc(1)=del(np1)
       call findrayprem(ilin,iwave,bncdep,dsstp,p,grad,rad(np1),del(np1),vel(np1),ds(np1),np2)
       npt=np1+np2-1
       do i=np1,npt
        del(i)=del(i)+delbnc(1)
       enddo
c      set length of first step to ds, otherwise 0!!!
       ds(np1)=dsnpstore
      else
       npt=np1
      endif

       
      if(ibnc.gt.1) then
       do jj=2,ibnc
        nptold=npt
        delbnc(jj)=del(nptold)
        ddel=delbnc(jj)-delbnc(jj-1)
        npt=nptold+np2-1
        ncpstart=nptold-np2+1
        do i=1,np2
         indcpfrom=ncpstart+i-1
         indcpto=nptold+i-1
         rad(indcpto)=rad(indcpfrom)
         vel(indcpto)=vel(indcpfrom)
         del(indcpto)=del(indcpfrom)+ddel
        enddo
        do i=2,np2
         indcpfrom=ncpstart+i-1
         indcpto=nptold+i-1
         ds(indcpto)=ds(indcpfrom)
        enddo
       enddo
      endif
        
       

c     write(6,*) 'NP1, NP2, NPT',np1,np2,npt

      end

