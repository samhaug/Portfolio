
C$**********************************************************************
      SUBROUTINE MTORS
      save
      COMMON/INTAP/ JSTAT,IDUM(15)
      COMMON/AP2/ T(437),O(437),Q(437),G(437),E(437),U(1311),P(5244)
      NN=1
  100 IND=(NN-1)*3+1
      IND1=(NN-1)*12+1
      CALL PROCES(T(NN),O(NN),Q(NN),G(NN),E(NN),U(IND),P(IND1))
      IF(JSTAT.NE.0) RETURN
      NN=NN+1
      IF(NN.LE.437) GO TO 100
      RETURN
      END
