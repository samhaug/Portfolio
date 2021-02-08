      function nactive(itcldr,mscldr,mtcldr,itim1,itim2,iad,iad2)
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

      call balloc(1,iad2)
      iactv=0

      do i=1,nseen
        lstat=and(ibig(iad+(i-1)*(linfo+2)+2),CONTINUE)
        if(lstat.ne.STOP) then
          iactv=iactv+1
          call balloc(linfo+4,ia)
          ibig(ia)=itim1(1)
          lrest=or(and(ibig(iad+(i-1)*(linfo+2)+2),z'00000fff'),START)
          ibig(ia+1)=or(and(itim1(2),z'ffff0000'),lrest)
          ibig(ia+2)=z'7fffffff'
          ibig(ia+3)=0
          do j=0,linfo-1
            ibig(ia+4+j)=ibig(iad+(i-1)*(linfo+2)+3+j)
          enddo
        endif
      enddo
      do i=1,nseen1
        lstat=and(ibig(iad1+(i-1)*(linfo+2)+2),CONTINUE)
        if(lstat.eq.START) then
          iactv=iactv+1
          call balloc(linfo+4,ia)
          ibig(ia)=ibig(iad1+(i-1)*(linfo+2)+1)
          ibig(ia+1)=ibig(iad1+(i-1)*(linfo+2)+2)
          ibig(ia+2)=z'7fffffff'
          ibig(ia+3)=0
          do j=0,linfo-1
            ibig(ia+4+j)=ibig(iad1+(i-1)*(linfo+2)+3+j)
          enddo
        else if(lstat.eq.STOP) then
          lrank=and(ibig(iad1+(i-1)*(linfo+2)+2),z'00000fff')
          do ja=1,iactv
            ia=iad2+(ja-1)*(linfo+4)+2
            if(ibig(ia+1).eq.z'7fffffff') then
              krank=and(ibig(ia),z'00000fff')
              if(krank.eq.lrank) then
                if(icmpky(ibig(ia+3),ibig(iad1+(i-1)*(linfo+2)+3),linfo).eq.0) then
                
                  ibig(ia+1)=ibig(iad1+(i-1)*(linfo+2)+1)
                  ibig(ia+2)=ibig(iad1+(i-1)*(linfo+2)+2)
                  goto 101
                endif
              endif
            endif
          enddo
          pause 'active: start not found for ending'
  101     continue
        endif

      enddo
      do ja=1,iactv
        ia=iad2+(ja-1)*(linfo+4)+2
        if(ibig(ia+1).eq.z'7fffffff') then
          ibig(ia+1)=itim2(1)
          lrest=or(STOP,and(ibig(ia),z'00000fff'))
          ibig(ia+2)=or(lrest,and(itim2(2),z'ffff0000'))
        endif
      enddo
      ibig(iad2)=iactv
      call dalloc(1+iactv*(linfo+4),iad2)
      call dalloc(1+nseen1*(linfo+2),iad1)
      call dalloc(1+nseen*(linfo+2),iad)
      nactive=iactv
      return
      end
