      SUBROUTINE CLEAR(I1,I2,IMAX,DATA)
      save
      DIMENSION DATA(*)
      DOUBLE PRECISION SUMY,B
      NP=I2-I1+1
      SUMY=0.D0
      DO 1 I=I1,I2
    1 SUMY=SUMY+DATA(I)
      B=SUMY/DFLOAT(NP)
      DO 2 I=I1,I2
    2 DATA(I)=DATA(I)-B
      IF(I1.EQ.1) GO TO 4
      K=I1-1
      DO 3 I=1,K
    3 DATA(I)=0.
    4 IF(I2.EQ.IMAX) RETURN
      K=I2+1
      DO 5 I=K,IMAX
    5 DATA(I)=0.
      RETURN
      END
