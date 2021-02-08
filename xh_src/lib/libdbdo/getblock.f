      subroutine getblock(code,cod,inum,cbuf,maxch,itp)
      character*(*) code,cod
      character*(*) cbuf
      include 'seedbuf.h' 
c! we need to know lrec to find out if we are reading an ascii file
      if(lrec.eq.0) then
        call getblocka(code,cod,inum,cbuf,maxch,itp,ifunab)
      else 
        ifunab=0
        call getblockb(code,cod,inum,cbuf,maxch,itp)
      endif
      return
      end
