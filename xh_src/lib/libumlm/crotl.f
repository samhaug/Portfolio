c--------------------------------------------------
c perform spherical harmonic rotation assuming
c that the matrix d(beta) and the values
c ealph=exp( i alpha) egama=exp( i gama) have
c already been calculated. This is called by
c rotvcani()

      subroutine crotl(d,l,ealph,egama,vec1,vec2)
      complex ealph,egama,vec1(-l:l),vec2(-l:l)
      double precision d(-l:l,-l:l)
      complex fct
      fct=ealph
      do m=1,l
        vec1(m)=vec1(m)*fct
        vec1(-m)=vec1(-m)*conjg(fct)
        fct=fct*ealph
      enddo
      do m=-l,l
        vec2(m)=(0.,0.)
        do mp=-l,l
          vec2(m)=vec2(m)+d(m,mp)*vec1(mp)
        enddo
      enddo
      fct=egama
      do m=1,l
        vec2(m)=vec2(m)*fct
        vec2(-m)=vec2(-m)*conjg(fct)
        fct=fct*egama
      enddo
      return
      end
