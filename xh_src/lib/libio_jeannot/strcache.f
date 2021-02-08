      subroutine strcache(str,k1str,k2str)
      character*(*) str
      include 'catbuf.h'
      lstr=len(str)
      ilctbf=ilctbf+1
      if(ilctbf.gt.MXCSTR) then
         write(0,'(a)') 'strcache: Too many cached strings'
         call exit(2)
      endif
      ipinit(ilctbf)=ipctbf
      k1str=ipctbf+1
      k2str=ipctbf+lstr
      if(k2str.gt.MXCTBF) then
        write(0,'(a)') 'strcache: Space exceeded'
        call exit(2)
      endif
      ctbf(k1str:k2str)=str
      ipctbf=k2str
      return
      end

c---------------------------------------------------

      subroutine struncache(str,k1str,k2str)
      character*(*) str
      include 'catbuf.h'
      lstr=len(str)
      if(ctbf(k1str:k2str).ne.str) str=ctbf(k1str:k2str)
      ipctbf=ipinit(ilctbf)
      ilctbf=ilctbf-1
      if(ilctbf.lt.0) then
        write(0,'(a)') 'struncache: Negative level'
        call exit(2)
      endif
      return
      end

c---------------------------------------------------

      block data catbufinit
      include 'catbuf.h'
      data ipctbf/0/,ilctbf/0/
      end














