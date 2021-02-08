      subroutine abort (msg)
      character*(*) msg
      write(0,*) '!!! abort: ',msg
      call cabort()
      return
      end
