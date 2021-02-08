      SUBROUTINE dsplint(xa,ya,y2a,n,x,y)

      implicit double precision(a-h,o-z)

      INTEGER n
      dimension xa(n),y2a(n),ya(n)
      INTEGER k,khi,klo
      klo=1
      khi=n
1     if (khi-klo.gt.1) then
        k=(khi+klo)/2
        if(xa(k).gt.x)then
          khi=k
        else
          klo=k
        endif
      goto 1
      endif
      h=xa(khi)-xa(klo)
      if (h.eq.0.) pause 'bad xa input in splint'
      a=(xa(khi)-x)/h
      b=(x-xa(klo))/h
      y=a*ya(klo)+b*ya(khi)+((a**3-a)*y2a(klo)+(b**3-b)*y2a(khi))*(h**
     *2)/6.d0
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software '%1&9p#!.
