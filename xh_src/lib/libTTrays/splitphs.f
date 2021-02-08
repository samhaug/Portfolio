      subroutine splitphs(phin,phout,nout,ifnd)

c     determines how to split phases for use in ellcor

      character*(*) phin
      character*(*) phout(10)
      character*1 cnb

      parameter(NPHS=20)
      character*20 phslist(NPHS),dumphs
      dimension lphslist(NPHS),ntpsplit(NPHS)
      data phslist/'PPP','PPPP','PcP2','PcP3',
     1             'SSS','SSSS','ScS2','ScS3',
     1             'sScS','sScS2','sScS3',
     1             'pPP','pPPP','sSS','sSSS',
     1             'ScS4','sScS4','sSSSS','sPP','sPPP'/

      data ntpsplit/1,1,2,2,
     1              1,1,2,2,
     1              3,3,3,
     1              1,1,1,1,
     1              2,3,4,1,1/
      
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

c     if (ifnd.eq.0) return
c     clear phout
      do i=1,10
       phout(i)=''
      enddo

      if (ntpsplit(ifnd).eq.1) then
       phout(1)(1:2)=phin(1:2)
       l=lphin-2
       phout(2)(1:l)=phin(3:lphin)
       nout=2
      else if(ntpsplit(ifnd).eq.2) then
       cnb=phin(4:4)
       read(cnb,'(i1)') nb
       do i=1,nb
        phout(i)(1:3)=phin(1:3)
       enddo
       nout=nb
      else if(ntpsplit(ifnd).eq.3) then
       if(phin(1:1).eq.'s') then
        phout(1)='Sup'
       else
        phout(1)='Pup'
       endif
       cnb=phin(5:5)
       read(cnb,'(i1)') nb
       do i=1,nb
        phout(i+1)(1:3)=phin(2:4)
       enddo
       nout=nb+1
      else if(ntpsplit(ifnd).eq.4) then
       phout(1)(1:2)=phin(1:2)
       phout(2)(1:2)=phin(3:4)
       l=lphin-4
       phout(3)(1:l)=phin(5:lphin)
       nout=3
      endif

      end

