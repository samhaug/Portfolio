
      subroutine secstr(jsec,dat,tim)
      character*8 dat,tim
      call secdat(jsec,imo,ida,iyr,ihr,imi,isec)
      write(dat,"(i2,'/',i2,'/',i2)") imo,ida,mod(iyr,1000)
      write(tim,"(i2,':',i2,':',i2)") ihr,imi,isec
      do i=1,8
        if(dat(i:i).eq.' ') dat(i:i)='0'
        if(tim(i:i).eq.' ') tim(i:i)='0'
      enddo
      return
      end
