c-------------------------------------------------------------
c        subroutine ylmv(xlat,xlon,lmax,y,ypp,ytp,d)
c
c  evaluates the vectors ypp,ytp, of length lenv=(lmax-1)*(2*lmax+6)
c  which represent contributions to the symmetric trace-free
c  tensor in spherical coordinates (theta=colatitiude, phi=longitude)
c
c    ( c(theta theta)  c(theta phi) )
c    ( c(phi theta)    c(phi phi)   )
c
c  i.e. c(phi phi)   = -c(theta theta) = ypp . coefs
c       c(theta phi) = c(phi theta)    = ytp . coefs
c 
c     Scalar shperical harmonics are also calculated and
c     placed in y(1) -- y( (lmax+1)**2 )
c
c     The companion routine ylmavv() (q.v.) calculates the
c     contribution to the average value of  l.c.l
c     along the minor arc and the complete great circle,
c     where 'l' represents the tangent to the path:
c         
c           l_theta = -cos(az)      l_phi = sin(az)
c 
c     and az is the local azimuth of the path.
c
c     Hence l.c.l = -c(phi phi)*cos(2*az)-c(theta phi)*sin(2*az)
c----------------------------------------------------------------
c     'd' is d.p. workspace.
c----------------------------------------------------------------
      subroutine ylmv(xlat,xlon,lmax,y,ypp,ytp,d)
      dimension y((lmax+1)**2)
     1         ,ypp((lmax-1)*(2*lmax+6))
     1         ,ytp((lmax-1)*(2*lmax+6))
      double precision theta,d(5*(2*lmax+1))
      complex cfac,dfac
      data radian/57.2957795/,rr4pi/0.28209479/
      theta=(90.-xlat)/radian
      dfac=cexp(cmplx(0.,xlon/radian))
      k=0
      ka=0
      do l=0,lmax
        if(l.lt.2) then
          call rotmx2(0,l,theta,d,1,2*l+1)
          ind=l
          cfac=rr4pi*sqrt(2.*l+1)
          do m=0,l
            k=k+1
            ind=ind+1
            y(k)=d(ind)*real(cfac)
            if(m.ne.0) then
              k=k+1
              y(k)=d(ind)*aimag(cfac)
            endif
            cfac=cfac*dfac
          enddo
        else
          call rotmx2(2,l,theta,d,5,2*l+1)
          ind=5*l+3
          indp=ind+2
          indm=indp
          cfac=rr4pi*sqrt(2.*l+1)
          do m=0,l
            k=k+1
            y(k)=d(ind)*real(cfac)
            ka=ka+1
            ypp(ka)=-d(indp)*real(cfac)
            ytp(ka)=-d(indp)*aimag(cfac)
            ka=ka+1
            ypp(ka)=+d(indp)*aimag(cfac)
            ytp(ka)=-d(indp)*real(cfac)
            if(m.ne.0) then
              k=k+1
              y(k)=d(ind)*aimag(cfac)
              ka=ka+1
              ypp(ka)=-d(indm)*real(cfac)
              ytp(ka)=+d(indm)*aimag(cfac)
              ka=ka+1
              ypp(ka)=-d(indm)*aimag(cfac)
              ytp(ka)=-d(indm)*real(cfac)
            endif
            ind=ind+5
            indp=indp+5
            indm=indm-5
            cfac=cfac*dfac
          enddo
        endif
      enddo
      return
      end


