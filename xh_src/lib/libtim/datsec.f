      subroutine datsec(imo,ida,iyr,ihr,imi,isec,jsec)
      fsec=isec
      if(iyr.lt.50) then
        jy=iyr+2000
      else
        jy=iyr+1900
      endif
      call datjul(imo,ida,jy,jd)
      call timsec(jy,jd,ihr,imi,fsec,jsec)
      return
      end
