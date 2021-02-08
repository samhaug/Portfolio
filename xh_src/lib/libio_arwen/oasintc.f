      subroutine oasintc(num)
      include 'oasstat.h'
      interc=num
      call csetintc(interc)
      return
      end
