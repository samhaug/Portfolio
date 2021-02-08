
C$**********************************************************************
      SUBROUTINE EIGPAR(DEPTH,ITAPER,IFANI)
      save
      COMMON/TAPE/ FILL(1512),LU1,NBATCH
      COMMON/SCAN/FILL1(800),MFIL(4),MFILAN(4)
      character*80 event
      common/evname/event,levt
      DATA IH1,IH2/4HH.1 ,4HH.2 /
      CALL OPENW(1,MFIL,0,0,0,ISTAT,4096)
      IF(ISTAT.NE.0) STOP 'CANNOT OPEN MODE CATALOG FILE'
      CALL OPENW(2,MFILAN,0,0,0,ISTAT,10240)
      IF(ISTAT.NE.0) STOP 'CANNOT OPEN S-DERIVATIVE FILE'
      CALL CLOSFL(3)
      CALL CLOSFL(4)
c      CALL OPENW(3,IH1,4,0,0,ISTAT,-256)
      call openfl(3,event(1:levt)//'.H.1',4,0,0,istat,-256)
      IF(ISTAT.NE.0) STOP 'CANNOT OPEN H.1 FILE'
c      CALL OPENW(4,IH2,4,0,0,ISTAT,-256)
      call openfl(4,event(1:levt)//'.H.2',4,0,0,istat,-256)
      IF(ISTAT.NE.0) STOP 'CANNOT OPEN H.2 FILE'
      CALL REWFL(1)
      CALL REWFL(2)
      CALL REWFL(3)
      CALL REWFL(4)
      LU1=1
      LU2=2
      NSHEAR=(IFANI+1)*5
      R0=1.-DEPTH/6371.
      OMMAX=0.1396236
      IF(ITAPER.EQ.2) OMMAX=0.1963495
      CALL SETUP1(R0)
      CALL SFRPAR(0,OMMAX,R0,NSHEAR,LU1,LU2)
      CALL TORPAR(0,OMMAX,R0,NSHEAR,LU1,LU2)
      CALL CLOSFL(1)
      CALL CLOSFL(2)
      RETURN
      END
