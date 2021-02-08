c-------------------------------------------------------------
c  subroutine ylmavv(xlat1,xlon1,xlat2,xlon2,lmax,ylmh,ylmt
c    1   ,yllh,yllt
c    1   ,sar,d,dpi2)
c
c    evaluates the vectors yllh,yllt, of length lenv=(lmax-1)*(2*lmax+6)
c    which represent contributions to the average value of l.c.l
c    along the complete great circle and the minor arc, respecitively,
c    defined by (xlat1,xlon1), (xlat2,xlon2).
c    'c' is a symmetric trace-free tensor field; in spherical
c    coordinates (theta=colatitiude, phi=longitude)
c
c    ( c(theta theta)  c(theta phi) )
c    ( c(phi theta)    c(phi phi)   )
c
c       c(phi phi)   = -c(theta theta) = ypp . coefs
c       c(theta phi) = c(phi theta)    = ytp . coefs
c
c     where ypp, ytp represent the quantities calculated in
c     the companion routine ylmv() (q.v.)
c
c
c     in terms of the local azimuth 'az' of the path:
c
c           l_theta = -cos(az)      l_phi = sin(az)
c 
c
c     Hence l.c.l = -c(phi phi)*cos(2*az)-c(theta phi)*sin(2*az)
c
c 
c     Mean values of the scalar shperical harmonics are also calculated and
c     placed in ylmh(k), ylmt(k), k=1,(lmax+1)**2.
c
c
c----------------------------------------------------------------
c     'd' and dpi2 are d.p. workspace arrays.
c     'sar' is single precision workspace.
c----------------------------------------------------------------
      subroutine ylmavv(xlat1,xlon1,xlat2,xlon2,lmax,ylmh,ylmt
     1   ,yllh,yllt
     1   ,sar,d,dpi2)
      dimension ylmh((lmax+1)**2),ylmt((lmax+1)**2)
     1   ,yllh((lmax-1)*(2*lmax+6)),yllt((lmax-1)*(2*lmax+6))
      double precision d((2*lmax+1)*(2*lmax+1)),dpi2(5*(2*lmax+1))
      dimension sar(lmax+1)
      double precision dcth,dp2
      complex eimal,eial,temp,temp1,eimpga,eiga
      data radian/57.2957795/,rr4pi/0.28209479/

      call pole(xlat1,xlon1,xlat2,xlon2,xlatp,xlonp,azmp,delta)
      del=delta/radian
      cth=(90.-xlatp)/radian
      dcth=cth
      dp2=90./radian
      cph=xlonp/radian
      phmp=(180.-azmp)/radian
      sar(1)=1.
      do m=1,lmax
        arg=.5*m*del
        sar(m+1)=sin(arg)/arg
      enddo
      eial=cexp(cmplx(0.,cph))
      eiga=cexp(cmplx(0.,phmp))

      k=0
      do l=0,lmax
        nmax=min0(l,2)
        call  rotmx2(nmax,l,dp2,dpi2,2*nmax+1,2*l+1)
        call  rotmx2(l,l,dcth,d,2*l+1,2*l+1)

        eimal=rr4pi*sqrt(2.*l+1)
        do m=0,l
          ia0m=(2*l+1)*(m+l)+l+1 ! address of d(0,m)
          eimpga=cexp(cmplx(0.,-l*phmp))
          temp=(0.,0.)
          do mp=-l,l
            ia0mp=(2*nmax+1)*(mp+l)+nmax+1 ! address of dpi2(0,mp)
            imp=iabs(mp)+1
            arg=mp*phmp
            temp=temp+dpi2(ia0mp)*sar(imp)*d(mp+ia0m)*eimpga
            eimpga=eimpga*eiga
          enddo
          temp=temp*eimal
          temp1=dpi2((2*nmax+1)*l+nmax+1)*d(ia0m)*eimal
          k=k+1
          ylmt(k)=real(temp)
          ylmh(k)=real(temp1)
          if(m.ne.0) then
            k=k+1
            ylmt(k)=aimag(temp)
            ylmh(k)=aimag(temp1)
          endif
          eimal=eimal*eial
        enddo
        
        if(l.ge.2) then
          eimal=rr4pi*sqrt(2.*l+1)*cexp(cmplx(0.,-l*cph))
          do m=-l,l
            ia0m=(2*l+1)*(m+l)+l+1 ! address of d(0,m)
            eimpga=cexp(cmplx(0.,-l*phmp))
            temp=(0.,0.)
            do mp=-l,l
              ia0mp=(2*nmax+1)*(mp+l)+nmax+1 ! address of dpi2(0,mp)
              imp=iabs(mp)+1
              arg=mp*phmp
              temp=temp+dpi2(ia0mp+2)*sar(imp)*d(mp+ia0m)*eimpga
              eimpga=eimpga*eiga
            enddo
            temp=temp*eimal
            temp1=dpi2((2*nmax+1)*l+nmax+3)*d(ia0m)*eimal ! only mp=0
            if(m.le.0) then
              ka=(l-2)*(2*l+4)-4*m+1
            else
              ka=(l-2)*(2*l+4)+4*m-1
            endif
            yllt(ka)=-real(temp)
            yllt(ka+1)=aimag(temp)
            yllh(ka)=-real(temp1)
            yllh(ka+1)=aimag(temp1)
            eimal=eimal*eial
          enddo
        endif

      enddo

      return
      end

