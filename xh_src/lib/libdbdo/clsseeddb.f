      subroutine clsseeddb()
      include 'seeddefs.h'
      include 'seedtrees.h'
      call closechn()
      call closestn()
      call trclos(itvlbl)
      call trclos(itblabrh)
      call trclos(itblabr)
      call trclos(itvlabrh)
      call trclos(itvlabr)
      call trclos(itrtvlm)
      call trclos(itstns)
      call trclos(itresph)
      call trclos(itresp)
      call trclos(itsblockh)
      call trclos(itsblock)
      do i=numdicts,1,-1
        call trclos(itabrh(i))
        call trclos(itabr(i))
      enddo
      call trclos(itrttsr)
      call trclos(itrtblk)
      call trclos(itrtstn)
      return
      end
