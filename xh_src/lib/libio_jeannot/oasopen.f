c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      subroutine oasopen()
      save
      include 'oasstat.h'


      integer o341,z4000
      parameter (o341=1+8*(4+8*3))
      parameter (z4000=4*16**3)

      character*1 null,str1
      character*200 mess
      character*80 dev
      character*80 string,fgetenv,gethost
      null=char(0)

      mess=fgetenv('JUKE_NO_RETRY',lmess)
      if(lmess.gt.0) then
        write(0,*) 'Setting oas-no-retry mode'
        call coasnoretry()
      endif

      mess=fgetenv('JUKE_HOST',lmess)
      if(lmess.le.0) then
        mess='owl'
        lmess=istlen(mess)
      endif

      string=gethost(lstring)

      if(string(1:lstring).eq.mess(1:lmess)) then
        loashost=0
      else
        oashost=mess(1:lmess)//':'
        loashost=istlen(oashost)
      endif

      string=fgetenv('JUKE_CONFIG',lstring)
      if(lstring.le.0) then
        string='12 1 a'
        lstring=6
      endif
      read(string,*) itape,noasdevs
      do i=1,MXJTAP
        if(itape.lt.10) write(tapeid(i),'(i1)') itape
        if(itape.ge.10) write(tapeid(i),'(i2)') itape
        itape=itape+1
      enddo
      dev='/dev/tty'//string(lstring:lstring)
      ldev=istlen(dev)
      if(loashost.gt.0) then
        string=oashost(1:loashost)//dev(1:ldev)
        ldev=ldev+loashost
        dev=string(1:ldev)
      endif

      ittry=0
      itry=0
   11 continue
      call copen(dev(1:ldev)//null,ichan,2,ierrno,0,0)
      if(ierrno.ne.0) then
        if(ierrno.eq.16) then
          if(itry.eq.0) then
            itry=1
            write(0,'(''oasopen: serial device busy: waiting ...'')')
          endif
          call wait(4000)
          goto 11
        else
          write(0,'(a)') 'oasopen:'//dev(1:ldev)
          call cperror('oasopen')
          call exit(2)
        endif
      endif

      call csetoas(ichan,ierrno)

      if(loashost.gt.0) then
        string=oashost(1:loashost)//'/dev/nrst'
      else
        string='/dev/nrst'
      endif
      lstring=istlen(string)
      do idev=1,MXJTAP
        ll=istlen(tapeid(idev))
        call copen(string(1:lstring)//tapeid(idev)(1:ll)//null,itch,0,ierrno,0,0)
        if(ierrno.eq.0) then
          itchan(idev)=itch
        else if(ierrno.ne.6.and.ierrno.ne.16) then
          itchan(idev)=-1
        else
          itchan(idev)=-2
        endif
      enddo

      do idev=1,MXJTAP
        write(str1,'(i1)') idev-1
        itried=0
   43   itried=itried+1
        if(itried.gt.5) stop 'oasopen: OAS error'
        call oassend('user/def='//str1,mess,lmess,-1)
        if(lmess.ne.0) goto 43
        itried=0
   44   itried=itried+1
        if(itried.gt.5) stop 'oasopen: OAS error'
        call wait(300)
        call oassend('status/vol/type=0',mess,lmess,-1)
        if(lmess.ge.2.and.mess(1:2).eq.'E-'
     1    .and.mess(1:20).ne.'E-OMSG-DISK NOT MOUN') goto 44
        oasvols(idev)=mess(1:lmess)
      enddo
      itried=0
   45 itried=itried+1
      if(itried.gt.5) stop 'oasopen: OAS error'
      call oassend('user/def=0',mess,lmess,-1)
      if(lmess.gt.0) goto 45

      return
      end
