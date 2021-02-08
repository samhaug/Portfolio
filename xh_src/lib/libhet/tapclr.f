
C$**********************************************************************
CPROG TAPCLR
CXREF
      SUBROUTINE TAPCLR(ARR1,ARR2,NF,NE,IT1,IT2,SUM2)
      save
      DIMENSION ARR1(*),ARR2(*)
      ARGX=3.1415926536/FLOAT(IT2-IT1)
      CALL RFOUR(ARR1,8,-1) ! inverse fft 257 complex values from B.BIN to 514 time series values 16s/sample
      DO 1 I=1,514
    1 ARR2(I)=0.
      SUM2=0.
      DO 2 I=NF,NE
      SUM2=SUM2+ARR1(I)
    2 ARR2(I)=ARR1(I)
      SUM2=SUM2/FLOAT(NE-NF+1)
      DO 3 I=NF,NE          ! copy samples nf to ne to output array
    3 ARR2(I)=ARR2(I)-SUM2
      CALL RFOUR(ARR1,8,1)  ! leave original array as it was
      CALL RFOUR(ARR2,8,1)  ! fft arr2 back
      ARR2(1)=0.
      SUM2=0
      DO 4 I=2,257
      J=2*I-1
      IF(I.LE.IT1) TAP=1.
      IF(I.GE.IT2) TAP=0.
      IF(I.GT.IT1.AND.I.LT.IT2) TAP=0.5*(1.+COS(ARGX*FLOAT(I-IT1))) ! apply (by default) the cosine lopass 60s 45s taper
      ARR2(J)=ARR2(J)*TAP
      ARR2(J+1)=ARR2(J+1)*TAP
      SUM2=SUM2+ARR2(J)**2+ARR2(J+1)**2
    4 CONTINUE
      RETURN
      END
