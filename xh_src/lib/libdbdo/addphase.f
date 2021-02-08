      subroutine addphase(lu,delim)
      character*1 delim
      include '../libdb/dblib.h'
      common/memblk/istmem,imemln
      

      include 'phstable.h'
      data nphase/0/,phsdel1/0./,phsdel2/1000./
      call balloc(1,io)
      call dalloc(1,io)
      if(imemln.eq.0) then
        istmem=io
      else
        if(istmem+imemln.ne.io) stop 'addphase: Memory problem'
      endif
      nphase=nphase+1
      ll=loadphs(lu,ibig(io),ibig(io),delim,ltalloc(),0)
      call balloc(ll,iphaddr(nphase))
      write(phasenm(nphase),'(8a4)') (ibig(iphaddr(nphase)+i),i=0,7)
      write(6,*) 'addphase: added:'//phasenm(nphase)
      imemln=imemln+ll
      return
      end

