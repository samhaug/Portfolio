
C$**********************************************************************
      SUBROUTINE ADJUSS(XL,OM,GRV,ELP,PART,DTH)
      DIMENSION PART(*)
      COMMON/AP3/ DELTA,FACTT,FACTO,PERT(24)
      COMMON/INTAP/ IDUM(14),NEQ,IFACT
      FU=0.
      IF(GRV.GT.0.) FU=6371./(GRV*(XL+0.5))
      DTH=FU*FACTT*OM*ELP
      OM=OM*(1.+ELP*FACTO)
      FU=FU*DELTA
c      CALL FDOTPR(PART,1,PERT,1,DT,NEQ)
      dt=sdot(neq,part,1,pert,1)
      IF(IFACT.EQ.0) GO TO 2
      NQ1=NEQ+1
c      CALL FDOTPR(PART,1,PERT(NQ1),1,DOM,NEQ)
      dom=sdot(neq,part,1,pert(nq1),1)
      OM=OM+DOM
      DTH=DTH+FU*(DOM-DT)
      RETURN
    2 OM=OM+DT
      RETURN
      END
