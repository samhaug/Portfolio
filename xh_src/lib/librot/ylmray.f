c-----------------------------------------------------------

      subroutine ylmray(epla,eplo,azim,csa,lmax,npar,y)

c     calculate ylm((lmax+1)**2) at the points at distances del
c     from (epla,eplo) in the azimuth azim, using an array
c     csa(2*lmax+1,npar) containing 1,(cos(m*del),sin(m*del),m=1,lmax)
c     and using coefficients piyvals previously calculated by
c     piylms().

      dimension csa(2*lmax+1,npar),y((lmax+1)**2,npar)
c     CHANGE MXL IN PIYLMS TOGETHER WITH THIS MXL
      include 'maxl.h'
c     parameter (MXL=40)
      common/piyls/ipidid,piyvals( (MXL+1)**2 )
      double precision d((2*MXL+1)**2),vec1(2*MXL+1)
      data radian/57.2957795/

      if(lmax.gt.MXL) stop'ylmray: lmax.gt.MXL'

      az=azim/radian
      ea=epla/radian
      eo=eplo/radian

      caz=cos(az)
      saz=sin(az)
      cea=cos(ea)
      sea=sin(ea)
      alph=eo+atan2(-caz,-saz*sea)
      beta=acos(saz*cea)
      gama=atan2(caz*cea,-sea)

      k=0
      do l=0,lmax
        n=0
        do m=0,l
          k=k+1
          k1=k+1
          n=n+1
          n1=n+1
          if(mod(l+m,2).eq.0) then
            if(m.eq.0) then
              do j=1,npar
                y(k,j)=piyvals(k)*csa(n,j)
              enddo
            else
              do j=1,npar
                y(k,j)=piyvals(k)*csa(n,j)
                y(k1,j)=piyvals(k)*csa(n1,j)
              enddo
              k=k1
              n=n1
            endif
          else
            if(m.eq.0) then
              do j=1,npar
                y(k,j)=0.0
              enddo
            else
              do j=1,npar
                y(k,j)=0.0
                y(k1,j)=0.0
              enddo
              k=k1
              n=n1
            endif
          endif
        enddo
      enddo
      call rotvc1t(y,lmax,npar,alph,beta,gama,d,vec1,y)
      return
      end
