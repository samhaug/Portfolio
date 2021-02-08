      subroutine closemem()
      common/memblk/istmem,imemln
      if(imemln.eq.0) then
        return
      else
        call dalloc(imemln,istmem)
      endif
      imemln=0
      return
      end

