      integer function jdoc(month,iday,iyear)
      call datjul(month,iday,iyear,jd)
      call juldoc(iyear,jd,jdoc)
      return
      end
