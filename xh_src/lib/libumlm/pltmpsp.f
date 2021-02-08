c---------------------------------------------------------------------
      subroutine pltmpsp(iu,alphd,betad,gamad,ifplb,iffill,ifcent,ifmer,ifram
     1 ,iccou,ithcou
     1 ,iccnt,icocn,icplb,icfram,icmer,ithcnt,ithplb,ithcen,ithfrm,ithmer
     1 ,itheq,ifhot,ichot,ithhot,iuhot,rhot
     1 ,it1,it2,jt1,jt2,x1,x2,y1,y2,iproj,mrsp,mapprj
     1  ,iftrig,ictrig,ithtrig)
      integer*2 fillcolor,fillstyle,polycolor
      character*50 abuf
      dimension arect(4)
      dimension urot(3,3),ax(5),ay(5)
      integer*2 icor(2,500)
      dimension ibuff(501)
      equivalence (ibuff(1),m),(ibuff(2),icor(1,1))
      common/dodeco/ xdod(20),ydod(20),zdod(20)
     1   ,ipldod(6,12),xcdod(12),ycdod(12),zcdod(12)
     1     ,azm1dod(12)
      integer*2 wkid,color
      data wkid/1/,color/4/
      radian=180./3.1415926
      call setrot(alphd/radian,betad/radian,gamad/radian,urot)


C      arect(1)=float(it1)/4096.
C      arect(2)=float(jt1)/4096.
C      arect(3)=float(it2)/4096.
C      arect(4)=float(jt2)/4096.
C      call gks_set_viewport(wkid,arect)
      arect(1)=x1
      arect(2)=y1
      arect(3)=x2
      arect(4)=y2
C      call gks_set_window(wkid,arect)
C      call gks_select_norm_transform(wkid)
C      fillstyle=iffill
C      call gks_set_fill_style(fillstyle)
C      fillcolor=iccnt
C      call gks_set_fill_area_color(fillcolor)
      call twindo(it1,it2,jt1,jt2)
      call dwindo(x1,x2,y1,y2)
      call filcol(iccnt)

      npts2=npts
      call rewfl(iu)
      icheck=1
      ifinit=1
  100 call bffin(iu,1,ibuff,501,j,mk)
      if(j.eq.3) go to 99
      call byswap4(ibuff,1)
      call byswap2(icor,2*500)
      if(m.eq.0) goto 99
      np=m/2
      x=float(icor(2,1))/10.
      y=float(icor(1,1))/10.
      call rotll(y,x,y,x,urot)
      if(x.lt.0.)x=x+360.
      call mapprj(x,y,iproj,xp,yp)
      call drawc(xp,yp,arect,0,ifinit)

      ifinit=0
      xs=x
      ys=y
      x0=x
      do 1 i=2,np
      x=float(icor(2,i))/10.
      y=float(icor(1,i))/10.
      call rotll(y,x,y,x,urot)
      if(x.lt.0.)x=x+360.
      dif=x-xs
      if(abs(dif).lt.350.)go to 133
      if(dif.lt.0.)vx=360.
      if(dif.gt.0.)vx=0.
      xf=amod(xs+180.,360.)-180.
      xt=amod(x+180.,360.)-180.
      ycc=(ys*xt-xf*y)/(xt-xf)
      call mapprj(vx,ycc,iproj,xp,yp)
      call drawc(xp,yp,arect,1,0)
      xn=vx
      yn=ycc
      xs=xn
      ys=yn
      vx=360.-vx
      call mapprj(vx,ycc,iproj,xp,yp)
      call drawc(xp,yp,arect,0,0)
      xs=vx
      ys=ycc
c
      if(ycc.lt.y1.or.ycc.gt.y2) goto 133
  133 call mapprj(x,y,iproj,xp,yp)
      call drawc(xp,yp,arect,1,0)
      xn=x
      yn=y
      xs=xn
      ys=yn
      goto 1
c
    1 continue
      goto 100

  99  continue

      if(icheck.ne.0) then
      if(iffill.ne.0) then
        call filcol(iccnt)
        if(iccou.ne.0) then
          call lincol(iccou)
          call linwdt(ithcou)
          call drcpolyfill(arect,-1,icocn,255)
        else
          call drcpolyfill(arect,-1,icocn,0)
        endif
      else
        call lincol(iccnt)
        call linwdt(ithcnt)
        call drcpolyline()
      endif

      if(ifmer.ne.0.and.mrsp.ne.0.) then
        do 500 ilalo=1,2
        if(ilalo.eq.1) then
          ncirc=180./float(mrsp)-1
          val=-90.
        else
          ncirc=360./float(mrsp)
          val=-float(mrsp)
        endif

        do 500 icirc=1,ncirc
        val=val+float(mrsp)

        if(ilalo.eq.1) then
          x=0.
        y=val
        else
          x=val
          y=-89.5
        endif
        call rotll(y,x,y,x,urot)
        if(x.lt.0.)x=x+360.
        call mapprj(x,y,iproj,xp,yp)
        call drawc(xp,yp,arect,0,1)
        xs=x
        ys=y
        x0=x
        do 501 i=2,121
        if(ilalo.eq.1) then
          x=float(i-1)*3.
          y=val
        else
          x=val
          y=float(i-1)*1.5-90.
          if(y.eq.90.) y=89.5
        endif
        call rotll(y,x,y,x,urot)
        if(x.lt.0.)x=x+360.
        dif=x-xs
        if(abs(dif).lt.350.)go to 533
        if(dif.lt.0.)vx=360.
        if(dif.gt.0.)vx=0.
        xf=amod(xs+180.,360.)-180.
        xt=amod(x+180.,360.)-180.
        ycc=(ys*xt-xf*y)/(xt-xf)
        call mapprj(vx,ycc,iproj,xp,yp)
        call drawc(xp,yp,arect,1,0)
        xn=vx
        yn=ycc
        xs=xn
        ys=yn
        vx=360.-vx
        call mapprj(vx,ycc,iproj,xp,yp)
        call drawc(xp,yp,arect,0,0)
        xs=vx
        ys=ycc
c
        if(ycc.lt.y1.or.ycc.gt.y2) goto 533
  533 call mapprj(x,y,iproj,xp,yp)
        call drawc(xp,yp,arect,1,0)
        xn=x
        yn=y
        xs=xn
        ys=yn
  501 continue

        ithmer1=ithmer
        if(ilalo.eq.1.and.abs(val).lt.1.) ithmer1=itheq
        call linwdt(ithmer1)
        call lincol(icmer)
        call drcpolyline()

  500   continue
      endif

C Triangular grid
      if(iftrig.ne.0) then
        call dodec()
        do ip=1,12
          do iv=1,5
            xla1=radian*asin(zdod(ipldod(iv,ip)))
            xlo1=radian*atan2(ydod(ipldod(iv,ip))
     1                         ,xdod(ipldod(iv,ip)))
            xla2=radian*asin(zdod(ipldod(iv+1,ip)))
            xlo2=radian*atan2(ydod(ipldod(iv+1,ip))
     1                         ,xdod(ipldod(iv+1,ip)))
            call gcircl(xla1,xlo1,xla2,xlo2,100,1
     1          ,ictrig,ithtrig,arect,urot,iproj)
          enddo
          if(ip.eq.1) then
            xla1=-89.9
            xlo1=0.
          else if(ip.eq.12) then
            xla1=89.9
            xlo1=0.
          else
            xla1=radian*asin(zcdod(ip))
            xlo1=radian*atan2(ycdod(ip),xcdod(ip))
          endif
          do iv=1,5
            xla2=radian*asin(zdod(ipldod(iv,ip)))
            xlo2=radian*atan2(ydod(ipldod(iv,ip))
     1                         ,xdod(ipldod(iv,ip)))
            call gcircl(xla1,xlo1,xla2,xlo2,100,1
     1          ,ictrig,ithtrig,arect,urot,iproj)
          enddo
        enddo
      endif

      ifinit=1
      ifdraw=0
      icheck=0
      if(ifplb.ne.0) goto 100

      else
C      polycolor=icplb
C      call gks_set_polyline_color(polycolor)
C      call gdc_poly_line(ithplb)
       call lincol(icplb)
       call linwdt(ithplb)
       call drcpolyline()
      endif

      if(ifcent.ne.0) then
c     ax(1)=x1
c     ax(2)=x2
c     ay(1)=.5*(y1+y2)
c     ay(2)=ay(1)
      call drawc(x1,.5*(y1+y2),arect,0,1)
      call drawc(x2,.5*(y1+y2),arect,1,0)
C     call gks_set_polyline_color(int2(icfram))
C      call gdc_poly_line(ithcen)
      call linwdt(ithcen)
      call lincol(icfram)
      call drcpolyline()
      endif

      if(ifram.ne.0) then
      ax(1)=x1
      ax(2)=x2
      ax(3)=ax(2)
      ax(4)=ax(1)
      ax(5)=ax(1)
      ay(1)=y1
      ay(2)=ay(1)
      ay(3)=y2
      ay(4)=ay(3)
      ay(5)=ay(1)
      ifdraw=0
      ifinit=1
      x=ax(1)
      y=ay(1)
      call mapprj(x,y,iproj,xp,yp)
      call drawc(xp,yp,arect,0,1)
      do i=2,5
      do j=1,100
      x=ax(i-1)+float(j)*(ax(i)-ax(i-1))/100.
      y=ay(i-1)+float(j)*(ay(i)-ay(i-1))/100.
      call mapprj(x,y,iproj,xp,yp)
      call drawc(xp,yp,arect,1,0)
      enddo
      enddo
C      call gks_set_polyline_color(int2(icfram))
C      call gdc_poly_line(ithfrm)
      call linwdt(ithfrm)
      call lincol(icfram)
      call drcpolyline()
      endif
      call tsend

      if(ifhot.eq.0) goto 88
      rewind iuhot
  86  read(iuhot,'(2f10.4)',end=87) xlo,xla
      call rotll(xla,xlo,xla,xlo,urot)
      if(xlo.lt.0.) xlo=xlo+360.
      call mapprj(xlo,xla,iproj,xp,yp)
C      call gks_set_polyline_color(int2(ichot))
      call lincol(ichot)
      afac=(x2-x1)/(y2-y1)
      call ellipse(xp,yp,arect,rhot*afac*float(jt2-jt1)
     1  /float(it2-it1),rhot,ithhot)
      goto 86
  87  continue

  88  continue
C      arect(1)=0.
C      arect(2)=0.
C      arect(3)=1.
C      arect(4)=.75
C      call gks_set_viewport(wkid,arect)
C      call gks_set_window(wkid,arect)
C      call gks_select_norm_transform(wkid)
      call tsend
      return
      end
