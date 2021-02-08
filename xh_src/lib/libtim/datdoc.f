
      subroutine datdoc(im,id,jy,jdoc)
      call datjul(im,id,jy,jd)
      call juldoc(jy,jd,jdoc)
      return
      end
