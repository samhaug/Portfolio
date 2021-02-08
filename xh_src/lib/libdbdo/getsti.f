      subroutine getsti(itim,irefsi,flat,flon,felv,site,lsite,ifvax,ierr)
      character*60 site
      dimension itim(2)
      include 'seedparam.h'
      include 'seedtrees.h'
      include 'cbufcm.h'
      dimension key(1),ktim(2)
      character*3 cod
      character*5 str5
      character*3 str3
      character*4 str4
      character*2 str2
      logical getcldr
      ierr=0
      irank=-1
      if(getcldr(itsticl,mssticl,mtsticl,itim,-1,ktim,key,1,irank)) then
        irefsi=key(1)
      else if(irank.gt.0) then
        ierr=1
        irefsi=key(1)
c       write(6,*) 'getsi: Warning. Using last available:',irefsi
      else
        irefsi=0
        flat=0.
        flon=0.
        felv=0.
        site=' '
        lsite=0
        ifvax=0
        ierr=9
      endif
      if(ierr.gt.1) then
        irank=-1
        if(getcldr(itsticl,mssticl,mtsticl,itim,1,ktim,key,1,irank)) then
          irefsi=key(1)
        else if(irank.gt.0) then
          ierr=1
          irefsi=key(1)
        else
          write(6,*) 'getsti: forward search did not succeed key(1)=',key(1),' irank=',irank
          return
        endif
      endif
      call getblkt(itsblock,irefsi,cod,itp,cbuf,lcbuf,ierr)
      if(ierr.ne.0) then
        write(6,*) 'getsti: unable to retrieve station info blockette'
        return
      endif
      if(cod.ne.'050') then
        write(6,*) 'getsti: wrong blockette type'
        ierr=9
        return
      endif
      io=7
      str5=cbuf(io+1:io+5)
      io=io+5
      read(cbuf(io+1:io+10),"(e10.6)") flat
      io=io+10
      read(cbuf(io+1:io+11),"(e11.6)") flon
      io=io+11
      read(cbuf(io+1:io+7),"(e7.1)") felv
      io=io+7
      io=io+7
      call getstr(cbuf,io,site,lsite)
      str3=cbuf(io+1:io+3)
      io=io+3
      read(str3,"(i3)") inet
      str4=cbuf(io+1:io+4)
      io=io+4
      str2=cbuf(io+1:io+2)
      io=io+2


      if(str5.ne.stnopen) then
        write(6,*) 'getsti: wrong station'
        ierr=9
      endif      
      if(inet.ne.inetopen) then
        write(6,*) 'getsti: wrong network'
        ierr=9
      endif    
      if(str4.eq.'3210'.and.str2.eq.'10') then
        ifvax=0
      else
        write(6,*) 'getsti: Warning: Longword:',str4,' Shorword:',str2
        ifvax=0
c       pause  
      endif
      return
      end
