c --------------------------------------------------------------------------
      subroutine getmulkern(iparsw,ipardps,kernfls,mxpmain,
     1                      nord,lord,ityp,rkern,nker,pv2loceig,
     1                      crustsens,ierr)
  
      common/setker/mtot,lnts,lntt,rmp(48),indsfr(330),kntsfr(330)
     1   ,indtor(300),knttor(300),nbatch,lump,luper,nparm

      parameter (MAXNRPAR=42)
      parameter (MXPARTYP=7)
      dimension iparsw(MXPARTYP),ipardps(2,MXPARTYP),rkern(MAXNRPAR)
      dimension amp(12),aker(MAXNRPAR),crustsens(3)
      character*80 kernfls(MXPARTYP)

      if(mxpmain.ne.MAXNRPAR) stop 'getmulkern; mxpmain.ne.MAXNRPAR'

      pi=4.*atan(1.)
      ierr=0
      indk=0

      do i=1,MXPARTYP
       if(iparsw(i).eq.1) then
        kerhed=1

        call openkr('/geo/home/jritsema/dta/SPRM1.BIN'
     1           ,kernfls(i)
     1           ,kerhed)

       if(nparm.gt.MAXNRPAR) stop'getmulkern: nparm in derivative file greater than MAXNRPAR'


c      retrieve the kernel with respect to the splines
        call getkrhj(nord,ityp,lord,amp,aker,ifgot,kerhed,naker)  
c       do k=1,12
c        write(6,*) k,amp(k)
c       enddo
        write(6,*) nord,ityp,lord,ifgot,kerhed,naker
c       write(6,'(''Branch:'',i3,''  Frequency No.'',i4)')a mp,nf
        write(6,'(''Mode:'',i3,1x,a1,1x,i4,f12.4,'' s'')') nord,ityp,lord,2.*pi/amp(1)
        gvel=amp(5)
        pvel=6371.*amp(1)/(lord+.5)
        reldcfac=1./amp(1)
        pv2loceig=pvel/gvel

        if(ifgot.ne.1) ierr=1

c      convert to derivatives of dw/w by multiplying by reldcfac
        call sscal(naker,reldcfac,aker,1)

c      check whether requested number of parameters does not exceed naker
        if(ipardps(2,i).gt.naker) stop'getmulkern: mismatch between ipardps and kernel file'
c      copy the requested partial derivatives to kernel
        do j=ipardps(1,i),ipardps(2,i)
         indk=indk+1
         write(6,*) indk,j
         rkern(indk)=aker(j)
         if(j.eq.3) then
          write(6,*) 'INCLUDING CRUSTAL THICKNESS! RESCALING.'
          rkern(indk)=rkern(indk)*1000.
         endif
        enddo

        write(6,*) 'LUMP, LUPER',lump,luper
        call closfl(lump)
        write(6,*) 'LUMP, LUPER',lump,luper
        call closfl(luper)
        write(6,*) 'LUMP, LUPER',lump,luper

       endif
      enddo

        write(6,*) 'A1'
      do i=1,3
       crustsens(i)=aker(i)
      enddo
        write(6,*) 'A2'
   
      nker=indk
      if(nker.eq.0) stop 'no derivative read'
      if(nker.gt.MAXNRPAR) stop 'nker.gt.MAXNRPAR, increase MAXNRPAR'
        write(6,*) 'A3'

      end

c         transform kernel to eigenvector basis
c          if(ismth.eq.1) then
c           do i=npf,nkermx
c            dumker(i-npf+1)=aker(i)
c           enddo
c           itr=1
c           call dotrf(ndim,dumker,trker,evcs,itr)
c          else
c           do i=npf,nkermx
c            trker(i-npf+1)=aker(i)
c           enddo
c          endif


