
C$**********************************************************************
      SUBROUTINE MSFER
      save
      COMMON/INTAP/ JSTAT,IDUM(15)
      COMMON/AP2/ T(380),O(380),Q(380),G(380),E(380),U(2280),P(4560)
      NN=1
  100 IND=(NN-1)*6+1
      IND1=(NN-1)*12+1
      CALL PROCES(T(NN),O(NN),Q(NN),G(NN),E(NN),U(IND),P(IND1))
      IF(JSTAT.NE.0) RETURN
      NN=NN+1
      IF(NN.LE.380) GO TO 100
      RETURN
      END
