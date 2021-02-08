c----------------------------------------------------------
      subroutine closechn()
      include 'seeddefs.h'
      include 'seedtrees.h'
      if(itchn.eq.-1) return
      call trclos(itchpcl)
      call trclos(itchrcl)
      call trclos(itchicl)
      call trclos(itchccl)
      call trclos(itchn)
      chnopen=' '
      itchn=-1
      return
      end
