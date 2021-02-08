      subroutine makemom(scmom,phs,del,rlam,eta,xtr,fmom)

c     This routine is the inverse of eqpar()
c     Fault angles are:
c     phs    Input: strike azimuth (clockwise from N).
c            Convention is that the fault dips
c            to the right when looking along the strike azimuth.
c     del    fault dip
c     rlam   'rake' angle
c            Conventions is that:
c            rlam=  0, del=90  --> left lateral strike-slip
c            rlam= 90, del=45  --> thrust fault
c            rlam=-90, del=45  --> normal fault
c     scmom  (the scalar moment) is the average of
c            the largest eigenvalue and the negative of the smallest
c            eigenvalue.
c     eta    is the ratio of the intermediate eigenvalue to the
c            scalar moment. For a double couple, eta=0.
c     xtr    is the ratio of the trace of the moment tensor to the
c            scalar moment. If there is no volumetric component, xtr=0.
c
c     Thus the three eigenvalues, in increasing order (P,N,T) are
c       evp=scmom*(-1.-.5*eta+.5*xtr)
c       evn=scmom*(       eta       )
c       evt=scmom*( 1.-.5*eta+.5*xtr)
c


      real fmom(6),d(3),e(3),n(3),p(3),b(3),t(3),sv(3)
      data radian/57.29577951/
      data hsq2/.70710678/

      ph=phs/radian
      de=del/radian
      rl=rlam/radian
       

c     Components (1,2,3) are (Up,S,E) = (r,theta,phi)

c     Vector sv is a horizontal vector along strike
      sv(1)=0.
      sv(2)=-cos(ph)
      sv(3)=sin(ph)

c     Vector d points down-dip at azimuth phs+90
      d(1)=-sin(de)
      d(2)=cos(de)*sin(ph)
      d(3)=cos(de)*cos(ph)

c     Vector n is the fault normal: d x sv,
c     Pointing out of the foot wall, into the hanging wall
c     and having, therefore, a positive up component (0 < del < 90).
      n(1)=cos(de)
      n(2)=sin(de)*sin(ph)
      n(3)=sin(de)*cos(ph)

c     Vector e is the slip vector representing the motion
c     of the hanging wall relative to the foot wall.
c     Rake is defined so that rlam=0 for e along strike,
c     and rlam=-90 for e along d (a normal fault).
c     I.e. rlam is measured anticlockwise from above --
c     the opposite of the Aki & Richards convention for rake.
      e(1)=sv(1)*cos(rl)-d(1)*sin(rl)
      e(2)=sv(2)*cos(rl)-d(2)*sin(rl)
      e(3)=sv(3)*cos(rl)-d(3)*sin(rl)

c     Vector b is the null-axis: e x n (sign arbitrary)
      b(1)=e(2)*n(3)-e(3)*n(2)
      b(2)=e(3)*n(1)-e(1)*n(3)
      b(3)=e(1)*n(2)-e(2)*n(1)

c     Vector t is the T-axis (sign arbitrary)
      t(1)=hsq2*(e(1)+n(1))
      t(2)=hsq2*(e(2)+n(2))
      t(3)=hsq2*(e(3)+n(3))

c     Vector p is the P-axis (sign arbitrary)
      p(1)=hsq2*(e(1)-n(1))
      p(2)=hsq2*(e(2)-n(2))
      p(3)=hsq2*(e(3)-n(3))

c     Eigenvalues
      evp=scmom*(-1.-.5*eta+.5*xtr)
      evn=scmom*eta
      evt=scmom*( 1.-.5*eta+.5*xtr)

      fmom(1)=evp*p(1)*p(1)+evn*b(1)*b(1)+evt*t(1)*t(1) ! Mrr
      fmom(2)=evp*p(2)*p(2)+evn*b(2)*b(2)+evt*t(2)*t(2) ! Mtt
      fmom(3)=evp*p(3)*p(3)+evn*b(3)*b(3)+evt*t(3)*t(3) ! Mpp
      fmom(4)=evp*p(1)*p(2)+evn*b(1)*b(2)+evt*t(1)*t(2) ! Mrt
      fmom(5)=evp*p(1)*p(3)+evn*b(1)*b(3)+evt*t(1)*t(3) ! Mrp
      fmom(6)=evp*p(2)*p(3)+evn*b(2)*b(3)+evt*t(2)*t(3) ! Mtp

      return
      end
