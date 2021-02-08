      real function pn(n,x)
c     NORMALIZD LEGENDRE POLYNOMIALS
      real cof(9)
      integer n
      data cof/.7071068,1.2247448,1.5811388,1.8708286,2.1213203
     1   ,2.3452079,2.5495098,2.738612788,2.915475947/
      if(n.gt.8) stop ' n too large in function pn'

      n1=n+1
      x2=x*x
      goto (100,101,102,103,104,105,106,107,108),n1
  100 pn=cof(1)
      goto 99
  101 pn=cof(2)*x
      goto 99
  102 pn=cof(3)*(-0.5+x2*1.5)
      goto 99
  103 pn=cof(4)*x*(-1.5+x2*2.5)
      goto 99
  104 pn=cof(5)*(.375+x2*(-3.75+x2*4.375))
      goto 99
  105 pn=cof(6)*x*(1.875+x2*(-8.75+7.875*x2))
      goto 99
  106 pn=cof(7)*(-.3125+x2*(6.5625+x2*(-19.6875+x2*14.4375)))
      goto 99
  107 pn=cof(8)*x*(-2.1875+x2*(19.6875+x2*(-43.3125+x2*26.8125)))
      goto 99
  108 pn=cof(9)*(0.2734375+x2*(-9.84375+x2*(54.140625+x2*
     *       (-93.84375+x2*50.2734375))))
   99 continue
      return
      end
