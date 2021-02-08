      subroutine findraypremupdiff(ilin,iwave,hdep,delt,dellegrad,dsstp,p,grad,
     1                             rad,del,vel,ds,npt)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      dimension rad(*),del(*),vel(*),ds(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     to check whether phase file has been read
      character*20 phsold
      common/oldphs/phsold,lphsold

      data pi/3.1415926535898d0/
      radian=180.0d0/pi

c     find ray
      call findraypremup1(ilin,iwave,hdep,dsstp,p,grad,rad,del,vel,ds,np1)
   
      ddelup=del(np1)*radian
      deldif=delt-ddelup
      
c     continue ray after bounce:
      grad=-1.d0
      dsnpstore=ds(np1)
      bncdep=0.d0
      delbnc=del(np1)
      call findraypremdiff(ilin,iwave,bncdep,deldif,dellegrad,dsstp,p,grad,
     1                         rad(np1),del(np1),vel(np1),ds(np1),np2)
      npt=np1+np2-1
      do i=np1,npt
       del(i)=del(i)+delbnc
      enddo
c     set length of first step to ds, otherwise 0!!!
      ds(np1)=dsnpstore

c     write(6,*) 'NP1, NP2, NPT',np1,np2,npt

      end

