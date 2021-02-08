c --------------------------------------------------------------------------
      subroutine getmulselfc(iparsw,ipardps,mdtp,nord,lord,isord,rmulkern,nker,
     1                       crustsens,lmax,ierr)
  
      parameter(MAXNRPAR=45)           ! largest dimension of derivative
      parameter(MXL=12)                ! largest angular order for derivatives
      parameter(MXSTORE=MXL/2+1)       ! maximum number of angular orders to be stored
      parameter(MXPARTYP=7)            ! number of derivative types

      dimension iparsw(MXPARTYP),ipardps(2,MXPARTYP)
      dimension itypd(MXPARTYP)
      dimension rkern(MAXNRPAR,MXPARTYP,MXSTORE)
      dimension rmulkern(*),crustsens(*)
      character*1 mdtp

      pi=4.*atan(1.)
      ierr=0
      indk=0
      lstore=isord/2+1

c     get kernels with respect to splines
      call getselfcder(mdtp,nord,lord,ommd,coveru,ndim,numt,lmax,itypd,rkern,MAXNRPAR)

      if(isord.gt.lmax) then
       ierr=1
       return
      endif

c     make composite kernel
      do i=1,MXPARTYP

c      copy the requested partial derivatives to rmulkern
       if(iparsw(i).eq.1) then
        do j=ipardps(1,i),ipardps(2,i)
         indk=indk+1

c COMMENT BY JEROEN R: should work now using Arwen's new kernels
c that she computed in May of 2009
c        if(i.ne.1) stop'getmulselfc: derivatives for parameters other than scaled Vp/Vs not yet defined'
c        write(6,*) indk,j,rkern(j,i,lstore),(rkern(j,k,lstore),k=1,7)
         rmulkern(indk)=rkern(j,i,lstore)
         if(j.eq.3) then
c         write(6,*) 'INCLUDING CRUSTAL THICKNESS! RESCALING.'
          rmulkern(indk)=rkern(j,i,lstore)*1000.
         endif
        enddo
       endif

      enddo

      do j=1,3
       crustsens(j)=rkern(j,1,lstore)
      enddo
   
      nker=indk
      if(nker.eq.0) stop 'no derivative read'
      if(nker.gt.MAXNRPAR) stop 'nker.gt.MAXNRPAR, increase MAXNRPAR'

      end

c -------------------------------------------------------------------------------------
