


c-------------------------------------------------------------------
      function maxrank(itcldr,mscldr,mtcldr,itim1,itim2,low,iad)
      integer*4 itim1(2),itim2(2)
      include 'dblib.h'
      integer*4 START,STOP,CONTINUE
      parameter(STOP=z'00004000',START=z'00008000',CONTINUE=z'0000c000')
      linfo=ibig(itcldr+OTRLI)
      call scanintvl(itcldr,mscldr,mtcldr,itim1,itim2,-1,iad)

      nseen=ibig(iad)
      call balloc(1+nseen*(linfo+2),ia)
      call balloc(1,iad1)
      nseen1=ibig(iad1)
      call balloc(nseen1*(linfo+2),ia)

      call balloc(1,ioff)
      maxrank=0
      do i=1,nseen
        lstat=and(ibig(iad+(i-1)*(linfo+2)+2),CONTINUE)
        if(lstat.ne.STOP) then
          lrank=and(ibig(iad+(i-1)*(linfo+2)+2),z'00000fff')
          if(lrank.gt.maxrank) then
            call balloc(lrank-maxrank,id)
            if(id.ne.ioff+maxrank+1) pause 'maxrank: error 1'
            do j=1,lrank-maxrank
              ibig(id+j-1)=0
            enddo
            maxrank=lrank
          endif
          ibig(ioff+lrank)=1
        endif
      enddo
      do i=1,nseen1
        lstat=and(ibig(iad1+(i-1)*(linfo+2)+2),CONTINUE)
        lrank=and(ibig(iad1+(i-1)*(linfo+2)+2),z'00000fff')
        if(lrank.gt.maxrank) then
          call balloc(lrank-maxrank,id)
          if(id.ne.ioff+maxrank+1) pause 'maxrank: error 2'
          do j=1,lrank-maxrank
            ibig(id+j-1)=0
          enddo
          maxrank=lrank
        endif
        ibig(ioff+lrank)=1
      enddo

      low=0
      do i=1,maxrank
        if(ibig(ioff+i).eq.0) then
          low=i
          goto 201
        endif
      enddo
      low=maxrank+1
  201 continue

      call dalloc(1+maxrank,ioff)
      call dalloc(1+nseen1*(linfo+2),iad1)
      call dalloc(1+nseen*(linfo+2),iad)
      return
      end
