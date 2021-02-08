C$**********************************************************************
      SUBROUTINE TCOEFP(E,C1,C2)
      save
      DIMENSION E(2)
      COMMON/IAP2/ B1ST,A2ST,BB1ST,AA2ST,DUMM(2)
      E21=E(2)-E(1)
      C1=A2ST*E(1)-B1ST*E21
      C2=AA2ST*E(1)-BB1ST*E21
      RETURN
      END
