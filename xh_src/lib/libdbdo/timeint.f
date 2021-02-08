c------------------------------------------
      subroutine timeint(itime,time,ltime)
      character*(*) time
      dimension itime(2)
      if(itime(1).eq.z'7fffffff') then
        time(1:1)='~'
        ltime=1
      else
        call sectim(itime(1),jy,jd,ih,im,fsec)
        fsec=fsec+float(ishft(itime(2),-16))/10000.
        ltime=0
        call puttim(time,ltime,jy,jd,ih,im,fsec)
      endif
      return
      end
