      function drofint(f,d,nrp)
 
c     implements equation (4.1.14) from numerical recipes
c     is accurate to fourth order

      implicit double precision(a-h,o-z)
 
      dimension f(*)
 
      c1=3.d0/8.d0
      c2=7.d0/6.d0
      c3=23.d0/24.d0
 
      drofint=c1*f(1)+c2*f(2)+c3*f(3)+c3*f(nrp-2)+c2*f(nrp-1)+c1*f(nrp)
 
      do i=4,nrp-3
       drofint=drofint+f(i)
      enddo
 
      drofint=drofint*d
 
      return
      end
 
c ---------------------------------------------------------------------

