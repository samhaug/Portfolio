      subroutine findraypremmixed(ilin,iwave1,iwave2,srcdep,ds,p,grad1,
c    1                            rarr,delarr,varr,dsarr,npt)
     1                            rarr,delarr,varr,dsarr,npt,ibnc)

      implicit double precision(a-h,o-z)
      dimension rarr(*),delarr(*),varr(*),dsarr(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm
 
      if(grad1.eq.-1.d0) then
       call findrayprem(ilin,iwave1,srcdep,ds,p,grad1,rarr,
     1                 delarr,varr,dsarr,np1)
      else
       call findraypremup1(ilin,iwave1,srcdep,ds,p,grad1,rarr,
     1                     delarr,varr,dsarr,np1)
      endif

c     continue ray after bounce:
      grad2=-1.d0
      dsnpstore=dsarr(np1)
      bncdep=0.d0
      delbnc=delarr(np1)
      call findraypremdirect(ilin,iwave2,bncdep,p,grad2,ibnc,ds,np2,rarr(np1),
     1                       delarr(np1),varr(np1),dsarr(np1))
c     call findrayprem(ilin,iwave2,bncdep,ds,p,grad2,rarr(np1),delarr(np1),
c    1                 varr(np1),dsarr(np1),np2)
      npt=np1+np2-1
      do i=np1,npt
       delarr(i)=delarr(i)+delbnc
      enddo
c     set length of first step to ds, otherwise 0!!!
      dsarr(np1)=dsnpstore

      end
