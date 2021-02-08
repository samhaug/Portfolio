
C$**********************************************************************
CPROG SPLINE
CXREF
      SUBROUTINE SPLINE(F1,FP1,F2,FP2,V,VP,VPP)
      save
      COMMON/SPLIN/ Y,HN,HN2,HN3,RHN,IR1
      A=HN3*(HN*(FP1+FP2)+2.*(F1-F2))
      B=HN2*(3.*(F2-F1)-HN*(FP2+2.*FP1))
      V=F1+Y*(FP1+Y*(B+Y*A))
      VP=FP1+Y*(2.*B+3.*Y*A)
      VPP=2.*B+6.*Y*A
      RETURN
      END
