c-------------------------------------------------------------------
      subroutine inttime(time,itime)
      character*(*) time
      integer*4 itime(2)
      io=0
      call gettim(time,io,jy,jd,ih,im,fs)
      call timsec(jy,jd,ih,im,fs,itime(1))
      it=10000*amod(fs,1.0)
      itime(2)=ishft(it,16)
      return
      end
