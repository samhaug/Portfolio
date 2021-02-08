      function rofint(f,d,nrp)
 
c     implements equation (4.1.14) from numerical recipes
c     is accurate to fourth order

      dimension f(*)
 
      c1=3./8.
      c2=7./6.
      c3=23./24.
 
      rofint=c1*f(1)+c2*f(2)+c3*f(3)+c3*f(nrp-2)+c2*f(nrp-1)+c1*f(nrp)
 
      do i=4,nrp-3
       rofint=rofint+f(i)
      enddo
 
      rofint=rofint*d
 
      return
      end
 
c ---------------------------------------------------------------------

