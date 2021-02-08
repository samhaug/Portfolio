      subroutine grdylma(grid,igrid,ikla,iklo,del12,ycofs,lhigh
     1   ,lmin,lmax,ifeven,alphd,betad,gamad)
      dimension ycofs(*),grid(igrid,*)

      parameter (MXORD=50)
      dimension y1((MXORD+1)**2),wk1(MXORD+1),wk2(MXORD+1),wk3(MXORD+1)
     1         ,sina(MXORD+1),cosa(MXORD+1)
     1         ,vec1(2,2*MXORD+1),vec2(2,2*MXORD+1),ycofsr((MXORD+1)**2)
      double precision dmat(2*MXORD+1,2*MXORD+1)

      radian=180./3.1415926535
      lmaxp=min0(lmax,lhigh)
      if(lmaxp.gt.MXORD) stop 'grdylma:  increase work space'
      ind1=lmin**2+1

      if(alphd.ne.0..or.betad.ne.0..or.gamad.ne.0.) then
        call rotvc(ycofs,lmaxp,1
     1     ,alphd/radian,betad/radian,gamad/radian
     1     ,dmat,vec1,vec2,ycofsr)
      else
        do k=1,(lmaxp+1)**2
          ycofsr(k)=ycofs(k)
        enddo
      endif

      stla=180./float(ikla-1)
      do ilat=1,ikla
        xlat=90.-float(ilat-1)*stla
        call ylm(xlat,0.,lmaxp,y1,wk1,wk2,wk3)

        if(ifeven.ne.0) then
          k=0
          do ll=0,lmaxp
            imll=mod(ll,2)
            do mm=-ll,ll
              k=k+1
              if(imll.ne.0) y1(k)=0.
            enddo
          enddo
        endif
        do k=1,lmin**2
          ycofsr(k)=0.
        enddo

        stlo=del12/float(iklo-1)
        do ilon=1,iklo
          phi=(float(ilon-1)*stlo)/radian
          sdif=sin(phi)
          cdif=cos(phi)
          sina(1)=0.
          cosa(1)=1.
          do i=2,lmaxp+1
            ii=i-1
            sina(i)=sina(ii)*cdif+cosa(ii)*sdif
            cosa(i)=cosa(ii)*cdif-sina(ii)*sdif
          enddo
          k=0
          sum=0.
          do l1=1,lmaxp+1
            do m1=1,l1
              k=k+1
              sum=sum+y1(k)*ycofsr(k)*cosa(m1)
              if(m1.ne.1) then
                k1=k+1
                sum=sum+y1(k)*ycofsr(k1)*sina(m1)
                k=k1
              endif
            enddo
          enddo
          grid(ilat,ilon)=sum
        enddo
      enddo
      return
      end

