      subroutine showmem(str,lu)
      character*(*) str
      save lasta
      iad=malloc(1048576)
c     if(iad.ne.lasta) then
        write(lu,'(a,2i11)') str,iad,iad-lasta
        lasta=iad
c     endif
      call free(iad)
      return
      end


