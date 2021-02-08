
C$**********************************************************************
      SUBROUTINE PROCES(X,OM,Q,GRV,ELP,EIG,PART)
      save
      COMPLEX A0,STEP
      DIMENSION PART(*),EIG(*)
      COMMON/INTAP/ JSTAT,ITYP,ICOMP,IFACT,L,LP,NPOINT,ID2(7),
     1NPAR,IFTWO
      COMMON/AP1/ T0,DT,OMMAX,FILL(23)
      COMMON/IAP5/ SYNT(514),PDER(12336)
      COMMON/IAP3/ CTRACE(514),STRACE(514)
      COMMON/INTER/ KNT,XJ,ZZ1,ZZ2
      IF(X.LT.0.) GO TO 99
      IF(OM.GT.OMMAX) GO TO 100
      IF(X.EQ.XJ) GO TO 10
      KNT=0
      L=X+0.001
      LP=LP+1
      XJ=X
      CALL SPHARP(L,ICOMP)
      IF(ITYP.EQ.1) CALL STABLP(X)
      IF(ITYP.EQ.2) CALL TTABLP
   10 IF(KNT.EQ.0.AND.DT.LT.20.) GO TO 100
      QB=-.5*Q
      CALL ADJUST(X,OM,GRV,ELP,PART,TH,FU)
      GRV=FU
      ELP=TH
      ARG=OM*T0
      A0=CMPLX(.95179,0.)*CEXP(CMPLX(QB*ARG,ARG))
      TIME=T0
      ARG=OM*DT
      STEP=CEXP(CMPLX(QB*ARG,ARG))
      I=1
    3 CTRACE(I)=REAL(A0)
      STRACE(I)=TIME*AIMAG(A0)
      A0=A0*STEP
      TIME=TIME+DT
      I=I+1
      IF(I.LE.NPOINT) GO TO 3
      IF(ITYP.EQ.1) CALL SCOEFP(EIG,C1,C2)
      IF(ITYP.EQ.2) CALL TCOEFP(EIG,C1,C2)
      ARG=-C1-TH*C2
cC      CALL FVSMA2(CTRACE,1,ARG,SYNT,1,NPOINT)
      call saxpy(npoint,arg,ctrace,1,synt,1)
      IF(IFACT.EQ.0) GO TO 100
      I=1
   20 ARG=(C1+TH*C2)*PART(I)
      I1=I
      IF(IFTWO.NE.0) I1=I+NPAR
      IND=(I1-1)*514+1
cC      CALL FVSMA2(STRACE,1,ARG,PDER(IND),1,NPOINT)
      call saxpy(npoint,arg,strace,1,pder(ind),1)
      I=I+1
      IF(I.LE.NPAR) GO TO 20
      IF(IFTWO.EQ.0) GO TO 100
      I=1
   30 ARG=FU*C2*PART(I)
      IND=(I-1)*514+1
cC      CALL FVSMA2(CTRACE,1,ARG,PDER(IND),1,NPOINT)
      call saxpy(npoint,arg,ctrace,1,pder(ind),1)
      I=I+1
      IF(I.LE.NPAR) GO TO 30
  100 KNT=KNT+1
      RETURN
   99 JSTAT=-1
      RETURN
      END
