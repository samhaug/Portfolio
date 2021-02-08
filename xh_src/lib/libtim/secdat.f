      subroutine secdat(jsec,imo,ida,iyr,ihr,imi,isec)
      call sectim(jsec,jy,jd,ihr,imi,fsec)
      isec=fsec
      call juldat(jy,jd,imo,ida)
c     iyr=jy-1900
      iyr=mod(jy,100)
      return
      end
