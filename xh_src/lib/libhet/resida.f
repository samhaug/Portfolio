
C$**********************************************************************
      COMPLEX FUNCTION RESIDA(OM,ICOMP,IYEAR,IDAY)
      save
      COMPLEX RIDA
      INTEGER*2 IDAY,IYEAR,IDD
      CHARACTER*3 CODE,CHAN(2)
      INTEGER*4 ICOMPL
      data icompl/0/
      INTEGER*2 IYEARL,IDAYL
      data  IYEARL/0/,IDAYL/0/
      SAVE ICOMPL,IYEARL,IDAYL
      DATA CHAN/'MDE','BP2'/
c jeroen comment
c     DATA ISEY/'SEY '/

CC    IF(ICOMP.NE.ICOMPL.OR.IYEAR.NE.IYEARL.OR.IDAY.NE.IDAYL) THEN
CC    WRITE(5,"('RESIDA:',2X,A4,I6,I5)") ICOMP,IYEAR,IDAY
CC    ICOMPL=ICOMP
CC    IYEARL=IYEAR
CC    IDAYL=IDAY
CC    ENDIF

c jeroen comment
c     IF(ICOMP.EQ.ISEY.AND.IYEAR.EQ.1980.AND.IDAY.LE.304) THEN
c     IDD=305
c     ELSE
c     IDD=IDAY
c     ENDIF

      WRITE(CODE,'(A3)') ICOMP
      IYR=IYEAR
      IDY=IDD
      NSTA=IDANUM(CODE,3)
      DO 10 I=1,2
      NCHA=IDANUM(CHAN(I),3)
c      print*,nsta,ncha,iyr,idy
      IERR=IDARES(NSTA,NCHA,IYR,IDY)
      IF(IERR.EQ.1) GOTO 20
   10 CONTINUE
      PAUSE '!!!! NO IDA RESPONNSE !!!!'
      RETURN
   20 RESIDA=RIDA(OM)
      RETURN
      END
