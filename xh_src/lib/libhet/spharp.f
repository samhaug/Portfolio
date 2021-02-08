
C$**********************************************************************
      SUBROUTINE SPHARP(L,ICOMP)
      save
      COMPLEX EPC,X,Y,XX,YY,YT
      COMMON/AP1/ DUM1(3),THETA,CAZ,SAZ,EPC(4),DUM2(12)
      COMMON/IAP1/ X(6),Y(6),ADD1(8)
      COMMON/INTER/ KNT,XJ,ZZ1,ZZ2
      DIMENSION Z(3),ZP(3),ZPP(3),X1(9),X2(6)
      EQUIVALENCE (Z(1),X1(1)),(ZP(1),X1(4)),(ZPP(1),X1(7)),(X1(4),
     1X2(1))
      DATA FPI/12.5663706/
      CALL FVCLR(X1,1,9)
      CT=COS(THETA)
      ST=SIN(THETA)
      COSEC=1./ST
      M=MIN0(L,2)
      LP1=L+1
      MP1=M+1
      ZL=L
      FCT=(2.*ZL+1.)/FPI
      FL3=ZL*(ZL+1.)
      COT=CT/ST
      IF(L.GT.2) GO TO 20
      GO TO(22,23,24),LP1
   22 Z(1)=FCT
      GO TO 28
   23 Z(1)=CT*FCT
      ZP(1)=-ST*FCT
      Z(2)=ZP(1)
      ZP(2)=-.5*Z(1)*FL3
      GO TO 27
   24 ZZ1=1.
      ZZ2=CT
   20 Z3=((2.*ZL-1.)*CT*ZZ2-(ZL-1.)*ZZ1)/ZL
      ZZ1=ZZ2
      ZZ2=Z3
      Z3=ZZ2*FCT
      Z(1)=Z3
      Z2=ZL*(ZZ1-CT*ZZ2)*FCT*COSEC
      ZP(1)=-Z2
      ZP(2)=COT*Z2-FL3*Z3
      Z(2)=-Z2
      Z2=-Z2
      Z1=Z3
      FCT=1.
      I=3
   25 FCT=0.5*FCT
      ZM=I-1
      Z3=-(2.*(ZM-1.)*COT*Z2+(ZL-ZM+2.)*(ZL+ZM-1.)*Z1)
      Z(I)=Z3*FCT
      ZP(I)=-FCT*((ZL+ZM)*(ZL-ZM+1.)*Z2+ZM*COT*Z3)
      Z1=Z2
      Z2=Z3
      I=I+1
      IF(I.LE.MP1) GO TO 25
   27 I=1
   26 ZPP(I)=COT*ZP(I)-(FL3-(FLOAT(I-1)*COSEC)**2)*Z(I)
      I=I+1
      IF(I.LE.MP1) GO TO 26
   28 I=1
    1 K=MOD(I-1,3)+1
      IF(ICOMP.GT.1) GO TO 2
      X(I)=X1(I)*EPC(K)
      Y(I)=(0.,0.)
      GO TO 3
    2 XM=K-1
      XX=X2(I)*EPC(K)
      YT=CMPLX(0.,XM*X1(I)*COSEC)
      YY=EPC(K)*YT
      X(I)=-CAZ*XX-SAZ*YY
      Y(I)=SAZ*XX-CAZ*YY
    3 I=I+1
      IF(I.LE.6) GO TO 1
      RETURN
      END
