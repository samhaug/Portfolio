c----------------------------------------------------------------
      subroutine savevol(fname,ntps,tps,ltps)
      character*(*) fname
      character*80 tps(*)
      dimension ltps(*)
      include 'seedparam.h'
      include 'seedcommun.h'
      include 'seedtrees.h'
      include '../libdb/dblib.h'
      character*60 tpnm
      common/tapenm/ltpnm,tpnm
      character*60 name
      integer*4 iname(15)
      equivalence (name,iname)
      integer trread
      logical getabr,there,trfind
C     if(ltpnm.le.0) then
C       pause 'savevol: tape name undefined'
C     endif
      if(lvolblock.le.0) then
        pause 'savevol: volblock undefined'
      endif
      lfname=istlen(fname)
      call setabrn(itblabr,itblabrh,lsblabr,idblf,fname(1:lfname),tmpblk,ifblnew)
      do itp=1,ntps
        if(.not.getabr(itblabr,idblf,tmpblk,ltmp)) pause 'savevol: added blfile not found'
        there=.FALSE.
        nw=1
        knt=0
        do while(nw.gt.0)
          nw=trread(itblabr,iname,15)
          if(nw.gt.0) then
            knt=knt+1
            lname=istlen(name(1:4*nw))
            if(lname.eq.ltps(itp).and.tps(itp)(1:ltps(itp)).eq.name(1:lname)) then
              write(6,*) 'savevol found:'//tps(itp)(1:ltps(itp)),idblf,knt
              there=.TRUE.
              goto 10
            endif
          endif
        enddo
   10   continue
        if(.not.there) then
          name=tps(itp)(1:ltps(itp))
          lname=ltps(itp)
          nw=(lname+3)/4
          call trapnd(itblabr,iname,nw)
          write(6,*) 'savevol wrote:'//name(1:lname),idblf,knt+1
        endif
      enddo
      if(volblock(1:lvolblock).ne.'NOT READ') then
        call setabrn(itvlabr,itvlabrh,lsvlabr,idvolm,volblock(1:lvolblock),tmpblk,ifvnew)
        if(.not.getabr(itvlabr,idvolm,tmpblk,ltmp)) pause 'savevol: added abbreviation not found'
        if(trfind(itvlbl,idvolm,1,iok,ioi)) then
          if(ibig(ioi).ne.idblf) pause 'wrong blfile id found'
        else
          call traddk(itvlbl,idvolm,1,idblf,1)
        endif
      endif

      return
      end
