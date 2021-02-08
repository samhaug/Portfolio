c-------------------------------------------------------------
c  subroutine ylmavv4(xlat1,xlon1,xlat2,xlon2,lmax,ylmh,ylmt
c    1   ,yllh,yllt,yllllh,yllllt
c    1   ,sar,d,dpi2)
c
c    evaluates the vectors yllh,yllt, of length lenv=(lmax-1)*(2*lmax+6)
c    which represent contributions to the average value of c_ll ( = l.c.l)
c    along the complete great circle and the minor arc, respecitively,
c    defined by (xlat1,xlon1), (xlat2,xlon2).
c    'c' is a symmetric trace-free tensor field; in spherical
c    coordinates ('t'=theta=colatitiude, 'p'=phi=longitude)
c
c    ( c_tt  c_tp )
c    ( c_pt  c_pp )
c
c       c_pp   = -c_tt = ypp . coefs
c       c_tp = c_pt    = ytp . coefs
c
c     where ypp, ytp represent the quantities calculated in
c     the companion routine ylmv4() (q.v.)
c
c     Similarly, yllllh, yllllt are the great circle and minor
c     arc averages of e_llll where 'e' is a completely symmetric,
c     completely trace-free fourth rank tensor.
c
c
c     in terms of the local azimuth 'az' of the path:
c
c           l_t = -cos(az)      l_p = sin(az)
c 
c
c     Hence  c_ll   = -  c_pp * cos(2*az) - c_tp * sin(2*az)
c            e_llll =  e_pppp * cos(4*az) + e_tppp * sin(4*az)
c
c 
c     Mean values of the scalar shperical harmonics are also calculated and
c     placed in ylmh(k), ylmt(k), k=1,(lmax+1)**2.
c
c
c----------------------------------------------------------------
c     'd' and dpi2 are d.p. workspace arrays.
c     Notice that dpi2 must be bigger than in ylmavv().
c     'sar' is single precision workspace.
c----------------------------------------------------------------
      subroutine ylmavv4(xlat1,xlon1,xlat2,xlon2,lmax,ylmh,ylmt
     1   ,yllh,yllt,yllllh,yllllt
     1   ,sar,d,dpi2)
      dimension ylmh((lmax+1)**2),ylmt((lmax+1)**2)
     1   ,yllh((lmax-1)*(2*lmax+6)),yllt((lmax-1)*(2*lmax+6))
     1   ,yllllh((lmax-3)*(2*lmax+10)),yllllt((lmax-3)*(2*lmax+10))
      double precision d((2*lmax+1)*(2*lmax+1)),dpi2(9*(2*lmax+1))
      dimension sar(lmax+1)
      double precision dcth,dp2
      complex eimal,eial,temp,temp1,eimpga,eiga,temp4,temp14
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
        nmax=min0(l,4)
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

        if(l.ge.4) then
          eimal=rr4pi*sqrt(2.*l+1)*cexp(cmplx(0.,-l*cph))
          do m=-l,l
            ia0m=(2*l+1)*(m+l)+l+1 ! address of d(0,m)
            eimpga=cexp(cmplx(0.,-l*phmp))
            temp=(0.,0.)
            temp4=(0.,0.)
            do mp=-l,l
              ia0mp=(2*nmax+1)*(mp+l)+nmax+1 ! address of dpi2(0,mp)
              imp=iabs(mp)+1
              arg=mp*phmp
              temp=temp+dpi2(ia0mp+2)*sar(imp)*d(mp+ia0m)*eimpga
              temp4=temp4+dpi2(ia0mp+4)*sar(imp)*d(mp+ia0m)*eimpga
              eimpga=eimpga*eiga
            enddo
            temp=temp*eimal
            temp4=temp4*eimal
            temp1=dpi2((2*nmax+1)*l+nmax+3)*d(ia0m)*eimal ! only mp=0
            temp14=dpi2((2*nmax+1)*l+nmax+5)*d(ia0m)*eimal ! only mp=0
            if(m.le.0) then
              ka=(l-2)*(2*l+4)-4*m+1
              ka4=(l-4)*(2*l+8)-4*m+1
            else
              ka=(l-2)*(2*l+4)+4*m-1
              ka4=(l-4)*(2*l+8)+4*m-1
            endif
            yllt(ka)=-real(temp)
            yllt(ka+1)=aimag(temp)
            yllh(ka)=-real(temp1)
            yllh(ka+1)=aimag(temp1)
            yllllt(ka4)=-real(temp4)
            yllllt(ka4+1)=aimag(temp4)
            yllllh(ka4)=-real(temp14)
            yllllh(ka4+1)=aimag(temp14)
            eimal=eimal*eial
          enddo
        endif


      enddo

      return
      end

