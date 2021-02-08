CBEND

C$**********************************************************************
      SUBROUTINE SCOEFP(E,C1,C2)
      save
      DIMENSION E(4)
      COMMON/IAP1/ X0C,DUMM1(5),V0C,DUMM2(25)
      COMMON/IAP2/ B1C,A2C,BB1C,AA2C,XJ,DUM4
      COMMON/AP1/ DUM1(14),F1,DUM2(5),F2PF3,DUM3(5)
      XK=E(2)*F1+(E(1)-XJ*E(3))*F2PF3
      YK=E(4)+E(1)-E(3)
      C1=X0C*XK-B1C*YK+A2C*E(3)
      C2=V0C*XK-BB1C*YK+AA2C*E(3)
      RETURN
      END
