      subroutine dsplintsph(f,x,i1,i2,a)
c
c    splint does quadrature on a spline fitted integrand.
c    the user is advised to supply a better quadrature
c    procedure, such as 6-th order gauss-legendre between
c    knots, to improve accuracy for high frequency modes.
c    MUST HAVE NO DOUBLED POINTS AS FIRST ENTRY!!!!
c
      implicit double precision(a-h,p-z)
      double precision f(*),x(*)
      parameter (MXLEN=300000)
      data t/0.333333333333333333/
      double precision q(3,MXLEN),work(3,MXLEN)
      call drspln(i1,i2,x,f,q,work)
      a=0.d0
      do 20 i=i1,i2-1
      b=x(i+1)-x(i)
      a=a+b*(f(i)+b*(.5d0*q(1,i)+b*(t*q(2,i)+.25d0*b*q(3,i))))
   20 continue
      return
      end


