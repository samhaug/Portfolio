c ------------------------------------------------------------------------

      character*80 function findcmtlocndk(name,lstring,cmtfl,ifcen,ierr)
      character*(*) name
      character*1 letn
      character*9 try,evt

      include '../include/ndk.h'

      character*80 string,cmtfl
      character*80 fgetenv

      dimension itc1(2),itc2(2),itim(2)
   
      lname=istlen(name)
c     write(6,*) name,lname
      if(lname.eq.7) then         ! thats the old format
        if(name(5:6).lt.'50') then 
         try='20'//name(5:6)//name(1:4)//name(7:7)
        else
         try='19'//name(5:6)//name(1:4)//name(7:7)
        endif
        inmform=1
      else if (lname.eq.13) then  ! thats the format after 2004/1/1
        read(name,'(i4,4i2,a1)') lyearn,imonn,idayn,ihrn,iminn,letn
        inmform=2
        try=name(1:8)//name(13:13)
      else
        stop 'findcmtlocndk: unrecognized name format'
      endif

c     open allorder.ndk file
      lu=-1
      call opnflc(lu,cmtfl,1,0,0,istat,5*81,0)
      call ffstat(lu,lent,iftyp,isize)
c     calculate number of records
      num=isize/(5*81)


c     ???????
      ircmt=1
      ifeq=0
      ient=1
      ilb=0
      iub=num+1


c     read the ient-s record from the ndk file
 100  call ndkread(lu,ient,ifend)

      levnm=istlen(event)
      if(levnm.eq.8) then
       if(event(6:7).lt.'50') then
        evt='20'//event(6:7)//event(2:5)//event(8:8)
       else
        evt='19'//event(6:7)//event(2:5)//event(8:8)
       endif
      else
       evt=event(2:9)//event(14:14)
      endif

      if(try.lt.evt) then
        iub=ient
        goto 400
      else if(try.eq.evt) then
        ifeq=1
        iub=ient
        goto 500
      else
        ilb=ient
        goto 400
      endif
  400 continue
      if(iub-ilb.eq.1) then
c      the cmt catalogue is not always in alphabetical order; try
c      a few events before and after:
       do itry=-5,5
        call bffi(lu,1,iname,8,j,m,(ient-1+itry)*292+5)

        levnm=istlen(event)
        if(levnm.eq.8) then
         if(event(6:7).lt.'50') then
          evt='20'//event(6:7)//event(2:5)//event(8:8)
         else
          evt='19'//event(6:7)//event(2:5)//event(8:8)
         endif
        else
         evt=event(2:9)//event(14:14)
        endif

        if(try.eq.evt) then
         ifeq=1
         ient=ient+itry
         iub=ient
         goto 500
        endif
       enddo
       goto 500
      endif
      if(ient.eq.1) then
        ient=num
        goto 100
      endif
      ient=(iub+ilb)/2
      goto 100
  500 continue

      if(ifeq.eq.1) ilb=max0(1,iub-1)
      ircmt=ilb+1

 223  call ndkread(lu,ircmt,ifend)

c      check whether agreement is precise for new cmt code
       ipr=0
       if(inmform.eq.2) then
        if(name.eq.event(2:14)) ipr=1 
       else
        ipr=1
       endif


      if(ifeq.eq.1.and.ipr.eq.1) then

c        calculate centroid time by adding torg to the pde time
         call datjul(month,iday,lyear,jday)
         call tadd(lyear,jday,ih,imin,fsec,lyearc,jdayc,ihc,minc,fsecc,dble(torg))
         io=0

c        write pde time or centroid time to findcmtlocndk
         if(ifcen.le.0) then
           call puttim(string,io,lyear,jday,ih,imin,fsec)   ! pde time
           write(string(io:80),'(''@'',1x,f5.2,'','',1x,f6.2,'','',f5.1)')
     1        abs(eplat),abs(eplon),depth                 ! pde lat lon dep
           if(eplat.lt.0.) then
             string(io+1:io+1)='-'
           else
             string(io+1:io+1)='+'
           endif
           if(eplon.lt.0.) then
             string(io+8:io+8)='-'
           else
             string(io+8:io+8)='+'
           endif
         else
           call puttim(string,io,lyearc,jdayc,ihc,minc,fsecc) ! centroid time
           write(string(io:80),'(''@'',1x,f5.2,'','',1x,f6.2,'','',f5.1)')
     1        abs(epa),abs(epo),xd                      ! centroid lat lon dep
           if(epa.lt.0.) then
             string(io+1:io+1)='-'
           else
             string(io+1:io+1)='+'
           endif
           if(epo.lt.0.) then
             string(io+8:io+8)='-'
           else
             string(io+8:io+8)='+'
           endif
         endif
         lstring=istlen(string)
         do i=1,lstring
           if(string(i:i).eq.' ') string(i:i)='0'
         enddo
 
         ierr=0
         findcmtlocndk=string

      else 
        write(6,'(''findcmtlocndk: '',a,'' not found'')') name
        ierr=9
        findcmtlocndk=' '
        lstring=0
      endif
      call closfl(lu,kk)
      lu=-1
      return
      end

     
