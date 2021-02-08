
      logical function trdrnx(itre,patt,iok,ioi)
      include "dblib.h"
      character*(*) patt
      character*1 ch,chr
      logical trnext,more
      lkey=ibig(itre+OTRLK)
      lpatt=len(patt)
      do while(lpatt.gt.0.and.patt(lpatt:lpatt).eq.' ')
        lpatt=lpatt-1
      enddo
c ! false return
   20 if(.not.trnext(itre,1,iok,ioi)) goto 100
      ic=0
      ik=0
      mode=0
      more=.FALSE.
      do while (.TRUE.)
        if(ic.ge.lpatt) then
          if(mode.eq.1) goto 101
          do i=ik,lkey*4-1
            chr=char(and(ishft4(ibig(iok+i/4),(mod(i,4)-3)*8),z'FF'))
c ! no match
            if(chr.ne.' ') goto 102
          enddo
          goto 101
        endif
c ! no match
        if(ik/4.ge.lkey) goto 102
        ichr=and(ishft4(ibig(iok+ik/4),(mod(ik,4)-3)*8),z'FF')
        ch=patt(ic+1:ic+1)
        ich=ichar(ch)
        if(ch.ne.'?'.and.ch.ne.'*') then
          if(mode.eq.1) mode=2
          if(ichr.ne.ich) then
            if(mode.eq.0) goto 102
            ik0=1+ik0
            ik=ik0
            ic=ic0
          else
            ic=1+ic
            ik=1+ik
          endif
        else if(ch.eq.'?') then
          more=.TRUE.
          if(mode.eq.1) mode=2
          if(ichr.eq.z'20') then
            if(mode.eq.0) goto 102
            ik0=1+ik0
            ik=ik0
            ic=ic0
          else
            ic=1+ic
            ik=1+ik
          endif
        else if(ch.eq.'*') then
          more=.TRUE.
          mode=1
          ic=ic+1
          ik0=ik
          ic0=ic
        endif
      enddo
  102 continue
      if(more) goto 20
  100 continue
      trdrnx=.FALSE.
      return
  101 continue
      trdrnx=.TRUE.
      return
      end
