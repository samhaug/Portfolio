
C$**********************************************************************
CXREF
      SUBROUTINE STRINV(NPAR,NSOL,NEVUS)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      REAL CONTR
      save
      COMMON/BIGSPA/ IFL1(11310),CONTR(24),COLVEC(24),PRDMTX(300),
     1IFL2(350),JCOL(24),A(300),B(24),EVAL(24),W1(24),W2(24),
     2W3(24),W4(24),W5(24),W6(24),W7(24),W8(24),EVEC(24,24),
     3AINV(24,24),DIAG(24),C(24),IFL3(1840)
      COMMON/INVPAR/ ICOL(12),GAMMA
      DIMENSION SCALE(24)
      DATA SCALE/10.D0,11*1.D0,10.D0,11*1.D0/
      NEVUS=0
      DO 13 I=1,24
      CONTR(I)=0.
   13 JCOL(I)=0
      DO 1 I=1,NPAR
      IF(NSOL.GT.NPAR) JCOL(I+NPAR)=ICOL(I)
    1 JCOL(I)=ICOL(I)
      KNT=0
      NEQ=0
      DO 2 I=1,NSOL
      IF(JCOL(I).EQ.0) GO TO 2
      NEQ=NEQ+1
      B(NEQ)=COLVEC(I)
      DIAG(NEQ)=SCALE(I)
      I1=((2*NSOL-I)*(I-1))/2
      DO 3 J=I,NSOL
      IF(JCOL(J).EQ.0) GO TO 3
      KNT=KNT+1
      K=I1+J
      A(KNT)=PRDMTX(K)
    3 CONTINUE
    2 CONTINUE
      KNT=0
      FACTR=0.D0
      DO 5 I=1,NEQ
      DO 5 J=I,NEQ
      KNT=KNT+1
      A(KNT)=A(KNT)*DIAG(I)*DIAG(J)
      IF(I.EQ.J) FACTR=FACTR+A(KNT)
    5 CONTINUE
      KNT=0
      FACTR=DFLOAT(NEQ)/FACTR
      DO 20 I=1,NEQ
      DO 20 J=I,NEQ
      KNT=KNT+1
   20 A(KNT)=A(KNT)*FACTR
      CALL AHOUSN(NEQ,A,EVAL,EVEC,W1,W2,W3,W4,W5,W6,W7,W8,24)
      DO 6 I=1,NEQ
      DO 6 J=1,NEQ
    6 AINV(I,J)=0.D0
      EMIN=EVAL(1)*GAMMA
      DO 7 I=1,NEQ
      IF(EVAL(I).LT.EMIN) GO TO 17
      NEVUS=NEVUS+1
      ONEOV=1.D0/EVAL(I)
      DO 8 J=1,NEQ
      FACT=ONEOV*EVEC(I,J)
      DO 8 K=1,NEQ
    8 AINV(K,J)=AINV(K,J)+FACT*EVEC(I,K)
    7 CONTINUE
   17 DO 9 I=1,NEQ
      DO 9 J=1,NEQ
    9 AINV(I,J)=AINV(I,J)*DIAG(I)*DIAG(J)*FACTR
      DO 10 I=1,NEQ
      C(I)=0.D0
      DO 10 J=1,NEQ
   10 C(I)=C(I)+AINV(I,J)*B(J)
      DO 11 I=1,NSOL
   11 CONTR(I)=0.
      KNT=0
      DO 12 I=1,NSOL
      IF(JCOL(I).EQ.0) GO TO 12
      KNT=KNT+1
      CONTR(I)=C(KNT)
   12 CONTINUE
      RETURN
      END
