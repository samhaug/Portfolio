
C$**********************************************************************
      SUBROUTINE TTABLP
      save
      COMMON/AP1/ DUM1(17),F4,F5,F6,F2PF3,F2MF3,DUM2(4)
      COMMON/IAP1/ XX(12),Y(2,3),W(2,3),ADD1(8)
      COMMON/IAP2/ B1ST,A2ST,BB1ST,AA2ST,DUMM(2)
      F62=2.*F6
      B1ST=F4*Y(2,2)-F5*Y(1,2)
      A2ST=F2MF3*Y(2,3)-F62*Y(1,3)
      BB1ST=F4*W(2,2)-F5*W(1,2)
      AA2ST=F2MF3*W(2,3)-F62*W(1,3)
      RETURN
      END
