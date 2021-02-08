c-----------------------------------------------
      subroutine getblkt(itabr,ind,cod,itp,cbuf,lcbuf,ierr)
      character*(*) cbuf
      character*3 cod
      include 'seeddefs.h'
      character*200 mess
      character*10 form
      logical getabr
      ierr=0
      if(getabr(itabr,ind,cbuf,lcbuf)) then
        cod=cbuf(1:3)
        itp=ifindtyp(cod,indcd)
        read(cbuf(4:7),"(i4)") lblock
        if(lcbuf.ne.lblock) pause 'getblkt: wrong block length'
        if(itp.eq.STPA) then
          ient=0
          k=0
   10     continue
          kl=k
          call getfield(cod,itp,cbuf(8:lblock),k
     1     ,indcd,ient,ileve,mess,lmess,icdstat)
          if(ient.lt.0) goto 20
          if(ient.eq.0) goto 10
          itest=(entstat(ient,indcd)/MXDICTS)*MXDICTS
          if(itest.eq.INSERT) then
            form='('//fstr(ient,indcd)//')'
            write(mess,form) ind
            do i=1,lmess
              if(mess(i:i).eq.' ') mess(i:i)='0'
            enddo
            cbuf(7+kl:6+kl+lmess)=mess(1:lmess)
          endif
          goto 10
   20     continue
        endif
      else
        write(6,*) 'getblkt: Entry not found'
        ierr=9
        lcbuf=0
        itp=0
        cod='   '
      endif
      return
      end

