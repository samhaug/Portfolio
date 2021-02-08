c ----------------------------------------------------------------

      subroutine setupinterpcrff(lmaxu)

      character*120 ifl

      parameter(MXL=80)
      parameter(MXLENY=(MXL+1)**2)
      parameter(MXP=11)

      common/intcrust/lmax,parr(MXP,2),ctt(MXLENY,MXP,2),topo(MXLENY)

c     read in S tt anomaly map
      ifl='/geo/home/jritsema/Utils/dta/crust/empirical_ff_ccor.S.raw'
      open(31,file=ifl,status='old')
      read(31,*) lmax
      if(lmax.ne.80) stop 'interpcrust: lmax.ne.80'
      if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
      leny=(lmax+1)**2
      read(31,'(5e16.8)') (ctt(k,1,1),k=1,leny)
      close(31)

c     read in P tt anomaly maps
      ifl='/geo/home/jritsema/Utils/dta/crust/empirical_ff_ccor.P.raw'
      open(31,file=ifl,status='old')
      read(31,*) lmax
      if(lmax.ne.80) stop 'interpcrust: lmax.ne.80'
      if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
      leny=(lmax+1)**2
      read(31,'(5e16.8)') (ctt(k,1,2),k=1,leny)
      close(31)

c     read in topography
      ifl='/geo/home/jritsema/Utils/dta/crust/crust2_topo.raw'
      open(31,file=ifl,status='old')
      read(31,*) lmax
      if(lmax.ne.80) stop 'interpcrust: lmax.ne.80'
      if(lmax.gt.MXL) stop 'interpcrust: lmax.gt.MXL'
      leny=(lmax+1)**2
      read(31,'(5e16.8)') (topo(k),k=1,leny)
      close(31)

      if(lmaxu.ne.-999) then
       if(lmaxu.gt.lmax) then
        stop'setupinterpcrff: lmaxu gt lmax'
       else
        lmax=lmaxu
       endif
      endif

      end

      
