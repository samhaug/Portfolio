      subroutine gettim(cbuf,iout,iyear,jday,ihr,min,fsec)
      character*(*) cbuf
      iyear=0
      jday=1
      ihr=0
      min=0
      fsec=0.
      ip=iout+1
      ip1=ip
      if(cbuf(ip:ip).eq.'~') goto 99
      ip=ip+4
      read(cbuf(ip1:ip),"(i4)") iyear
      if(cbuf(ip:ip).eq.'~') goto 99
      ip1=ip+1
      ip=ip+4
      read(cbuf(ip1:ip),"(i3)") jday
      if(cbuf(ip:ip).eq.'~') goto 99
      ip1=ip+1
      ip=ip+3
      read(cbuf(ip1:ip),"(i2)") ihr
      if(cbuf(ip:ip).eq.'~') goto 99
      ip1=ip+1
      ip=ip+3
      read(cbuf(ip1:ip),"(i2)") min
      if(cbuf(ip:ip).eq.'~') goto 99
      ip1=ip+1
      ip=ip+3
      read(cbuf(ip1:ip),"(i2)") isec
      fsec=float(isec)
      if(cbuf(ip:ip).eq.'~') goto 99
      fac=1.
      do i=1,5
        fac=fac*.1
        ip=ip+1
        if(cbuf(ip:ip).eq.'~') then
          goto 99
        else
          read(cbuf(ip:ip),"(i1)") ii
          fsec=fsec+float(ii)*fac
        endif
      enddo
      write(6,"(25a1)") (cbuf(i:i),i=iout+1,iout+25)
      pause 'time error'
   99 continue
c     if(fsec.ne.0.) then
c       write(6,"(25a1)") (cbuf(i:i),i=iout+1,ip)
c       write(6,"(i4,',',i3,',',i2,':',i2,':',f7.4)")
c    1    iyear,jday,ihr,min,fsec
c     endif
      iout=ip
      return
      end
