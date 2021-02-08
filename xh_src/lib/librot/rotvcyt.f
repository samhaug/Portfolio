
c-----------------------------------------------------------
      subroutine rotvcyt(amdl,lmax,npar,beta,vec1,d,bmdl)
      dimension amdl((lmax+1)**2,npar),bmdl((lmax+1)**2,npar),vec1(*)
      double precision d(-lmax:lmax,-lmax:lmax),dbeta
      leny=(l+1)**2
      dbeta=beta
      k=0
      do l=0,lmax
        lsq=l*l
        call rotmx2(l,l,dbeta,d(-l,-l),2*lmax+1,2*lmax+1)
        do ipar=1,npar
          k=0
          sn=1.0
          do m=0,l
            k=k+1
            k1=k+1
            vec1(k)=0.0
            vec1(k1)=0.0
            if(m.eq.0) then
              n=l**2
              do mm=0,l
                n=n+1
                n1=n+1
                if(mm.eq.0) then
                  vec1(k)=d(mm,m)*amdl(n,ipar)
                else
                  vec1(k)=vec1(k)+2.0*d(mm,m)*amdl(n,ipar)
                  n=n1
                endif
              enddo
            else
              n=l**2
              do mm=0,l
                n=n+1
                n1=n+1
                if(mm.eq.0) then
                  vec1(k)=d(mm,m)*amdl(n,ipar)
                else
                  dd=sn*d(mm,-m)
                  vec1(k)=vec1(k)+(d(mm,m)+dd)*amdl(n,ipar)
                  vec1(k1)=vec1(k1)+(d(mm,m)-dd)*amdl(n1,ipar)
                  n=n1
                endif
              enddo
              k=k1
            endif
            sn=-sn
          enddo
          n=l**2
          do k=1,2*l+1
            n=n+1
            bmdl(n,ipar)=vec1(k)
          enddo
        enddo
      enddo
      return
      end
