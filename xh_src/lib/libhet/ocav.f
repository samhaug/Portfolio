c Evaluate the minor arc average (oct) and the great circle average
c (och) of the oceanic function, for the path defined by
c eplat,eplon,stlat,stlon (degrees). pht and idx are working space
c and must be dimensioned at least 150 in the calling program.

      subroutine ocav(eplat,eplon,stlat,stlon,och,oct,pht,idx)
      save
      dimension pht(150),idx(150)
      data pi/3.141592653589/
      dth=pi/36.
      pi2=pi*2.
      forpi=4.*pi
      dph=pi2/72.
      radian=180./pi
      nth1=37
      nph1=36
      th1=(90.-eplat)/radian
      ph1=eplon/radian
      th2=(90.-stlat)/radian
      ph2=stlon/radian
      sth1=sin(th1)
      sth2=sin(th2)
      cth1=cos(th1)
      cth2=cos(th2)
      sph1=sin(ph1)
      sph2=sin(ph2)
      cph1=cos(ph1)
      cph2=cos(ph2)
      cph21= cph1*cph2+sph1*sph2
      sph21=sph2*cph1-sph1*cph2
      cdel=sth1*sth2*cph21+cth1*cth2
      ccapth=sth1*sth2*sph21/sqrt(1.-cdel*cdel)
      scapth=sqrt(1.-ccapth*ccapth)
      scapph=cth1*sth2*cph2-cth2*sth1*cph1
      ccapph=sth1*cth2*sph1-sth2*cth1*sph2
      capph=atan2(scapph,ccapph)
      scapph=sin(capph)
      ccapph=cos(capph)
c
      del=atan2(sqrt(1.-cdel*cdel),cdel)
      cphsp=ccapth*sth1*(cph1*ccapph+sph1*scapph)-scapth*cth1
      sphsp=sth1*(sph1*ccapph-cph1*scapph)
      phsp=atan2(sphsp,cphsp)
      ient=0
      if(scapth.eq.0) goto 10
      do 20 i=1,nth1
      th=float(i-1)*dth
      cth=cos(th)
      cpht=-cth/scapth
      cpht2=cpht*cpht
      if(cpht2.gt.1.) goto 20
      ient=1+ient
      pht(ient)=atan2(sqrt(1.-cpht2),cpht)
      ient=1+ient
      pht(ient)=-pht(ient-1)
   20 continue
   10 continue
      do 40 i=1,nph1
      ph=float(i-1)*dph
      sph=sin(ph)
      cph=cos(ph)
      ient=ient+1
      pht(ient)=atan2(ccapth*(sph*ccapph-cph*scapph),
     1     cph*ccapph+sph*scapph)
      ient=1+ient
      pht(ient)=pi+pht(ient-1)
      if(pht(ient).gt.pi) pht(ient)=pht(ient)-pi2
   40 continue
c
      do 60 i=1,ient
   60 pht(i)=amod(pht(i)-phsp+forpi,pi2)
      ient=ient+1
      pht(ient)=0.
      ient=ient+1
      pht(ient)=del
c
      call rsoinc(pht,ient,idx)
c
      pht(ient+1)=pi2
      sumh=0.
      sumt=0.
      testh=0.
      testt=0.
      do 50 i=1,ient
      i1=1+i
      phtt=.5*(pht(i)+pht(i1))+phsp
      cpht=cos(phtt)
      spht=sin(phtt)
      cth=-cpht*scapth
      th=atan2(sqrt(1.-cth*cth),cth)
      cph=cpht*ccapth*ccapph-spht*scapph
      sph=cpht*ccapth*scapph+spht*ccapph
      if(sph.eq.0..and.cph.eq.0.) goto 9873
      ph=atan2(sph,cph)
      goto 9874
 9873 ph=0.
 9874 continue
      xlat=90.-th*radian
      xlon=ph*radian
      value=ocfun(xlat,xlon)
      rd=(pht(i1)-pht(i))
      if(pht(i1).le.del) testt=testt+rd
      testh=testh+rd
      if(pht(i1).le.del) sumt=sumt+rd*value
      sumh=sumh+rd*value
   50 continue
      testt=testt/del
      testh=testh/pi2
      write(6,12) testt,testh
   12 format(' testt,testh =',2f10.6)
      oct=sumt/del
      och=sumh/pi2
      return
      end
