c----------------------------------------------------------
      subroutine findstn(patt,lpatt,iflist,ierr)
      character*(*) patt
      dimension key(5)
      character*20 ckey
      character*5 stcode
      character*80 str80
      character*100 str100

      include 'dbdocm.h'

      equivalence (ckey,key)
      include 'seeddefs.h'
      include 'seedtrees.h'
      include '../libdb/dblib.h'
      logical trfind,trnext,gmatch,getabr
      kntstno=0
      ierr=0
      if(lpatt.eq.0) return
      if(patt(1:lpatt).eq.' ') return
      key(2)=0
      ckey(1:5)=' '
      call byswap4(key,2)
      if(trfind(itstns,key,2,iok,ioi)) pause 'findstn: small found'
      do while(trnext(itstns,1,iok,ioi))
        key(1)=ibig(iok)
        key(2)=ibig(iok+1)
        call byswap4(key,2)
        stcode=ckey(1:5)
        call byswap4(key,2)
        lstcode=istlen(stcode)
        inet=and(key(2),z'00ffffff')
        if(.not.getabr(itabr(DICTGC),inet,str80,lstr80))
     1       pause 'lsstn: network abbreviation not found'
        str100=stcode//' ['//str80(11:lstr80-1)//']'
        lstr100=lstr80-3
        if(gmatch(patt,lpatt,str100,lstr100)) then
          if(iflist.gt.0) write(6,*) str100(1:lstr100)
          kntstno=kntstno+1
          if(kntstno.gt.MXSTNO) pause 'findstn: too many stations'
          stnopnd(kntstno)=stcode
          inetopnd(kntstno)=inet
          kntchno(kntstno)=0
        endif
      enddo
      if(kntstno.le.0) then
        write(6,*) 'findstn: no stations selected'
        ierr=9
      endif
      return
      end
