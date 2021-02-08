
C**********************************************************************
      SUBROUTINE MODES
      save
      COMMON/INTAP/ JSTAT,ITYPE,IDUM(14)
      COMMON/AP1/ DAP1(26)
      COMMON/AP2/ DAP2(8740)
      COMMON/AP3/ DAP3(27)
      COMMON/IAP6/ RESP(2570)
      COMMON/IAP5/ SYNT(12850)
      COMMON/INTER/ KNT,XJ,ZZ1,ZZ2
      IF(JSTAT.LT.-1) RETURN
      IF(JSTAT.EQ.0) GO TO 1
      CALL FVCLR(SYNT,1,12850)
      KNT=0
      XJ=-1.
      JSTAT=0
    1 CONTINUE
      IF(ITYPE.EQ.1) CALL MSFER
      IF(ITYPE.EQ.2) CALL MTORS
      RETURN
      END
