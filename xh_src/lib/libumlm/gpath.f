      dimension ilat(500),ilon(500),rlen(500),razm(500)

      nth=18   ! for 10 degree grid
      nph=36

   10 write(6,'(''Type lat lon lat lon: '',$)')
      read(5,*) alat1,alon1,alat2,alon2
      call gpath(alat1,alon1,alat2,alon2,nth,nph
     1  ,ilat,ilon,rlen,razm,indmin,indlas)
      write(6,'(''Minor arc:''/(i4,''.'',2i4,2f9.3))') 
     1     (i,ilat(i),ilon(i),rlen(i),razm(i),i=1,indmin)
      write(6,'(''Major arc:''/(i4,''.'',2i4,2f9.4))')
     1     (i,ilat(i),ilon(i),rlen(i),razm(i),i=indmin+1,indlas)
      goto 10
      end
c---------------------------------------------------------------
      subroutine gpath(alat1,alon1,alat2,alon2,nth,nph
     1  ,ilat,ilon,rlen,razm,indmin,indlas)
     
c     given the two endpoints of a path (alat1,alon1), (alat2,alon2)
c     gpath finds which lat-lon squares the great circle
c     path has traversed and saves their parameters in the arrays:
c
c     ilat(1,2, ... indlas)  latitude cell index (1,2, ... nth)
c     ilon(1,2, ... indlas)  longitude cell index (1,2, ... nph)
c     rlen(1,2, ... indlas)  path length within the cell, in degrees
c     razm(1,2, ... indlas)  azimuth of propagation at the midpoint
c                            of the path within the cell (0.0,...,359.999)
c
c     The array entries 1,2, ... indmin refer to the minor arc
c     in order of traversal from (alat1,alon1) to (alat2,alon2),
c     and entries indmin,+1,indmin+2 .... indlas refer to the
c     major arc. The elements indmin, indmin+1 will refer
c     to the SAME cell -- that containing the receiver, and indices
c     1 and indlas will also refer to the same cell -- that containing
c     the source.
c     These arrays should be dimensioned in the calling program
c     so that they are large enough to accomodate the maximum number
c     of cells which a path can intersect.
c     The cell indices ilat, ilon are such that cells
c     are numbered in decreasing latitude, from the North pole
c     to the south pole, and in increasing longitude from 
c     180W to 180E.

      parameter (MWORK=1000)
      dimension pht(MWORK),idx(MWORK)
      dimension ilat(*),ilon(*),rlen(*),razm(*)
      data pi/3.141592653589/
      radian=180./pi
      th1=(90.-alat1)/radian
      ph1=alon1/radian
      th2=(90.-alat2)/radian
      ph2=alon2/radian
      dth=pi/float(nth)
      pi2=pi*2.
      pi4=pi*4.
      dph=pi2/float(nph)
      nth1=nth+1
      nph1=nph/2
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
      ph21=atan2(sph21,cph21)
      cdel=sth1*sth2*cph21+cth1*cth2
      del=atan2(sqrt(1.-cdel*cdel),cdel)
      ccapth=sth1*sth2*sph21/sqrt(1.-cdel*cdel)
      scapth=sqrt(1.-ccapth*ccapth)
      scapph=cth1*sth2*cph2-cth2*sth1*cph1
      ccapph=sth1*cth2*sph1-sth2*cth1*sph2
      capph=atan2(scapph,ccapph)
      scapph=sin(capph)
      ccapph=cos(capph)
      pht1=atan2(sth1*(sph1*ccapph-cph1*scapph),
     1     ccapth*sth1*(cph1*ccapph+sph1*scapph)-scapth*cth1)
      ient=0
      if(scapth.ne.0.) then
        do i=1,nth1
          th=float(i-1)*dth
          cth=cos(th)
          cpht=-cth/scapth
          cpht2=cpht*cpht
          if(cpht2.le.1.) then
            ient=1+ient
            pht(ient)=amod(atan2(sqrt(1.-cpht2),cpht)-pht1+pi4,pi2)
            ient=1+ient
            pht(ient)=amod(-pht(ient-1)-2.*pht1+pi4,pi2)
          endif
        enddo
      endif

      do i=1,nph1
        ph=float(i-1)*dph
        sph=sin(ph)
        cph=cos(ph)
        ient=ient+1
        pht(ient)=amod(atan2(ccapth*(sph*ccapph-cph*scapph),
     1     cph*ccapph+sph*scapph)-pht1+pi4,pi2)
        ient=1+ient
        pht(ient)=amod(pi+pht(ient-1),pi2)
      enddo
      ient=1+ient
      pht(ient)=0.
      ient=1+ient
      pht(ient)=del
      ient=1+ient
      pht(ient)=pi2

      call rsoinc(pht,ient,idx)

      do i=1,ient-1
c       find colatitude and longitude (th,ph) of the
c       midpoint of the arc segment in the cell
        phtt=.5*(pht(i)+pht(i+1))
        cpht=cos(phtt+pht1)
        spht=sin(phtt+pht1)
        cth=-cpht*scapth
        th=atan2(sqrt(1.-cth*cth),cth)
        cph=cpht*ccapth*ccapph-spht*scapph
        sph=cpht*ccapth*scapph+spht*ccapph
        if(sph.eq.0..and.cph.eq.0.) then
          ph=0.
        else
          ph=atan2(sph,cph)
        endif

c        find the azimuth of the exit point at the midpoint
c        (this could be done more efficiently)

        phtte=pht(i+1)
        cphte=cos(phtte+pht1)
        sphte=sin(phtte+pht1)
        cthe=-cphte*scapth
        the=atan2(sqrt(1.-cthe*cthe),cthe)
        cphe=cphte*ccapth*ccapph-sphte*scapph
        sphe=cphte*ccapth*scapph+sphte*ccapph
        if(sphe.eq.0..and.cphe.eq.0.) then
          phe=0.
        else
          phe=atan2(sphe,cphe)
        endif
        call delazs(90.-th*radian,ph*radian,90.-the*radian
     1     ,phe*radian,delta,azep,azst)
        razm(i)=azep

        ii=(th/pi)*float(nth)+1.
        jj=(ph/pi2+2.)*float(nph)+1.
        ii=1+mod(ii-1,nth)
        jj=1+mod(jj-1+nph1,nph)
        ilat(i)=ii
        ilon(i)=jj
        rlen(i)=(pht(i+1)-pht(i))*radian
        if(pht(i+1).eq.del) indmin=i
      enddo

      indlas=ient-1
      return
      end
c---------------------------------------------------------------
      subroutine delazs(eplat,eplong,stlat,stlong,delta,azep,azst)
      data hpi,twopi,rad,reprad/1.5707963268
     1   ,6.2831853,.017453293,57.2957795/
      arcos(x)=atan2(sqrt(1.-x*x),x)
      el=eplat*rad
      el=hpi-el
      stl=stlat*rad
      stl=hpi-stl
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

c-------------------------------------------------
      subroutine rsoinc(a,n,idx)
      save
      dimension a(*),idx(*)
      if (n.eq.1) go to 65
      if (n.le.0) go to 60
      do 1 i = 1,n
      idx(i) = i
    1 continue
      n2 = n/2
      n21 = n2 + 2
      ict=1
      i=2
   11 n1=n21-i
      nn=n
      ik=n1
   15 c=a(ik)
      ic=idx(ik)
  100 jk=2*ik
      if (jk.gt.nn) go to 140
      if (jk.eq.nn) go to 120
       if (a(jk+1).le.a(jk)) go to 120
      jk=jk+1
  120 if (a(jk).le. c) go to 140
      a(ik)=a(jk)
      idx(ik)=idx(jk)
      ik=jk
      go to 100
  140 a(ik)=c
      idx(ik)=ic
      go to (3,45) ,ict
    3 if (i.ge.n2) go to 35
      i=i+1
      go to 11
   35 ict=2
      np2=n+2
      i=2
   37 n1=np2-i
      nn=n1
      ik=1
      go to 15
  45  continue
      t = a(1)
      a(1) = a(n1)
      a(n1) = t
      it = idx(1)
      idx(1) = idx(n1)
      idx(n1) = it
      if (i.ge.n) go to 55
      i=i+1
      go to 37
   55 return
   60 write(6,500)
  500 format('error return from rsoinc - n less than or equal to 1')
      stop
   65 idx(1)=1
      return
      end
