      subroutine dep2splncoef(dep,x,ndep)

      dimension x(21)

      call splhsetup()

      rcmb=3480.
      rmoho=6346.
      rearth=6371.
      r=rearth-dep
      if(r.gt.rmoho) stop 'depth specified is above moho'
      xd=-1.+2.*(r-rcmb)/(rmoho-rcmb)
      do ip=0,ndep-1
       x(ip+1)=splh(ip,xd)
      enddo

      end
