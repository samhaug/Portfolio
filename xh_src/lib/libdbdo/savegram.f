
c----------------------------------------------------------------
      subroutine savegram(iadgtr,station,netukey,locid,chn,sub,khertz,lfmt
     1     ,jys,jds,jhs,jms,fss   ,jye,jde,jhe,jme,fse
     1     ,ivol,ifil,irec,nrec,idata,ndata)
      character*5 station
      character*2 locid,locidr
      character*3 chn,chnr
      character*4 sub
      integer*4 idata(0:*)
C     dimension key(8)
      include '../libdb/dblib.h'
      include 'gramdb.h'
      dimension key(8)
      logical trfind,same
      integer trreadl,trread2

c create a rationalized channel reference
      chnr=chn
      locidr=locid
      if(chnr(3:3).eq.' ') then
        if(sub.ne.'0001'.and.sub.ne.'0002'.and.sub.ne.'0003') then
          pause 'savegram: unsupported channel name'
        else
          read(sub,"(i4)") isubr
        endif
      else
        if(chnr(3:3).eq.'Z') then
          chnr(3:3)=' '
          isubr=1
        else if(chnr(3:3).eq.'N') then
          chnr(3:3)=' '
          isubr=2
        else if(chnr(3:3).eq.'E') then
          chnr(3:3)=' '
          isubr=3
        else if(chnr(3:3).eq.'U'.and.locidr.eq.'  ') then
          chnr(3:3)=' '
          isubr=1
          locidr='A '
        else if(chnr(3:3).eq.'V'.and.locidr.eq.'  ') then
          chnr(3:3)=' '
          isubr=2
          locidr='A '
        else if(chnr(3:3).eq.'W'.and.locidr.eq.'  ') then
          chnr(3:3)=' '
          isubr=3
          locidr='A '
        else if(chnr(3:3).eq.'F'.and.locidr.eq.'  ') then
          chnr(3:3)=' '
          isubr=1
          locidr='C '
        else if(chnr(3:3).eq.'G'.and.locidr.eq.'  ') then
          chnr(3:3)=' '
          isubr=2
          locidr='C '
        else if(chnr(3:3).eq.'H'.and.locidr.eq.'  ') then
          chnr(3:3)=' '
          isubr=3
          locidr='C '
        else if(chnr(3:3).eq.'1'.and.locidr.eq.'  ') then
          chnr(3:3)=' '
          isubr=2
          locidr='B '
        else if(chnr(3:3).eq.'2'.and.locidr.eq.'  ') then
          chnr(3:3)=' '
          isubr=3
          locidr='B '
        else if(chnr(2:2).eq.'Z') then
          chnr(2:2)=chnr(3:3)
          chnr(3:3)=' '
          isubr=1
        else if(chnr(2:2).eq.'N') then
          chnr(2:2)=chnr(3:3)
          chnr(3:3)=' '
          isubr=2
        else if(chnr(2:2).eq.'E') then
          chnr(2:2)=chnr(3:3)
          chnr(3:3)=' '
          isubr=3
        else if(chnr(3:3).eq.'O') then
          isubr=1
        else
          write(6,'(a)') 'savegram: Unclassifiable channel name: '//locidr//chnr//sub
c         pause 'savegram: unsupported channel name'
cqq       isubr=1
          write(6,*) 'Set to 2'
          isubr=2
        endif
        if(sub.ne.'0000'.and.sub.ne.'0001') pause 'savegram: unusual channel name'
      endif

      read(sub,"(i4)") isub
      iflap=4
cxy   write(6,*) 'savegram: A ibig(25729)=',ibig(25729)
      call openchng(iadgtr,station,netukey,locidr,chnr,isubr,khertz,locid,chn,isub,lfmt,iflap)
cxy   write(6,*) 'openchng', station,netukey,locidr,chnr,isubr,iadgtr
cxy   write(6,*) 'savegram: B ibig(25729)=',ibig(25729)

      call timsec(jys,jds,jhs,jms,fss,key(1))
      it=10000*amod(fss,1.0)
      key(2)=ishft(it,16)
      call timsec(jye,jde,jhe,jme,fse,key(3))
      it=10000*amod(fse,1.0)
      key(4)=ishft(it,16)
      key(5)=ivol
      key(6)=ifil
      key(7)=irec
      key(8)=nrec
      if(trfind(ibig(iadgtr+OGHTCG),key,8,iok,ioi)) then
        nwords=trreadl(ibig(iadgtr+OGHTCG),ludum,iabyt)
        call balloc(nwords+2,ia)
        nsamp=trread2(ibig(iadgtr+OGHTCG),ibig(ia),nwords+2)
        same=.TRUE.
        if(nsamp.eq.ndata) then
          do i=0,nsamp-1
            if(idata(i).ne.ibig(ia+i)) same=.FALSE.
          enddo
        else
          same=.FALSE.
        endif
        call dalloc(nwords+2,ia)
        if(.not.same) then
          write(6,*) 'savegram: Inconsistent data (overwritten)'
        else
          write(6,*) 'savegram: Identical duplicate data'
cxy   write(6,*) 'savegram: C ibig(25729)=',ibig(25729)

          call closechng(iadgtr)
          return
        endif
      else
cxy   write(6,*) 'savegram: aD ibig(25729)=',ibig(25729)
        call traddk(ibig(iadgtr+OGHTCG),key,8,idummy,0)
cxy   write(6,*) 'savegram: bD ibig(25729)=',ibig(25729)
      endif
      if(.not.trfind(ibig(iadgtr+OGHTCG),key,8,iok,ioi)) pause 'savegram: key not found'
cxy   write(6,*) 'savegram: cD ibig(25729)=',ibig(25729)

      call byswap4(idata(0),ndata)
cxy   write(6,*) 'savegram: mD ibig(25729)=',ibig(25729),ndata
      call trwrit2(ibig(iadgtr+OGHTCG),idata(0),ndata)
cxy   write(6,*) 'savegram: nD ibig(25729)=',ibig(25729),ndata
      call byswap4(idata(0),ndata)
cxy   write(6,*) 'savegram: D ibig(25729)=',ibig(25729)

      call closechng(iadgtr)
cxy   write(6,*) 'closechng', iadgtr
      return
      end
