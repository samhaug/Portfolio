      subroutine addevt(string,ierr)
      character*(*) string
      include 'phstable.h'
      data nevt/0/
      include 'catbuf.h'
      call strcache(string,k1string,k2string)


      lstring=istlen(string)
      ip=1
      do while(string(ip:ip).ne.'@'.and.ip.lt.lstring)
        ip=ip+1
      enddo

c     nevt=nevt+1
c mow, only one event is defined at any time
      nevt=1
      call inttime(ctbf(k1string:k1string+ip-2)//'~',itimevs(1,nevt))
       
      ip=ip+1
      ip1=ip
      do while(string(ip1:ip1).ne.','.and.ip1.le.lstring)
        ip1=ip1+1
      enddo
      read(string(ip:ip1-1),*) xlatevs(nevt)
      ip=ip1+1
      ip1=ip
      do while(string(ip1:ip1).ne.','.and.ip1.le.lstring)
        ip1=ip1+1
      enddo
      read(string(ip:ip1-1),*) xlonevs(nevt)
      ip=ip1+1
      ip1=ip
      do while(string(ip1:ip1).ne.','.and.ip1.le.lstring)
        ip1=ip1+1
      enddo
      read(string(ip:ip1-1),*) xdepevs(nevt)
      if(ip1.le.lstring) then
        ip=ip1+1
        ip1=ip
        do while(string(ip1:ip1).ne.','.and.ip1.le.lstring)
          ip1=ip1+1
        enddo
        read(string(ip:ip1-1),*) xmagevs(nevt)
      else
        xmagevs(nevt)=0.
      endif
      call struncache(string,k1string,k2string)

      return
      end

