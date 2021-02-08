c--------------------------------------------------------------------
      subroutine setcldr(itcldr,mscldr,mtcldr,itim1,itim2,key,lkey,irank)
      integer*4 itim1(2),itim2(2),key(*)
      include 'dblib.h'
      integer*4 START,STOP,CONTINUE
      parameter(STOP=z'00004000',START=z'00008000',CONTINUE=z'0000c000')
      logical trfind,trnext,add,getcldr0,sametime,samekeys,thru,check,clear
      integer*4 jtim(2),ktim(2)
      if(itcmp(itim1,itim2).ne.-1) pause 'setcldr: invalid times'
      if(key(1).le.0) then
        clear=.TRUE.
      else
        clear=.FALSE.
      endif
      if(.not.clear) then
        if(itim2(1).ne.z'7fffffff') then
          if(itim2(1)+1.gt.mtcldr) then
            call mtextnd(itcldr,mscldr,mtcldr,itim2)
          endif
        else
          if(itim1(1)+1.gt.mtcldr) then
            call mtextnd(itcldr,mscldr,mtcldr,itim1)
          endif
        endif
        if(irank.eq.-1) then
          irank=1+maxrank(itcldr,mscldr,mtcldr,itim1,itim2,low,iad)
        else if(irank.eq.-2) then
          mm=maxrank(itcldr,mscldr,mtcldr,itim1,itim2,irank,iad)
        else if(irank.eq.-3) then
          irank=matchrank(itcldr,mscldr,mtcldr,itim1,itim2,key,lkey,iad,iad2)
        endif
      endif
      if(getcldr0(itcldr,mscldr,mtcldr,itim1,-1,iok,ioi,irank,iad)) then
        kstat=and(ibig(iok+1),CONTINUE)
        sametime=itcmp(itim1,ibig(iok)).eq.0
        samekeys=icmpky(ibig(ioi),key,lkey).eq.0.and..not.clear
        call balloc(lkey,iadk)
        do i=0,lkey-1
          ibig(iadk+i)=ibig(ioi+i)
        enddo
        check=.FALSE.
        if(sametime) then
          if(kstat.eq.CONTINUE) then
            if(samekeys) then
              add=.FALSE.
            else
              call trdelk(itcldr)
              add=.TRUE.
            endif
          else if(kstat.eq.START) then
            if(.not.samekeys) then
              if(clear) then
                call trdelk(itcldr)
              else
                do i=1,lkey
                  ibig(ioi+i-1)=key(i)
                enddo
                call trtuch(itcldr)
                check=.TRUE.
              endif
            endif
            add=.FALSE.
          else
            pause 'unexpected kstat'
          endif
        else
          if(samekeys) then
            add=.FALSE.
          else
            add=.TRUE.
          endif
        endif
        if(add) then
          jtim(1)=itim1(1)
          jtim(2)=or(or(and(itim1(2),z'ffff0000'),STOP),irank)
          if(trfind(itcldr,jtim,2,iok,ioi)) pause 'unexpected 0'
          call traddk(itcldr,jtim,2,ibig(iadk),lkey)
        endif
        call dalloc(lkey,iadk)
      else
        add=.TRUE.
        check=.TRUE.
      endif

      if(add.and..not.clear) then
        jtim(1)=itim1(1)
        jtim(2)=or(or(and(itim1(2),z'ffff0000'),START),irank)
        if(trfind(itcldr,jtim,2,iok,ioi)) pause 'unexpected 1'
        call traddk(itcldr,jtim,2,key,lkey)
      endif

      if(check) then
        if(getcldr0(itcldr,mscldr,mtcldr,itim1,1,iok,ioi,irank,iad)) then
          if(itcmp(itim1,ibig(iok)).ne.0) pause 'unexpected 9'
          if(icmpky(ibig(ioi),key,lkey).eq.0) then
            call trdelk(itcldr)
            jtim(1)=itim1(1)
            jtim(2)=or(or(and(itim1(2),z'ffff0000'),START),irank)
            if(.not.trfind(itcldr,jtim,2,iok,ioi)) pause 'unexpected 10'
            call trdelk(itcldr)
          endif
        endif
      endif


      jtim(1)=itim1(1)
      jtim(2)=or(itim1(2),z'0000ffff')
      if(trfind(itcldr,jtim,2,iok,ioi)) pause 'unexpected 2'
      thru=.FALSE.
      do while(trnext(itcldr,1,iok,ioi).and..not.thru)
        if(itcmp(ibig(iok),itim2).lt.0) then
          if(and(ibig(iok+1),z'00000fff').eq.irank) then
            call trdelk(itcldr)
          endif
        else
          thru=.TRUE.
        endif
      enddo


      if(getcldr0(itcldr,mscldr,mtcldr,itim2,1,iok,ioi,irank,iad)) then
        kstat=and(ibig(iok+1),CONTINUE)
        sametime=itcmp(itim2,ibig(iok)).eq.0
        samekeys=icmpky(ibig(ioi),key,lkey).eq.0.and..not.clear
        call balloc(lkey,iadk)
        do i=0,lkey-1
          ibig(iadk+i)=ibig(ioi+i)
        enddo
        check=.FALSE.
        if(sametime) then
          if(kstat.eq.CONTINUE) then
            if(samekeys) then
              add=.FALSE.
            else
              call trdelk(itcldr)
              add=.TRUE.
            endif
          else if(kstat.eq.STOP) then
            if(.not.samekeys) then
              if(clear) then
                call trdelk(itcldr)
              else
                do i=1,lkey
                  ibig(ioi+i-1)=key(i)
                enddo
                call trtuch(itcldr)
                check=.TRUE.
              endif
            endif
            add=.FALSE.
          else
            pause 'unexpected kstat'
          endif
        else
          if(samekeys) then
            add=.FALSE.
          else
            add=.TRUE.
          endif
        endif
        if(add) then
          jtim(1)=itim2(1)
          jtim(2)=or(or(and(itim2(2),z'ffff0000'),START),irank)
          if(trfind(itcldr,jtim,2,iok,ioi)) pause 'unexpected 3'
          call traddk(itcldr,jtim,2,ibig(iadk),lkey)
        endif
        call dalloc(lkey,iadk)
      else
        add=.TRUE.
        check=.TRUE.
      endif

      if(add.and..not.clear) then
        jtim(1)=itim2(1)
        jtim(2)=or(or(and(itim2(2),z'ffff0000'),STOP),irank)
        if(trfind(itcldr,jtim,2,iok,ioi)) pause 'unexpected 4'
        call traddk(itcldr,jtim,2,key,lkey)
      endif

      if(check.and.itim2(1).ne.z'7fffffff') then
        if(getcldr0(itcldr,mscldr,mtcldr,itim2,-1,iok,ioi,irank,iad)) then
          if(itcmp(itim2,ibig(iok)).ne.0) then
            write(6,"(4z10)") itim2(1),itim2(2),ibig(iok),ibig(iok+1)
            pause 'unexpected 11'
          endif
          if(icmpky(ibig(ioi),key,lkey).eq.0) then
            call trdelk(itcldr)
            jtim(1)=itim2(1)
            jtim(2)=or(or(and(itim2(2),z'ffff0000'),STOP),irank)
            if(.not.trfind(itcldr,jtim,2,iok,ioi)) pause 'unexpected 12'
            call trdelk(itcldr)
          endif
        endif
      endif

      if(mscldr.ne.0.and..not.clear) then
        if(getcldr0(itcldr,mscldr,mtcldr,itim2,1,iok,ioi,irank,iad)) then
          ktim(1)=ibig(iok)
          ktim(2)=ibig(iok+1)
          if(ktim(1).eq.z'7fffffff') then
            ktim(1)=mtcldr
            ktim(2)=0
          endif
          if(icmpky(ibig(ioi),key,lkey).ne.0) pause 'unexpected 25'

          if(getcldr0(itcldr,mscldr,mtcldr,itim1,-1,iok,ioi,irank,iad)) then
            jtim(1)=ibig(iok)+mscldr
            jtim(2)=or(ibig(iok+1),CONTINUE)
            if(icmpky(ibig(ioi),key,lkey).ne.0) pause 'unexpected 23'
            do while(itcmp(jtim,ktim).lt.0)
              if(trfind(itcldr,jtim,2,iok,ioi)) then
                if(icmpky(ibig(ioi),key,lkey).ne.0) then
                  do i=1,lkey
                    ibig(ioi+i-1)=key(i)
                  enddo
                  call trtuch(itcldr)
                endif
              else
                call traddk(itcldr,jtim,2,key,lkey)
              endif
              jtim(1)=jtim(1)+mscldr
            enddo
          else
            pause 'setcldr: unexpected 21'
          endif
        endif
      endif
      return
      end
