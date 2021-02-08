
C$**********************************************************************
      SUBROUTINE TAPCLA(ARR1,ARR2,NF,NE,IT1,IT2)
      save
      DIMENSION ARR1(*),ARR2(*)
      ARG=3.14159265/FLOAT(IT2-IT1)
      CALL RFOUR(ARR1,8,-1)
      CALL FVCLR(ARR2,1,514)
      SUM2=0.
      DO 2 I=NF,NE
      SUM2=SUM2+ARR1(I)
    2 ARR2(I)=ARR1(I)
      SUM2=SUM2/FLOAT(NE-NF+1)
      DO 3 I=NF,NE
    3 ARR2(I)=ARR2(I)-SUM2
      CALL RFOUR(ARR2,8,1)
      DO 4 I=2,257
      IF(I.LE.IT1) SUM2=1.
      IF(I.GE.IT2) SUM2=0.
      IF(I.GT.IT1.AND.I.LT.IT2) SUM2=0.5*(1.+COS(ARG*FLOAT(I-IT1)))
      J=2*I-1
      ARR2(J)=ARR2(J)*SUM2
      ARR2(J+1)=ARR2(J+1)*SUM2
    4 CONTINUE
      CALL RFOUR(ARR2,8,-1)
      RETURN
      END
