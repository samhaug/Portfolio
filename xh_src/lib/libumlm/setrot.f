      subroutine setrot(alph,beta,gama,urot)
      dimension urot(3,3)
      sal=sin(alph)
      cal=cos(alph)
      sbe=sin(beta)
      cbe=cos(beta)
      sga=sin(gama)
      cga=cos(gama)
      urot(1,1)=cga*cbe*cal-sga*sal
      urot(1,2)=cga*cbe*sal+sga*cal
      urot(1,3)=-cga*sbe
      urot(2,1)=-sga*cbe*cal-cga*sal
      urot(2,2)=-sga*cbe*sal+cga*cal
      urot(2,3)=sga*sbe
      urot(3,1)=sbe*cal
      urot(3,2)=sbe*sal
      urot(3,3)=cbe
      return
      end
