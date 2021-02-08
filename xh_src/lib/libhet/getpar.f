
C**********************************************************************
      SUBROUTINE GETPAR(I,LU1,LU2,B1,B2,B3,B4,B5,IRLST,IR1,NS)
      save
      DIMENSION B1(*),B2(*),B3(*),B4(*),B5(*)
      COMMON/TAPE/ FILL(1513),NBATCH
      JREC=(I+255)/256
      IRLST=JREC
      CALL BFFI(LU1,1,B1,4096,J,M,JREC+3)
      CALL BFFI(LU1,1,B2,4096,J,M,JREC+NBATCH+3)
      IREC=NBATCH*(2+IR1)+JREC+3
      CALL BFFI(LU1,1,B3,4096,J,M,IREC)
      CALL BFFI(LU1,1,B4,4096,J,M,IREC+NBATCH)
      NR=1024*NS
      CALL BFFI(LU2,1,B5,NR,J,M,JREC)
      RETURN
      END
