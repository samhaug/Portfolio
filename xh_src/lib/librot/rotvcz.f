c-----------------------------------------------------------
      subroutine rotvcz(amdl,lmax,npar,alph,bmdl)
      dimension amdl(*),bmdl(*)
      leny=(lmax+1)**2
      k=0
      do l=0,lmax
        e1=1.0
        e2=0.0
        s1=cos(alph)
        s2=sin(alph)
        do m=0,l
          k=k+1
          k1=k+1
          if(m.eq.0) then
            kk=k
            do ipar=1,npar
              bmdl(kk)=amdl(kk)
              kk=kk+leny
            enddo
          else
            kk=k
            do ipar=1,npar
              kk1=kk+1
              tsave=    amdl(kk)*e1+amdl(kk1)*e2
              bmdl(kk1)=amdl(kk1)*e1-amdl(kk)*e2
              bmdl(kk)=tsave
              kk=kk+leny
            enddo
            k=k1
          endif
          es=e1*s1-e2*s2
          e2=e1*s2+e2*s1
          e1=es
        enddo
      enddo
      return
      end
