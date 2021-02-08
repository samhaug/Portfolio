
      subroutine docdat(jdoc,im,id,jy,jd)
      call docjul(jdoc,jy,jd)
      call juldat(jy,jd,im,id)
      return
      end
