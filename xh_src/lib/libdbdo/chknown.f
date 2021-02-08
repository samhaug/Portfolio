c---------------------------------------------------------------
      subroutine chknown()
      include 'seeddefs.h'
      include 'seedtrees.h'
      include 'cbufcm.h'
      logical getabr
      locunc(0)=0
      id=1
      do while(getabr(itabr(DICTUT),id,cbuf,lcbuf))
        lunt=0
        do i=1,nknowu
          if(cbuf(11:lcbuf).eq.uknown(iknowu(i):iknowu(i+1)-1))  then
            if(lunt.eq.0) then
              lunt=locukn(i)
            else
              pause 'chknown: duplicate known unit'
            endif
          endif
        enddo
        if(lunt.eq.0) then
          write(6,*) '*** Unknown unit ***'
          call wrtblk(6,cbuf(1:3),STPA,cbuf(8:lcbuf),1,0)
        else
        endif
        if(id.gt.MXDBUNTS) pause 'too many units'
        locunc(id)=lunt
        id=id+1
      enddo
      id=1
      do while(getabr(itabr(DICTFT),id,cbuf,lcbuf))
        lfmt=0
        io=7
        do while(cbuf(io:io).ne.'~')
          io=io+1
        enddo
        io=io+4
        do i=1,nknown
          if(cbuf(io+1:lcbuf).eq.fknown(iknow(i):iknow(i+1)-1))  then
            if(lfmt.eq.0) then
              lfmt=locfkn(i)
            else
              pause 'chknown: duplicate known format'
            endif
          endif
        enddo
        if(lfmt.eq.0) then
          write(6,*) '*** Unknown format ***'
          call wrtblk(6,cbuf(1:3),STPA,cbuf(8:lcbuf),1,0)
        else
c         write(6,*) 'Known format:',lfmt
c         call wrtblk(6,cbuf(1:3),STPA,cbuf(8:lcbuf),1,0)
        endif
        if(id.gt.MXDBFMTS) pause 'too many formats'
        locfmc(id)=lfmt
        id=id+1
      enddo
      return
      end
