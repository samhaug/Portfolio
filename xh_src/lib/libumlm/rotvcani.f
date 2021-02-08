c--------------------------------------------------------

      subroutine rotvcani(
     1     c0,c2,c4,lmax0,lmax2,lmax4
     1     ,alph,beta,gama,d,vec1,vec2
     1     ,c0r,c2r,c4r)



c Dimensions of input and output vectors. The
c dimension statement has no effect unless array bound
c checking is in effect, but is included as an aide memoire

      dimension 
     1  c0((lmax0+1)**2)
     1 ,c0r((lmax0+1)**2)
      complex
     1  c2((lmax2-1)*(lmax2+3))
     1 ,c4((lmax4-3)*(lmax4+5))
     1 ,c2r((lmax2-1)*(lmax2+3))
     1 ,c4r((lmax4-3)*(lmax4+5))

c workspace: lmax = max(lmax0,lmax2,lmax4)

      double precision d(*)         ! dimension at least (2*lmax+1)**2 d.p.
      complex vec1(0:*),vec2(0:*)   ! dimension at least (2*lmax+1) complex
     
      double precision dbeta
      complex ealph,egama
      lmax=max(lmax0,lmax2,lmax4)
      dbeta=beta
      do l=0,lmax
        call rotmx2(l,l,dbeta,d,2*l+1,2*l+1)
        ealph=cexp(cmplx(0.,alph))
        egama=cexp(cmplx(0.,gama))
     
        if(l.le.lmax0) then
        
          k0=l**2
          k=k0
          sgn=1
          do m=0,l
            if (m.eq.0) then
              k=k+1
              vec1(l+m)=cmplx(c0(k),0.)
            else
              k=k+1
              vec1(l+m)=cmplx(.5*c0(k),-.5*c0(k+1))
              k=k+1
              vec1(l-m)=sgn*conjg(vec1(l+m))
            endif
            sgn=-sgn
          enddo
          call crotl(d,l,ealph,egama,vec1,vec2)
          k=k0
          do m=0,l
            if(m.eq.0) then
              k=k+1
              c0r(k)=real(vec2(l+m))
            else
              k=k+1
              c0r(k)=2.*real(vec2(l+m))
              k=k+1
              c0r(k)=-2.*aimag(vec2(l+m))
            endif
          enddo
        endif

        if(l.ge.2.and.l.le.lmax2) then
          k0=l**2-4
          k=k0
          do m=0,l
            k=k+1
            vec1(l+m)=c2(k)
            if(m.ne.0) then
              k=k+1
              vec1(l-m)=c2(k)
            endif
          enddo
          call crotl(d,l,ealph,egama,vec1,vec2)
          k=k0
          do m=0,l
            k=k+1
            c2r(k)=vec2(l+m)
            if(m.ne.0) then
              k=k+1
              c2r(k)=vec2(l-m)
            endif
          enddo
        endif


        if(l.ge.4.and.l.le.lmax4) then
          k0=l**2-16
          k=k0
          do m=0,l
            k=k+1
            vec1(l+m)=c4(k)
            if(m.ne.0) then
              k=k+1
              vec1(l-m)=c4(k)
            endif
          enddo
          call crotl(d,l,ealph,egama,vec1,vec2)
          k=k0
          do m=0,l
            k=k+1
            c4r(k)=vec2(l+m)
            if(m.ne.0) then
              k=k+1
              c4r(k)=vec2(l-m)
            endif
          enddo
        endif

      enddo               ! end of do loop over l
      return
      end
