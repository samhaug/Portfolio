      subroutine ctable
      dimension work(3,300)
      common/csplin/ n,arg(300),c(300),qarg(3,300)
      data pi/3.1415926536/
      rad=pi/180.
      do 1 i=1,300
      c(i)=0.01*float(i-1)
      argu=(2.*c(i)+sin(2.*c(i)))/pi
      if(argu.gt.1) go to 2
      arg(i)=asin(argu)
      ang=arg(i)/rad
    1 continue
    2 n=i-1
      call rspln(1,n,arg,c,qarg,work)
      return
      end
