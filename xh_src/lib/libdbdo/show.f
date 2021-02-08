      
c----------------------------------------------------------
      subroutine show(patt,lpatt,npatt,ifsb,ifdump,ierr)
      character*32 patt(*)
      dimension lpatt(*)
      character*3 cod
      character*10 str10
      character*200 strout
      character*4 str4
      equivalence (str4,istr4)

      include 'cbufcm.h'
      include 'seeddefs.h'
      include 'seedtrees.h'
      character*60 name
      integer*4 iname(15)
      equivalence (name,iname)
      integer trread
      logical getabr
      character*2 fl,fl1
      lencbuf=len(cbuf)
      ierr=0
      ifo=1
      if(ifdump.eq.80) ifo=80
      do ipatt=1,npatt
        fl=patt(ipatt)(1:2)
        fl1=fl
        if(fl.eq.'si') fl1='sb'
        if(fl.eq.'sc') fl1='cd'
        if(fl.eq.'ci') fl1='sb'
        if(fl.eq.'cc') fl1='cd'
        ip2=lpatt(ipatt)
        ip1=ip2
        do while(ip1.gt.0.and.patt(ipatt)(ip1:ip1).ne.'.')
          ip1=ip1-1
        enddo
        ip1=1+ip1
        if(ip1.lt.4) then
          write(6,*) 'show: Invalid item format'
          ierr=9
          return
        endif
        str10=' '
        str10(10-ip2+ip1:10)=patt(ipatt)(ip1:ip2)
        if(ifdump.ge.0) then
          open(66,file=patt(ipatt)(1:ip2))
          write(6,*) 'File: '//patt(ipatt)(1:ip2)
          lu=66
        else
          lu=6
        endif
        read(str10,"(i10)") iblock
        if(fl1.eq.'sb') then
          call getblkt(itsblock,iblock,cod,itp,cbuf,lcbuf,ierr)
          if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(8:lcbuf),ifo,2)
        else if(fl1.eq.'cr') then
          if(getabr(itresp,iblock,cbuf,lcbuf)) then
            k=1
            is=0
            do while(k.lt.lcbuf)
              str4=cbuf(k:k+3)
              if(ifsb.ge.0) then
                write(str10,"(i10)") istr4
                ip=1
                do while(str10(ip:ip).eq.' ')
                  ip=ip+1
                enddo
                strout(is+1:is+15-ip)=' sb.'//str10(ip:10)
                is=is+15-ip
                if(is.gt.200) pause 'too many responses'
              else
                call getblkt(itsblock,istr4,cod,itp,cbuf(lcbuf+1:lencbuf),lcbuf1,ierr)
                if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(lcbuf+8:lcbuf+lcbuf1),ifo,2)
              endif
              k=k+4
            enddo
            if(ifsb.ge.0) write(lu,*) strout(2:is)
          else
            write(6,*) 'Item not found'
            ierr=9
          endif
        else if(fl1.eq.'ud') then
          call getblkt(itabr(DICTUT),iblock,cod,itp,cbuf,lcbuf,ierr)
          if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(8:lcbuf),ifo,2)
        else if(fl1.eq.'fd') then
          call getblkt(itabr(DICTFT),iblock,cod,itp,cbuf,lcbuf,ierr)
          if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(8:lcbuf),ifo,2)
        else if(fl1.eq.'cd') then
          call getblkt(itabr(DICTCT),iblock,cod,itp,cbuf,lcbuf,ierr)
          if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(8:lcbuf),ifo,2)
        else if(fl1.eq.'gd') then
          call getblkt(itabr(DICTGC),iblock,cod,itp,cbuf,lcbuf,ierr)
          if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(8:lcbuf),ifo,2)
        else if(fl1.eq.'rd') then
          call getblkt(itabr(DICTRE),iblock,cod,itp,cbuf,lcbuf,ierr)
          if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(8:lcbuf),ifo,2)
        else if(fl1.eq.'sd') then
          call getblkt(itabr(DICTCD),iblock,cod,itp,cbuf,lcbuf,ierr)
          if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(8:lcbuf),ifo,2)
        else if(fl1.eq.'bd') then
          call getblkt(itabr(DICTBM),iblock,cod,itp,cbuf,lcbuf,ierr)
          if(ierr.eq.0) call wrtblk(lu,cod,itp,cbuf(8:lcbuf),ifo,2)
        else if(fl1.eq.'vl') then
          if(.not.getabr(itvlabr,iblock,cbuf,lcbuf)) then
            write(6,*) 'Volume abbreviation not found'
            ierr=9
          else
            nw=1
            knt=0
            do while(nw.gt.0)
              nw=trread(itvlabr,iname,15)
              if(nw.gt.0) then
                knt=knt+1
                lname=istlen(name(1:4*nw))
                write(lu,*) '[Tape:'//name(1:lname)//']'
              endif
            enddo
            call wrtblk(lu,'010',STPV,cbuf(1:lcbuf),ifo,2)
          endif
        else
          write(6,*) 'Unknown item prefix'
          ierr=9
        endif
        if(lu.eq.66) close(lu)
      enddo


      return
      end
