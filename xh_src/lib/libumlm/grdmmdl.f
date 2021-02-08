      subroutine grdmmdl(grid,igrid,ikla,iklo,rn,r1,r2,xlat1,xlon1,del12,az21)
      COMMON/MODMDL/CMOD(15,222,3),CMOB(15,4)
      REAL LCON,NCON
C
      COMMON/MODL1/N,NIC,NOC,MOHO,NSL,IFANIS,R(222)
     1            ,RHO(222),QRHO(3,222),G(222),ELL(222),ETA(222)
      COMMON/MODL2/ACON(222),QACON(3,222),CCON(222),QCCON(3,222)
     1            ,LCON(222),QLCON(3,222),NCON(222),QNCON(3,222)
     2            ,FCON(222),QFCON(3,222)
C
      DOUBLE PRECISION D
      COMMON/LEGWK/WK1(9),WK2(9),WK3(9),SAR(11),D(17,17)
     1   ,VEC1(34),VEC2(34),YLMH(81),YLMT(81),YLMH1(81),YLMT1(81)
      COMMON/WKWK/COSA(9),SINA(9),WRK(295),VSC(5),Y1(82),Y2(82)
      DIMENSION GRID(IGRID,1)
      RADIAN=180./3.1415926535
      ROOT=SQRT(.5)
      LMAX=4
      lmin=2

      do ilo=1,iklo
        xphi=del12*float(ilo-1)/float(iklo-1)
        call pdaz(xlat1,xlon1,az21,xphi,xlat,xlon)
        call ylm(xlat,xlon,lmax,ylmh,wk1,wk2,wk3)

        do ila=1,ikla
          rx=r1+(r2-r1)*float(ila-1)/float(ikla-1)
          RR=RX/RN
          ir=1
          ir1=2
  132     IF(R(IR1).GT.RR) GOTO 131
          if(abs(r(ir1)-r(ir)).lt.1.e-5) then
            ir1=ir
            ir=ir1-1
            goto 131
          endif
          IR=IR+1
          IR1=IR1+1
          GOTO 132
  131     CONTINUE
     

          den=r(ir1)-r(ir)
          if(den.ne.0.) then
            h=1.-(rr-r(ir))/(r(ir1)-r(ir))
            h1=1.-(r(ir1)-rr)/(r(ir1)-r(ir))
          else
            h=1.
            h1=0.
          endif
        
          K=0
          K1=0
          DO L=0,LMAX
            IF(MOD(L,2).EQ.0) THEN
              INC1=1
            ELSE
              INC1=0
            ENDIF
            DO M=0,2*L
              K=K+1
              IF(INC1.EQ.1) THEN
                K1=K1+1
                YLMT(K)=(h*CMOD(K1,IR,1)+h1*CMOD(K1,IR1,1))*100.
                IF(M.EQ.0) YLMT(K)=YLMT(K)*ROOT
              ELSE
                YLMT(K)=0.
              ENDIF
            ENDDO
          ENDDO
          sum=0.
          do i=lmin**2+1,(lmax+1)**2
            sum=sum+ylmh(i)*ylmt(i)
          enddo
          grid(ila,ilo)=sum
c          write(6,"(4i5,e12.4)") ila,ilo,ir,ir1,sum
        enddo
      enddo
      RETURN
      END
