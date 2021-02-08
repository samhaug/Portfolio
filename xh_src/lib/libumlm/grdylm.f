      subroutine grdylm(grid,igrid,ikla,iklo,coeffs,lmax,ifevn,ifnorm)
      parameter (maximl=12)
      parameter (maxil3=maximl+3)
      parameter (maxtlp=maximl*2+1)
      parameter (maxlen=(maximl+1)**2)
      dimension coeffs(1)
      double precision d
      common/grdwrk/y1(maxlen),wk1(maxil3),wk2(maxil3)
     1  ,wk3(maxil3),sar(maxil3)
     1  ,cosa(maxil3),sina(maxil3),d(maxtlp,maxtlp)
c
      dimension grid(igrid,1)
      radian=180./3.1415926535
      iz2=2
      ize=0
      write(6,1) iz2,lmax,ize,lmax
    1 format(' type lmin,lmax,mmin,mmax  -  default',4i3
     1  ,/'** ** ** **')
      read(5,2) lminp,lmaxp,mminp,mmaxp
    2 format(i2,3(1x,i2))
      if(lmaxp.gt.0) go to 89
      lminp=iz2
      lmaxp=lmax
      mminp=ize
      mmaxp=lmax
   89 lmaxp=min0(lmaxp,lmax)
      if(ifevn.ne.0) then
        lminp=2*((lminp+1)/2)
        lmaxp=2*(lmaxp/2)
        lstep=2
      else
        lstep=1
      endif
      lmaxm1=lmaxp+1

      stla=180./float(ikla-1)
      do 200 ilat=1,ikla
      xlat=90.-float(ilat-1)*stla
      call ylm(xlat,0.,lmaxp,y1,wk1,wk2,wk3)
      stlo=360./float(iklo-1)
      do 100 ilon=1,iklo
      phi=(float(ilon-1)*stlo)/radian
      sdif=sin(phi)
      cdif=cos(phi)
      sina(1)=0.
      cosa(1)=1.
      do 101 i=2,lmaxm1
      ii=i-1
      sina(i)=sina(ii)*cdif+cosa(ii)*sdif
      cosa(i)=cosa(ii)*cdif-sina(ii)*sdif
 101  continue
      sum=0.
      do 102 l1=lminp+1,lmaxp+1,lstep
      kbias=(l1-1)**2
      if(ifevn.eq.0) then
        nbias=(l1-1)**2
      else
        nbias=((l1-1)*(l1-2))/2
      endif
      m11=mminp+1
      m12=min0(l1,mmaxp+1)
      k=kbias+1
      do 103 m1=m11,m12
      fac=1.
      if(m1.eq.1.and.ifnorm.eq.1) fac=sqrt(.5)
      if(m1.eq.1) then
        kadd=1
      else
        kadd=2*(m1-1)
      endif
      k=kbias+kadd
      n=nbias+kadd
      add=y1(k)*coeffs(n)*cosa(m1)*fac
      sum=sum+add
      if(ilat.eq.1.and.ilon.eq.1)
     1  write(6,'(''l='',i2,'' m='',i2,''  coef:'',f20.12)')
     1   l1-1,m1-1,coeffs(n)
      if(m1.eq.1) goto 103
      n1=n+1
      add=y1(k)*coeffs(n1)*sina(m1)*fac
      sum=sum+add
      if(ilat.eq.1.and.ilon.eq.1)
     1  write(6,'(''  '',2x,''   '',2x,''  coef:'',f20.12)')
     1   coeffs(n1)
      k=k+1
  103 k=k+1
  102 continue
  100 grid(ilat,ilon)=sum
  200 continue
      return
      end
