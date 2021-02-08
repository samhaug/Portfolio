      subroutine ddelaz(eplat,eplong,stlat,stlong,delta,azep,azst,eldg,stldg)

c     geoco = (1-e^2) in 'The theory of the Earth's shape' pp176-182
c     uses expression (8.28) to convert to geocentric latitude 
c     should become unstable for latitude of 90 degrees!

      implicit double precision(a-h,o-z)

      data geoco,hpi,twopi,rad,reprad/.993277d0,1.5707963d0,
     16.2831853d0,.0174533d0,57.29578d0/

      dtangt(x)=dsin(x)/dcos(x)
      darcos(x)=datan2(dsqrt(1.-x*x),x)

      el=datan(geoco*dtangt(eplat*rad))
      eldg=reprad*el
      el=hpi-el
      stl=datan(geoco*dtangt(stlat*rad))
      stldg=reprad*stl
      stl=hpi-stl
      elon=eplong*rad
      slon=stlong*rad
      as=dcos(stl)
      bs=dsin(stl)
      cs=dcos(slon)
      ds=dsin(slon)
      a=dcos(el)
      b=dsin(el)
      c=dcos(elon)
      d=dsin(elon)
      cdel=a*as+b*bs*(c*cs+d*ds)
      if(dabs(cdel).gt.1.) cdel=dsign(1.,cdel)
      delt=darcos(cdel)
      delta=delt*reprad
      sdel=dsin(delt)
      caze=(as-a*cdel)/(sdel*b)
      if(dabs(caze).gt.1.) caze=dsign(1.,caze)
      aze=darcos(caze)
      if(bs.gt.0.) cazs=(a-as*cdel)/(bs*sdel)
      if(bs.eq.0.) cazs=dsign(1.,cazs)
      if(dabs(cazs).gt.1.) cazs=dsign(1.,cazs)
      azs=darcos(cazs)
      dif=ds*c-cs*d
      if(dif.lt.0.) aze=twopi-aze
      azep=reprad*aze
      if(dif.gt.0.) azs=twopi-azs
      azst=reprad*azs
      return
      end

