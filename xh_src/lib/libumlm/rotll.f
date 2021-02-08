      subroutine rotll(x,y,x1,y1,urot)
      dimension urot(3,3),v(3),v1(3)
      data radian/57.29578/
      a=x/radian
      b=y/radian
      sa=sin(a)
      ca=cos(a)
      sb=sin(b)
      cb=cos(b)
      v(1)=ca*cb
      v(2)=ca*sb
      v(3)=sa
      do 10 i=1,3
      v1(i)=0.
      do 10 j=1,3
   10 v1(i)=v1(i)+urot(i,j)*v(j)
      x1=atan2(v1(3),sqrt(abs(1.-v1(3)*v1(3))))*radian
      y1=atan2(v1(2),v1(1))*radian
      return
      end
