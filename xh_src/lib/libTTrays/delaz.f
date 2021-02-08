      subroutine delaz(eplat,eplong,stlat,stlong,delta,azep,azst,eldg,stldg)

c     geoco = (1-e^2) in 'The theory of the Earth's shape' pp176-182
c     uses expression (8.28) to convert to geocentric latitude 
c     should become unstable for latitude of 90 degrees!

      data geoco,hpi,twopi,rad,reprad/.993277,1.5707963,
     16.2831853,.0174533,57.29578/
      tangt(x)=sin(x)/cos(x)
      arcos(x)=atan2(sqrt(1.-x*x),x)
      el=atan(geoco*tangt(eplat*rad))
      el=hpi-el
      eldg=el*reprad
      stl=atan(geoco*tangt(stlat*rad))
      stl=hpi-stl
      stldg=stl*reprad
      elon=eplong*rad
      slon=stlong*rad
      as=cos(stl)
      bs=sin(stl)
      cs=cos(slon)
      ds=sin(slon)
      a=cos(el)
      b=sin(el)
      c=cos(elon)
      d=sin(elon)
      cdel=a*as+b*bs*(c*cs+d*ds)
      if(abs(cdel).gt.1.) cdel=sign(1.,cdel)
      delt=arcos(cdel)
      delta=delt*reprad
      sdel=sin(delt)
      caze=(as-a*cdel)/(sdel*b)
      if(abs(caze).gt.1.) caze=sign(1.,caze)
      aze=arcos(caze)
      if(bs.gt.0.) cazs=(a-as*cdel)/(bs*sdel)
      if(bs.eq.0.) cazs=sign(1.,cazs)
      if(abs(cazs).gt.1.) cazs=sign(1.,cazs)
      azs=arcos(cazs)
      dif=ds*c-cs*d
      if(dif.lt.0.) aze=twopi-aze
      azep=reprad*aze
      if(dif.gt.0.) azs=twopi-azs
      azst=reprad*azs
      return
      end

