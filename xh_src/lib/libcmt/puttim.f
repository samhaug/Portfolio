

      subroutine puttim(cbuf,iout,iyear,jday,ihr,min,fsec)
      character*(*) cbuf
      ip=iout
      write(cbuf(ip+1:ip+21),"(i4,',',i3,',',2(i2,':'),f6.3)") 
     1     iyear,jday,ihr,min,fsec
      ip=ip+21
      if(fsec.eq.0.0) then
        ip=ip-7
        if(min.eq.0) then
          ip=ip-3
          if(ihr.eq.0) then
            ip=ip-3
          endif
        endif
      endif
      do i=iout+1,ip
        if(cbuf(i:i).eq.' ') cbuf(i:i)='0'
      enddo
      cbuf(ip+1:ip+1)='~'
      ip=ip+1
      iout=ip
      return
      end
