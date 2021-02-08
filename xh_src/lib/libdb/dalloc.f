c-------------------------------------------------------------------

      subroutine dalloc(nwords,ioff)
      include "dblib.h"
      data maxbig/0/
      save maxbig
      maxbig=max0(nexbig,maxbig)
      nexbig=nexbig-nwords
      if(nexbig.ne.ioff) pause 'dalloc: freed space not at end'
      call flush(6)
      if(nexbig.eq.0) write(0,*) 'Maximum memory:',maxbig,' words'
c     write(6,*) 'dalloc:',nexbig
      return
      end
