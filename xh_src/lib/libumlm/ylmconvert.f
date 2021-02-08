      subroutine ylmconvert(lmax,y,ifb)
      dimension y((lmax+1)**2)
      pi=4.0*atan(1.0)
      f0=sqrt(4*pi)
      f1=sqrt(8*pi)
      if(ifb.eq.-1) then
        f0=1/f0
        f1=1/f1
      endif


      do l=0,lmax
        do m=0,l
          if(m.eq.0) then
            k=k+1
            y(k)=y(k)*f0
          else if(mod(m,2).eq.0) then
            k=k+1
            y(k)= y(k)*f1
            k=k+1
            y(k)= y(k)*f1
          else
            k=k+1
            y(k)=-y(k)*f1
            k=k+1
            y(k)=-y(k)*f1
          endif
        endif
      enddo
      end




