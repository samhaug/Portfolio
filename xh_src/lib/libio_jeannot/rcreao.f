      subroutine rcreao(path,ichan)
      character*1 null
      character*(*) path

      character*256 tempfile
      integer q1, q2
      parameter (q1=4+16*(10+16*1))
      parameter (q2=13+16*(14+16*1))
      null=char(0)

      ichan=-1
      itry=0
      ifail=0
      ilen=istlen(path)
c read-write
      isunop=2
   30 ip2=ilen
      if(path(ip2:ip2).eq.'/'.and.ifail.ne.0) return
      tempfile=path(1:ip2)//char(0)
      call copen(tempfile(1:lnblnk(tempfile)),ichan,isunop,iopner,2,q1)
      if(iopner.eq.0) then
c       call cclose(ichan,ires,ier)
        return
      else if(ifail.ne.0) then
        call check('copen in recreat failed')
      else if(iopner.eq.2) then
        itry=itry+1
        ifail=1
      else





        call check('copen in rcreat')
      endif

   10 continue
      do while(ip2.gt.0.and.path(ip2:ip2).ne.'/') 
        ip2=ip2-1
      enddo

      tempfile=path(1:ip2-1)//char(0)
   20 call cmkdir(tempfile(1:lnblnk(tempfile)),q2,ires,ierrno)
      if(ierrno.eq.2) then
        itry=1+itry
        ip2=ip2-1
        goto 10
      else if(ierrno.eq.0) then
        itry=itry-1
        if(itry.gt.0) then
          ip2=1+ip2
          do while(path(ip2:ip2).ne.'/')
            ip2=1+ip2
          enddo

          goto 20
        else 




          goto 30
        endif

      else





        call check('rcreat')
      endif

      return
      end
