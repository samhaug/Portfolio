      subroutine oasspace(volume,kb,ierr)
      character*(*) volume
      character*132 mess
      character*160 cat3s,buf
      ierr=0
      call oasopen()
      buf=cat3s('stat/vol/typ=1 ',volume,';',lbuf)
      call oassend(buf(1:lbuf),mess,lmess,-1)
      read(mess(1:lmess),*,iostat=ie) kb
      if(ie.ne.0) then
        write(0,'(a)') mess(1:lmess)
        ierr=9
      endif
      call oasclose()
      return
      end
