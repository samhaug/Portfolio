      logical function gmatch(patt,lpatt,str,lstr)
      character*(*) patt,str
      character*1 c
      character*100 apatt
      parameter (NSTACK=5)
      logical quoted,pmatch,sincequote,lstack(NSTACK)
      lstack(1)=.FALSE.
      quoted=.FALSE.
      ip=0
      ka=0
   10 ip=ip+1
      if(ip.gt.lpatt) then
        if(ip.gt.lpatt+1) goto 90
        c='^'
      else
        c=patt(ip:ip)
      endif
      if((c.eq.'^'.or.c.eq.'|'.or.c.eq.'&'.or.c.eq.'~').and..not.quoted) then
        if(ka.gt.0) then
          do i=NSTACK,2,-1
            lstack(i)=lstack(i-1)
          enddo
          lstack(1)=pmatch('*'//apatt(1:ka)//'*',ka+2,str,lstr)
        endif
        ka=0

        if(c.eq.'|') then
          lstack(1)=lstack(1).or.lstack(2)
          do i=2,NSTACK-1
            lstack(i)=lstack(i+1)
          enddo
        else if(c.eq.'~') then
          lstack(1)=.not.lstack(1)
        else if(c.eq.'&') then
          lstack(1)=lstack(1).and.lstack(2)
          do i=2,NSTACK-1
            lstack(i)=lstack(i+1)
          enddo
        endif
      else if(c.eq.''''.and..not.quoted) then
        quoted=.not.quoted
        sincequote=.FALSE.
      else if(c.eq.''''.and.quoted) then
        quoted=.not.quoted
        if(.not.sincequote) then
          ka=ka+1
          apatt(ka:ka)=''''
        endif
        sincequote=.TRUE.
      else
        ka=ka+1
        apatt(ka:ka)=c
        sincequote=.TRUE.
      endif
      goto 10
   90 continue
      gmatch=lstack(1)
      return
      end
