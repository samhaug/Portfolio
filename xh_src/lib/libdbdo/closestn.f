c-----------------------------------------------------------

        subroutine closestn()
        include 'seeddefs.h'
        include 'seedtrees.h'
        if(itstn.eq.-1) return
        call closechn()
        call trclos(itsticl)
        call trclos(itstccl)
        call trclos(itchns)
        call trclos(itsttsr)
        call trclos(itstn)
        itstn=-1
        inetopen=0
        stnopen=' '
        return
        end
