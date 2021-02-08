
C$**********************************************************************
CPROG RSPIDA
CXREF
      COMPLEX FUNCTION RSPIDA(IDAY,IYEAR,NAME,OMEGA,I)
      save
      COMPLEX RESIDA
      INTEGER*2 JDAY,JYEAR
      WRITE(6,'(''RSPIDA ENTERED'')')
      IF(I.GT.1) GO TO 10
      RSPIDA=(0.,0.)
      RETURN
   10 JDAY=IDAY
      JYEAR=IYEAR
      RSPIDA=-RESIDA(OMEGA,NAME,JYEAR,JDAY)*CMPLX(0.01,0.)
      RETURN
      END
