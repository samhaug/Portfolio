      subroutine dchkdiff(phin,hdep,delta,phout,ierr)

      implicit double precision(a-h,o-z)

      character*(*) phin,phout

      common/delmxS/delmxsdep(50),delmxsdel(50),delmxsspl(50),
     1              delmnsels,delmxsels,ndelmxs
      common/delmxP/delmxpdep(50),delmxpdel(50),delmxpspl(50),
     1              delmnselp,delmxselp,ndelmxp
      common/iinitdelmx/iinitdelmxpar

c     data delmns/21/
c     data delmnp/24/
c     data delmnups/12/
c     data delmnupp/15/

      parameter(NPHS=16)
      character*20 phslist(NPHS),dumphs
      dimension lphslist(NPHS)
      data phslist/'P','PP','PPP','PPPP','PcP','Pdiff',
     1             'S','SS','SSS','SSSS','ScS','Sdiff',
     1             'pP','pPP','sS','sSS'/

      ierr=0
      if(hdep.gt.725.d0) then
       write(6,*) 'dchkdiff: event depth > 725'
       ierr=1
       return
      endif

      phout=''

      if(iinitdelmxpar.ne.999) then
c      write(6,*) 'initialising table for distinguishing direct and diff. waves'
       call dinitdelmx()
       iinitdelmxpar=999
      endif

c     find length of phases
      do i=1,NPHS
       lphslist(i)=istlen(phslist(i))
      enddo

      lphin=istlen(phin)
      ifnd=0
      i=0
      do while(i.lt.NPHS.and.ifnd.eq.0)
       i=i+1
       if(lphin.eq.lphslist(i)) then
        dumphs=phslist(i)
        if(phin(1:lphin).eq.dumphs(1:lphin)) then
         ifnd=i
        endif
       endif
      enddo

c     return if this phase is not included in phslist
      if(ifnd.eq.0) then
       phout=phin
       return
      endif

c     check minimum distances for interpolation to be valid
c     if(ifnd.eq.1.or.ifnd.eq.2.or.ifnd.eq.3.or.ifnd.eq.4) then
c      if(delta.lt.delmnp*dble(ifnd)) then
c       ierr=2
c       return
c      endif
c     else if(ifnd.eq.7.or.ifnd.eq.8.or.ifnd.eq.9.or.ifnd.eq.10) then
c      if(delta.lt.delmns*dble(ifnd-6)) then
c       ierr=2
c       return
c      endif
c     else if(ifnd.eq.13.or.ifnd.eq.14) then
c      if(delta.lt.delmnupp+delmnp*float(ifnd-12)) then
c       ierr=2
c       return
c      endif
c      else if(ifnd.eq.15.or.ifnd.eq.16) then
c      if(delta.lt.delmnups+delmns*float(ifnd-14)) then
c       ierr=2
c       return
c      endif
c     endif

c     do no more checking for SS,SSS,PP,PPP,pP,pPP,sS,sSS
      if(ifnd.eq.8.or.ifnd.eq.9.or.ifnd.eq.10.or.
     1   ifnd.eq.2.or.ifnd.eq.3.or.ifnd.eq.4.or.
     1   ifnd.eq.14.or.ifnd.eq.16) then
       phout=phin
       return
      endif

c     check ScS 
c -------------------------
      if(lphin.eq.3.and.phin(1:3).eq.'ScS') then
       call dsplint(delmxsdep,delmxsdel,delmxsspl,ndelmxs,hdep,delcrit)
       if(delta.gt.delcrit) then
        phout='Sdiff'
       else
        phout='ScS'
       endif
       lout=istlen(phout)
       if(lphin.ne.lout) write(6,*) phin(1:lphin),' identified as ',phout(1:lout)
       return
      endif

c     check PcP
c --------------------
      if(lphin.eq.3.and.phin(1:3).eq.'PcP') then
       call dsplint(delmxpdep,delmxpdel,delmxpspl,ndelmxp,hdep,delcrit)
       if(delta.gt.delcrit) then
        phout='Pdiff'
       else
        phout='PcP'
       endif
       lout=istlen(phout)
       if(lphin.ne.lout) write(6,*) phin(1:lphin),' identified as ',phout(1:lout)
       return
       endif


c     check S and Sdiff
c -----------
      if(phin(1:1).eq.'S') then
       if(delta.lt.delmnsels) then
        phout='S'
       else if(delta.gt.delmxsels) then
        phout='Sdiff'
       else
        call dsplint(delmxsdep,delmxsdel,delmxsspl,ndelmxs,hdep,delcrit)
c       write(6,*) 'maximum delta for direct wave for source at this depth: ',delcrit
        if(delta.gt.delcrit) then
         phout='Sdiff'
        else
         phout='S'
        endif
       endif
       lout=istlen(phout)
       if(lphin.ne.lout) write(6,*) phin(1:lphin),' identified as ',phout(1:lout)
       return
      endif

c     check sS 
c -----------
      if(lphin.eq.2.and.phin(1:2).eq.'sS') then
       call dsplint(delmxsdep,delmxsdel,delmxsspl,ndelmxs,hdep,delcrith)
       call dsplint(delmxsdep,delmxsdel,delmxsspl,ndelmxs,0.d0,delcrit0)
c      add distance for critical ray corresponding to up going part
       ddel=delcrit0-delcrith
       delcritss=delcrit0+ddel
       write(6,*) 'maximum delta for direct wave for source at this depth: ',delcritss
       if(delta.gt.delcritss) then
         phout='sSdiff'
       else
        phout='sS'
       endif
       lout=istlen(phout)
       if(lphin.ne.lout) write(6,*) phin(1:lphin),' identified as ',phout(1:lout)
       return
      endif

c     check P and Pdiff
c -------------------
      if(phin(1:1).eq.'P') then
       if(delta.lt.delmnselp) then
        phout='P'
       else if(delta.gt.delmxselp) then
        phout='Pdiff'
       else
        call dsplint(delmxpdep,delmxpdel,delmxpspl,ndelmxp,hdep,delcrit)
c       write(6,*) 'maximum delta for direct wave for source at this depth: ',delcrit
        if(delta.gt.delcrit) then
         phout='Pdiff'
        else
         phout='P'
        endif
       endif
       lout=istlen(phout)
       if(lphin.ne.lout) write(6,*) phin(1:lphin),' identified as ',phout(1:lout)
       return
      endif

c     check pP and pPdiff
c -------------------
      if(phin(1:2).eq.'pP') then
       call dsplint(delmxpdep,delmxpdel,delmxpspl,ndelmxp,hdep,delcrith)
       call dsplint(delmxpdep,delmxpdel,delmxpspl,ndelmxp,0.d0,delcrit0)
c      add distance for critical ray corresponding to up going part
c      write(6,*) delcrit0,delcrith,2*delcrit0-delcrith,delta
       ddel=delcrit0-delcrith
       delcrit=delcrit0+ddel
       if(delta.gt.delcrit) then
        phout='pPdiff'
       else
        phout='pP'
       endif
       lout=istlen(phout)
       if(lphin.ne.lout) write(6,*) phin(1:lphin),' identified as ',phout(1:lout)
       return
      endif


      end

