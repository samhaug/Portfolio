
C**********************************************************************
      SUBROUTINE EQPAR(FMOM,SCMOM,PHS,DEL,RLAM,EIVALS,EIVECS
     1                 ,PLUNGS,AZIMS)
      save
C
C   FMOM(6)     INPUT OMENT TENSOR COMPONENTS
C   SCMOM       OUTPUT SCALAR MOMENT
C   PHS(2)      OUTPUT STRIKE AZIMUTHS
C   DEL(2)      OUTPUT DIPS
C   RLAM(2)     OUTPUT 'RAKE' ANGLES
C   EIVALS(3)   OUTPUT EIGENVALUES (T-AXIS,INTER.,P-AXIS)
C   EIVECS(3,3) OUTPUT: COLUMNS ARE NORMALIZED PRINCIPAL AXES
C   PLUNGS(3)   OUTPUT PLUNGES OF PRINCIPAL AXES
C   AZIMS(3)    OUTPUT AZIMUTHS OF PRINCIPAL AXES
C
C   ALL ANGLES ARE IN DEGREES
C
      DIMENSION FMOM(6),PHS(2),DEL(2),RLAM(2),EIVALS(3),EIVECS(3,3)
     1    ,V(3,3),RN(3),E(3),PLUNGS(3),AZIMS(3)
      DATA RADIAN/57.29577951/
      DATA HSQ2/.70710678/
C
      scale=amax1(abs(fmom(1)),abs(fmom(2)),abs(fmom(3))
     1           ,abs(fmom(4)),abs(fmom(5)),abs(fmom(6)))
      EIVECS(1,1)=FMOM(1)/scale
      EIVECS(2,2)=FMOM(2)/scale
      EIVECS(3,3)=FMOM(3)/scale
      EIVECS(1,2)=FMOM(4)/scale
      EIVECS(2,1)=FMOM(4)/scale
      EIVECS(1,3)=FMOM(5)/scale
      EIVECS(3,1)=FMOM(5)/scale
      EIVECS(2,3)=FMOM(6)/scale
      EIVECS(3,2)=FMOM(6)/scale
      CALL EIGEN(EIVECS,V,3,1)
      EIMAX=EIVECS(1,1)
      EIMIN=EIVECS(1,1)
      IMAX=1
      IMIN=1
      DO 10 I=2,3
      IF(EIVECS(I,I).LE.EIMAX) GOTO 20
      IMAX=I
      EIMAX=EIVECS(I,I)
   20 IF(EIVECS(I,I).GT.EIMIN) GOTO 10
      IMIN=I
      EIMIN=EIVECS(I,I)
   10 CONTINUE
      IF(IMAX.EQ.IMIN) PAUSE ' ERROR 1 IN EQPAR '
      SCMOM=.5*(ABS(EIMAX)+ABS(EIMIN))
      IINT=6-IMAX-IMIN
      EIVALS(1)=EIVECS(IMAX,IMAX)
      EIVALS(2)=EIVECS(IINT,IINT)
      EIVALS(3)=EIVECS(IMIN,IMIN)
      DO 30 I=1,3
      EIVECS(I,1)=V(I,IMAX)
      EIVECS(I,2)=V(I,IINT)
   30 EIVECS(I,3)=V(I,IMIN)
      DO 40 J=1,3
      SUM=0.
      DO 45 I=1,3
   45 SUM=SUM+EIVECS(I,J)*EIVECS(I,J)
      SUM=1./SQRT(SUM)
      IF(EIVECS(1,J).GT.0.) SUM=-SUM
      DO 50 I=1,3
   50 EIVECS(I,J)=EIVECS(I,J)*SUM
   40 CONTINUE
C
      DO 200 I=1,3
      PLUNGS(I)=ATANT(-EIVECS(1,I)
     1                ,SQRT(EIVECS(2,I)**2+EIVECS(3,I)**2))*RADIAN
      AZIMS(I)=ATANT(-EIVECS(3,I),EIVECS(2,I))*RADIAN+180.
  200 CONTINUE
C
      SGN=-1.
      DO 100 ISGN=1,2
      SGN=-SGN
      DO 110 I=1,3
      RN(I)=HSQ2*(EIVECS(I,1)+SGN*EIVECS(I,3))
  110 E(I)=HSQ2*(EIVECS(I,1)-SGN*EIVECS(I,3))
      IF(RN(1).GT.0.) GOTO 120
      DO 130 I=1,3
      RN(I)=-RN(I)
  130 E(I)=-E(I)
  120 SIND=SQRT(RN(2)*RN(2)+RN(3)*RN(3))
      DEL(ISGN)=ATANT(SIND,RN(1))*RADIAN
      PHS(ISGN)=ATANT(-RN(2),-RN(3))*RADIAN+180.
      RLAM(ISGN)=ATANT(E(1),RN(2)*E(3)-RN(3)*E(2))*RADIAN
  100 CONTINUE
      do i=1,3
        eivals(i)=eivals(i)*scale
      enddo
      scmom=scmom*scale
      RETURN
      END
