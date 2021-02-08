

c-------------------------------------------------------------------
      integer function trread(itre,ibuf,maxbuf)
      include "dblib.h"
      dimension ibuf(*)
      la=ibig(itre+OTRKO)
      ilev=ibig(itre+OTRLV)
      lkey=ibig(itre+OTRLK)
      linfo=ibig(itre+OTRLI)
      lres=ibig(itre+OTRNR)
      iptha=ibig(itre+OTRPA)+ilev
      ikeya=ibig(itre+OTRKY)+ilev
      istak=ibig(itre+OTRST)
      if(ibig(iptha).lt.0) pause 'trread: no current key'
      lux=ibig(itre+OTRUX)
      obotol=ibig(istak+OSTBM)
      call stakgt(istak,ibig(iptha),ibrec)
      obotnw=ibig(istak+OSTBM)
      if(obotnw.ne.obotol) pause 'trread: not working as expected'
      k=ibrec+2+ibig(ikeya)*la+lres+lkey+linfo
      if(lux.gt.0) then
        iend=lenlu(lux)
c ! get info from entry
        if(ibig(itre+OEXCH).lt.0) then
c ! nothing to read
          if(ibig(k+OEXAD).lt.0) then
            trread=0
            return
c ! find first record
          else
            ianex=ibig(k+OEXAD)
            nwnex=ibig(k+OEXLN)
          endif
c ! use info from last read
        else
c ! or write
          ianex=ibig(itre+OEXFP)
          nwnex=ibig(itre+OEXNW)
        endif
        nwords=nwnex
        call balloc(nwords+2,iscr)
        call bffi(lux,1,ibig(iscr),(nwords+2)*4,j,m,ianex+1)
        if(nwords.gt.maxbuf) pause 'trread: buffer space exceeded'
        call byswap4(ibig(iscr+nwords),2)
        do i=0,nwords-1
          ibuf(i+1)=ibig(iscr+i)
        enddo
c ! chaining address
        ibig(itre+OEXCH)=ianex+nwords*4
c ! and ptr to next
        ibig(itre+OEXFP)=ibig(iscr+nwords)
c ! and length of next
        ibig(itre+OEXNW)=ibig(iscr+nwords+1)
        trread=nwords
        call dalloc(nwords+2,iscr)
      else
        pause 'trread: attempt to read from a non extendable entry'
        trread=0
      endif
      return
      end
