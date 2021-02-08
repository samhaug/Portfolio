c----------------------------------------------------------
      subroutine findchn(patt,lpatt,knt,iflist,ierr)
      character*(*) patt
      dimension key(5)
      character*20 ckey
      integer*2 jkey(10)

      character*80 str80
      character*100 str100
      character*8 str8
      character*4 str4
      character*3 str3
      double precision dsmpin


      include 'dbdocm.h'

      equivalence (ckey,key,jkey)
      include 'seeddefs.h'
      include 'seedtrees.h'
      include '../libdb/dblib.h'
      logical trfind,trnext,gmatch,getabr
      if(kntstno.le.0) then
        write(6,*) 'findchn: no stations selected'
        ierr=9
        return
      endif
      ierr=0
      knt=0

      do istno=1,kntstno

        if(iflist.gt.0) then
          if(.not.getabr(itabr(DICTGC),inetopnd(istno),str80,lstr80))
     1         pause 'lsstn: network abbreviation not found'
          str100=stnopnd(istno)//' ['//str80(11:lstr80-1)//']'
          lstr100=lstr80-3
          write(6,*) str100(1:lstr100)
        endif


        call openstn(stnopnd(istno),inetopnd(istno),4)


        kntchno(istno)=0
        iofchno(istno)=knt
        if(lpatt.gt.0.and.patt(1:lpatt).ne.' ') then

          key(1)=z'80000000'
          key(2)=0
          key(3)=0
          if(trfind(itchns,key,4,iok,ioi)) pause 'findchn: small found'
          do while(trnext(itchns,1,iok,ioi))
            do i=1,4
              key(i)=ibig(iok+i-1)
            enddo
            call byswap4(key,4)
            ckey(4:4)=char(255-ichar(ckey(4:4)))
            ckey(5:5)=char(255-ichar(ckey(5:5)))
            call chnldcd(ckey,hz,isub,ifmt)


            write(str8,"(f8.4)") hz
            write(str4,"(i4)") isub
            do i=1,4
              if(str4(i:i).eq.' ') str4(i:i)='0'
            enddo
            write(str3,"(i3)") ifmt
            do i=1,3
              if(str3(i:i).eq.' ') str3(i:i)='0'
            enddo


            str80=ckey(1:5)//'('//str4//') ['//str8//'Hz '//str3//'F]'
            lstr80=29
            if(gmatch(patt,lpatt,str80(1:lstr80),lstr80)) then
              if(iflist.gt.0) write(6,*) '\t'//str80(1:lstr80)
              kntchno(istno)=kntchno(istno)+1
              knt=knt+1
              if(knt.gt.MXCHNO) pause 'findchn: too many channels'
              chnopnd(knt)=ckey(1:16)
            endif
          enddo
        endif
      enddo
      if(knt.le.0.and.lpatt.gt.0) then
        write(6,*) 'findchn: channels not found'
        ierr=9
      endif
      return
      end
