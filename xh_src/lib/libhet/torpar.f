
C$**********************************************************************
CPROG TORPAR
CXREF
      SUBROUTINE TORPAR(NMIN,OMMAX,R0,NSHEAR,LU1,LU2)
      save
      COMMON/BIGSPA/ B1(1024),B2(1024),B3(1024),B4(1024)
     1  ,B5(256,10),
     1YL(437),OM(437),QB(437),GRV(437),EL(437),EH(3,437),PT(12,437),
     2FILLB(2280)
      DIMENSION B(8740)
      COMMON/TAPE/ FILT(250),INDSFR(330),INDTOR(300),KNTSFR(330),
     1KNTTOR(300),KNTS,KNTT,IU1,NBATCH
      COMMON/SPLIN/ FILS(5),IR1
      EQUIVALENCE (YL(1),B(1))
      IU1=LU1
      IRLST=0
      XL=1.
      KNT=0
      DO 100 NN=1,KNTT
      NT=KNTTOR(NN)-NMIN
      IF(NT.EQ.0) GO TO 99
      IT1=INDTOR(NN)+NMIN
      IT2=IT1+KNTTOR(NN)-1
      DO 1 I=IT1,IT2
      IREC=(I+255)/256
      IF(IREC.NE.IRLST) CALL GETPAR(I,LU1,LU2,B1,B2,B3,B4,B5,IRLST,
     1IR1,NSHEAR)
      IF(NN.EQ.1.AND.I.EQ.IT1) GO TO 1
      IP=MOD(I-1,256)+1
      IP256=IP+256
      IP512=IP256+256
      IP768=IP512+256
      OMEGA=B1(IP)
      IF(I.EQ.IT1.AND.OMEGA.GT.OMMAX) GO TO 99
      IF(OMEGA.GT.OMMAX) GO TO 100
      KNT=KNT+1
      OM(KNT)=OMEGA
      QB(KNT)=B1(IP256)
      AH=B1(IP768)
      YL(KNT)=XL
      GRV(KNT)=B2(IP)
      EL(KNT)=B2(IP256)
      PT(1,KNT)=B2(IP512)
      PT(2,KNT)=B2(IP768)
      DO 70 K=1,NSHEAR
      K2=K+2
   70 PT(K2,KNT)=B5(IP,K)
      V1=B3(IP512)
      VP1=B3(IP768)
      V2=B4(IP512)
      VP2=B4(IP768)
      CALL SPLINE(V1,VP1,V2,VP2,VS,VPS,VPPS)
      EH(1,KNT)=AH*VS/R0
      EH(2,KNT)=AH*VPS
      EH(3,KNT)=AH*R0*VPPS
      IF(KNT.LT.437) GO TO 1
      CALL BFFOUT(4,1,B,8740,J)
      KNT=0
    1 CONTINUE
  100 XL=XL+1.
   99 KNT=KNT+1
      YL(KNT)=-1.
      CALL BFFOUT(4,1,B,8740,J)
C     END FILE 4
      CALL REWFL(4)
      RETURN
      END
