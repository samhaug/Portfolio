      subroutine pole(epla,eplo,stla,stlo,xlap,xlop,azmp,delta)
      implicit double precision (a-h,o-z)
      real epla,eplo,stla,stlo,xlap,xlop,azmp,delta
      data radian/57.295779513082d0/
      th1=(90.d0-epla)/radian
      th2=(90.d0-stla)/radian
      ph1=eplo/radian
      ph2=stlo/radian
      cth1=dcos(th1)
      cth2=dcos(th2)
      sth1=dsin(th1)
      sth2=dsin(th2)
      cph1=dcos(ph1)
      cph2=dcos(ph2)
      sph1=dsin(ph1)
      sph2=dsin(ph2)
      cph21=cph1*cph2+sph1*sph2
      sph21=sph2*cph1-sph1*cph2
      cdel=sth1*sth2*cph21+cth1*cth2
      sdel=dsqrt(1.d0-cdel**2)
      delta=datan2(sdel,cdel)*radian
      ccth=sth1*sth2*sph21/sdel
      scth=dsqrt(1.d0-ccth**2)
      cth=datan2(scth,ccth)
      coco=1.d0/(sdel*scth)
      scph=coco*(cth1*sth2*cph2-cth2*sth1*cph1)
      ccph=coco*(sth1*cth2*sph1-sth2*cth1*sph2)
      cph=datan2(scph,ccph)
      xlap=90.d0-cth*radian
      xlop=cph*radian
      v1=sth1*cph1+sth2*cph2
      v2=sth1*sph1+sth2*sph2
      v3=cth1+cth2
      vn=dsqrt(v1**2+v2**2+v3**2)
      v1=v1/vn
      v2=v2/vn
      v3=v3/vn
      cthm=v3
      sthm=dsqrt(1.d0-v3**2)
      cphm=v1/sthm
      sphm=v2/sthm
      cphmp=ccth*sthm*(cphm*ccph+sphm*scph)-scth*cthm
      sphmp=sthm*(sphm*ccph-cphm*scph)
      phmp=datan2(sphmp,cphmp)
      azmp=180.d0-phmp*radian
      return
      end
