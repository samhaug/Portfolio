       subroutine gcircl(alat1,alon1,alat2,alon2,npts,kind
     1          ,ictrig,ithtrig,arect,urot,iproj)
      dimension arect(4),urot(3,3)
      data pi/3.141592653589/
      radian=180./pi
      th1=(90.-alat1)/radian
      ph1=alon1/radian
      th2=(90.-alat2)/radian
      ph2=alon2/radian
      pi2=pi*2.
      pi4=pi*4.
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
      dphtd=360./float(npts-1)
      dpht=dphtd/radian
      do 80 iarc=1,2
      if(kind.eq.2.and.iarc.eq.1) goto 80
      if(kind.eq.1.and.iarc.eq.2) goto 80
      phst=float(iarc-1)*del
      phen=del+float(iarc-1)*(pi2-del)
      iend=0
      do 70 i=1,npts
        pht=phst+float(i-1)*dpht
        if(pht.gt.phen) then
          iend=1
          pht=phen
        endif
        cphp1=cos(pht+pht1)
        sphp1=sin(pht+pht1)
        cthp=-cphp1*scapth
        xlat=90.-atan2(sqrt(1.-cthp*cthp),cthp)*radian
        cphp=cphp1*ccapth*ccapph-sphp1*scapph
        sphp=cphp1*ccapth*scapph+sphp1*ccapph
        xlon=atan2(sphp,cphp)*radian
        call rotll(xlat,xlon,xlat,xlon,urot)
        if(xlon.lt.0.) xlon=xlon+360.
      
        if(i.eq.1) then
          call mapprj(xlon,xlat,iproj,xp,yp)
          call drawc(xp,yp,arect,0,1)
        else
          dif=xlon-xlonl
          if(abs(dif)*cos(xlat/radian).gt.2.*dphtd) then
            if(dif.lt.0.) vx=360.
            if(dif.gt.0.) vx=0.
          
            xf=amod(xlonl+180.,360.)-180.
            xt=amod(xlon+180.,360.)-180.
            ycc=(xlatl*xt-xf*xlat)/(xt-xf)
            call mapprj(vx,ycc,iproj,xp,yp)
            call drawc(xp,yp,arect,1,0)
            xn=vx
            yn=ycc
            xlonl=xn
            xlatl=yn
            vx=360.-vx
            call mapprj(vx,ycc,iproj,xp,yp)
            call drawc(xp,yp,arect,0,0)
            xlonl=vx
            xlatl=ycc
          endif
          call mapprj(xlon,xlat,iproj,xp,yp)
          call drawc(xp,yp,arect,1,0)
        endif
        xlatl=xlat
        xlonl=xlon
        if(iend.eq.1) goto 71
   70 continue
   71 continue
      call lincol(ictrig)
      call linwdt(ithtrig)
      call drcpolyline()
      call tsend

   80 continue
      return
      end
