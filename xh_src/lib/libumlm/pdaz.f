      subroutine pdaz(epla,eplo,azim,delta,xlat,xlon)
      data radian/57.29578/
      ph21=(180.-azim)/radian
      th1=(90.-epla)/radian
      ph1=eplo/radian
      del=delta/radian
      sth1=sin(th1)
      cth1=cos(th1)
      sph1=sin(ph1)
      cph1=cos(ph1)
      sdel=sin(del)
      cdel=cos(del)
      cph21=cos(ph21)
      sph21=sin(ph21)
      cth2=-sdel*cph21*sth1+cdel*cth1
      sth2=sqrt(1.-cth2*cth2)
      cph2=(sdel*(cph21*cth1*cph1-sph21*sph1)+cdel*sth1*cph1)
      sph2=(sdel*(cph21*cth1*sph1+sph21*cph1)+cdel*sth1*sph1)
      th2=atan2(sth2,cth2)
      ph2=atan2(sph2,cph2)
      xlat=90.-th2*radian
      xlon=ph2*radian
      return
      end
