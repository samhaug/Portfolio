
C$**********************************************************************
      SUBROUTINE RDSOUR(LU)
      save
      COMMON/TAPE/ F(6),X,Y,D,T,DU,DUM,FILT(1502)
      COMMON/DBLEM/ XMD(6),R0D
      COMMON/DBLEC/ EPLA,EPLON,DEP,TORG,DURT
      character*80 event
      common/evname/event,levt
c      CHARACTER*10 LUNIT
c      WRITE(LUNIT,11) LU
c   11 FORMAT('lu_',I1)
c      CALL OPENFL(LU,LUNIT,4,0,0,ISTAT,5604)
      CALL OPENFL(LU,'E'//event(1:levt)//'.INV',4,0,0,ISTAT,5604)
      CALL BFFI(LU,1,NSOUR,4,J,M,1)
      CALL BFFI(LU,1,F,48,J,M,2)
      CALL CLOSFL(LU,ISTAT)
      DO 1 I=1,6
    1 XMD(I)=F(I)
      R0D=1.-D/6371.
      EPLA=X
      EPLON=Y
      DEP=D
      TORG=T
      DURT=DU
      RETURN
      END
