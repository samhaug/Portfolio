
C$**********************************************************************
      SUBROUTINE STABLP(XL)
      save
      COMMON/AP1/ DUM1(17),F4,F5,F6,F2PF3,F2MF3,DUM2(4)
      COMMON/IAP1/ XX(2,3),VV(2,3),FILL2(20)
      COMMON/IAP2/ B1C,A2C,BB1C,AA2C,X,DUMM2
      X=.5*XL*(XL+1.)
      F62=2.*F6
      B1C=F4*XX(1,2)+F5*XX(2,2)
      A2C=F2MF3*XX(1,3)+F62*XX(2,3)
      BB1C=F4*VV(1,2)+F5*VV(2,2)
      AA2C=F2MF3*VV(1,3)+F62*VV(2,3)
      RETURN
      END
