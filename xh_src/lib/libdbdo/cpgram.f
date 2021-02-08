
c----------------------------------------------------------------

      subroutine cpgram(gramsrc,gram,ifstat,iflap,ierr)
      character*(*) gramsrc,gram
      include 'gramdb.h'
      include '../libdb/dblib.h'
      dimension key7(7),key8(8)
      character*28 ckey7
      equivalence (key7,ckey7)
      logical trfind,trnext,same
      integer trread2,trreadl,opengram
      
      lgram=istlen(gram)
      iadgtr=opengram(gram(1:lgram),ifstat,iflap,ierr)
      if(ierr.ne.0) then
        write(6,*) 'cpgram: cannot open destination file'
        return
      endif


      iadgsr=opengram(gramsrc,0,1,ierr)
      if(ierr.ne.0) then
        write(6,*) 'cpgram: opengram failed'
        return
      endif
      key7(1)='80000000'x
      if(trfind(ibig(iadgsr+OGHTGS),key7,7,iok,ioi)) pause 'cpgram:small found'
      do while(trnext(ibig(iadgsr+OGHTGS),1,iok,ioi))
        do i=1,7
          key7(i)=ibig(iok+i-1)
        enddo
        call openchngk(iadgsr,ckey7,0,ierr)
        if(ierr.ne.0) then
          write(6,*) 'cpgram: openchngk failed'
          return
        endif
        key8(1)='80000000'x
        if(trfind(ibig(iadgsr+OGHTCG),key8,8,iok,ioi)) pause 'cpgram: small found'
        do while(trnext(ibig(iadgsr+OGHTCG),1,iok,ioi))
          do i=1,8
            key8(i)=ibig(iok+i-1)
          enddo
          nwords=trreadl(ibig(iadgsr+OGHTCG),ludum,iabyt)
          call balloc(nwords+2,ia)
          nsamp=trread2(ibig(iadgsr+OGHTCG),ibig(ia),nwords+2)
          call byswap4(ibig(ia),nwords)

          call openchngk(iadgtr,ckey7,iflap,ierr)
          if(trfind(ibig(iadgtr+OGHTCG),key8,8,iok,ioi)) then
            nwords1=trreadl(ibig(iadgtr+OGHTCG),ludum,iabyt)
            call balloc(nwords1+2,ia1)
            nsamp1=trread2(ibig(iadgtr+OGHTCG),ibig(ia1),nwords1+2)
            call byswap4(ibig(ia1),nwords1)
            same=.TRUE.
            if(nsamp1.eq.nsamp) then
              do i=0,nsamp-1
                if(ibig(ia+i).ne.ibig(ia1+i)) same=.FALSE.
              enddo
            else
              same=.FALSE.
            endif
            call dalloc(nwords1+2,ia1)
            if(.not.same) then
              write(6,*) 'savegram: Inconsistent data (overwritten)'
              if(.not.trfind(ibig(iadgtr+OGHTCG),key8,8,iok,ioi)) pause 'savegram: key not found'
              call trwrit2(ibig(iadgtr+OGHTCG),ibig(ia),nsamp)
            else
              write(6,*) 'cpgram: Identical duplicate data'
            endif
          else
            call traddk(ibig(iadgtr+OGHTCG),key8,8,idummy,0)
            if(.not.trfind(ibig(iadgtr+OGHTCG),key8,8,iok,ioi)) pause 'savegram: key not found'
            call trwrit2(ibig(iadgtr+OGHTCG),ibig(ia),nsamp)
          endif
          call closechng(iadgtr)
          call dalloc(nwords+2,ia)
        enddo
        call closechng(iadgsr)
      enddo
      call closegram(iadgsr)

      call closegram(iadgtr)

      return
      end
