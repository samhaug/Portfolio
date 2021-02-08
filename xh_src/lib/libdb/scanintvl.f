c-------------------------------------------------------------------
      subroutine scanintvl(itcldr,mscldr,mtcldr,itim1,itim2,isw,iad)
      integer*4 itim1(2),itim2(2),jtim(2)
      include 'dblib.h'
      logical x,getcldr0,trfind,trnext
      integer*4 START,STOP,CONTINUE
      parameter(STOP=z'00004000',START=z'00008000',CONTINUE=z'0000c000')
      linfo=ibig(itcldr+OTRLI)
      x=getcldr0(itcldr,mscldr,mtcldr,itim1,-1,iok,ioi,isw,iad)
      nseen=ibig(iad)
      call balloc(1+nseen*(linfo+2),iad)
      call balloc(1,iad1)
      nseen1=0
      ibig(iad1)=0
      jtim(1)=itim1(1)
      jtim(2)=or(itim1(2),z'0000ffff')
      if(trfind(itcldr,jtim,2,iok,ioi)) 
     1     pause 'getcldr0: key with extreme rank and status found'
      do while(trnext(itcldr,1,iok,ioi))
        if(itcmp(ibig(iok),itim2).ge.0) goto 99
        kstat=and(ibig(iok+1),CONTINUE)
        if(kstat.ne.CONTINUE) then
          krank=and(ibig(iok+1),z'00000fff')
          nseen1=nseen1+1
          call balloc(linfo+2,ia)
          ibig(ia)=ibig(iok)
          ibig(ia+1)=ibig(iok+1)
          do i=0,linfo-1
            ibig(ia+2+i)=ibig(ioi+i)
          enddo
        endif
      enddo
   99 continue
      ibig(iad1)=nseen1
      call dalloc(1+nseen1*(linfo+2),iad1)
      call dalloc(1+nseen*(linfo+2),iad)
      return
      end
