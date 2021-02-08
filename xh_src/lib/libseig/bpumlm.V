             Vectorized Results From File bpumlm.f
                    Origin -- Line 60

 Line   Stmt   Time        Program

    *      *      3        vl = 28
   60      *      4        DO VECTOR I=1, 28
   61     30     18           ACUM(I) = 0.0D0
                           END DO


No directives were found.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 64

 Line   Stmt   Time        Program

   64     39      0        DO IQ=l1, NTOP
   65     41      0           b2 = 28
   65     42      0           DO I=1, 28
                                 (...)
                              END DO
   68     49      0           IF (IQ .EQ. N) THEN
   68     50      0              GO TO 100
                              END IF
   70     51      0           IIQ = IQ
   71     52      0           CALL CORFAC(IIQ, WCOM, JCOM, XAC, XF, XLN)
   73     53      0           IQ1 = IQ + 1
   74     54      0           R1 = R(IQ)
   75     55      0           R2 = R(IQ1)
   76     56      0           HN = R2 - R1
   77     57      0           HNH = HN*5.0E-01
   78     59      0           IF (HN .LT. 1.0E-04) THEN
   78     60      0              GO TO 100
                              END IF
   79     61      0           HR = 1.0/HN
   80     62      0           HSQ = HR*HR
   81     63      0           HCU = HR*HSQ
   83     64      0           l2 = J1
   83     66      0           b2 = MAX(1 + J2 - l2, 0)
   83     67      0           DO I=l2, J2
                                 (...)
                              END DO
   91     81      0           IF (IQ .NE. 1) THEN
                              END IF
   96     87      0           b2 = 5
   96     88      0           DO IL=1, 5
                                 (...)
                              END DO
  209    202      0           b2 = 28
  209    203      0           DO II=1, 28
                                 (...)
                              END DO
  214    210      0  100      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 5 function calls.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 65

 Line   Stmt   Time        Program

    *      *      3        vl = 28
   65      *      4        DO VECTOR I=1, 28
   66     43     18           TEMP(I) = 0.0D0
                           END DO


No directives were found.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 83

 Line   Stmt   Time        Program

   83      *      6        DO iv=l2, J2, 32
   83      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
   83      *      6           DO VECTOR I=iv, rv
   86     70    172              A(I) = (EIF(i1, I*2) + EIF(IQ1, I*2))*HSQ + 2.0*(EIF(i1, I*2 - 1) -                            EIF(IQ1, I*2 - 1))*HCU
   88     72    180              B(I) = - ((2.0 * EIF(i1, I*2) + EIF(IQ1, I*2))*HR) - 3.0*(EIF(i1, 
                          $           I*2 - 1) - EIF(IQ1, I*2 - 1))*HSQ
                              END DO
                           END DO
   88     71      0  120   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 96

 Line   Stmt   Time        Program

   96     88      0        DO IL=1, 5
   97     89      0           T = 5.0E-01*HN*(XI(IL) + 1.0)
   98     90      0           RR = R1 + T
  100     92      0           X = 2.0*(RR - R(N670))/(R(MOHO) - R(N670)) - 1.0
  101     93      0           l3 = J1
  101     95      0           b3 = MAX(1 + J2 - l3, 0)
  101     96      0           DO I=l3, J2
                                 (...)
                              END DO
  108    107      0           AA = XAC*(ACON(i1) + T*(QACON(1, i1) + T*(QACON(2, i1)
                          $         + T * QACON(3, i1))))
  109    108      0           CC = XAC*(CCON(i1) + T*(QCCON(1, i1) + T*(QCCON(2, i1)
                          $         + T * QCCON(3, i1))))
  110    109      0           FF = XF*(FCON(i1) + T*(QFCON(1, i1) + T*(QFCON(2, i1)
                          $         + T * QFCON(3, i1))))
  111    110      0           LL = XLN*(LCON(i1) + T*(QLCON(1, i1) + T*(QLCON(2, i1)
                          $         + T * QLCON(3, i1))))
  112    111      0           NN = XLN*(NCON(i1) + T*(QNCON(1, i1) + T*(QNCON(2, i1)
                          $         + T * QNCON(3, i1))))
  113    112      0           RRHO = RHO(i1) + T*(QRHO(1, i1) + T*(QRHO(2, i1) + T * QRHO(3, i1)))
  115    114      0           ETAN = FF/(AA - 2.0*LL)
  116    115      0           DELV2 = (LL + NN)/RRHO
  117    116      0           DELVP2 = (AA + CC)/RRHO
  119    118      0           IF (JCOM .NE. 2) THEN
  120    119      0              F = 2.0*UR - FL3*VR
  121    120      0              XX = VPR - VR + UR
  122    121      0              XX2 = XX*XX
  123    122      0              VR2 = VR*VR
  125    124      0              RKA0 = F*F
  126    125      0              RKC0 = UPR*UPR
  127    126      0              RKF0 = 2.0*UPR*F
  128    127      0              RKL0 = FL3*XX2
  129    128      0              RKN0 = CON3*VR2 - RKA0
                              ELSE
  133    131      0              XX = VPR - VR
  134    132      0              XX2 = XX*XX
  135    133      0              VR2 = VR*VR
  136    134      0              RKL0 = FL3*XX2
  137    135      0              RKN0 = CON3*VR2
                              END IF
  144    139      0           IF (i1 .GT. N670 .AND. i1 .LT. MOHO) THEN
  145    140      0              X = 2.0*(RR - R(N670))/(R(MOHO) - R(N670)) - 1.0
  146    142      0              b3 = 4
  146    143      0              DO I=1, 4
                                    (...)
                                 END DO
                              END IF
  161    154      0           IF (i1 .GT. NOC .AND. i1 .LT. N670) THEN
  162    155      0              X = 2.0*(RR - R(NOC))/(R(N670) - R(NOC)) - 1.0
  163    157      0              b3 = 5
  163    158      0              DO I=1, 5
                                    (...)
                                 END DO
                              END IF
  177    169      0           IF (i1 .GT. N670 .AND. i1 .LT. MOHO) THEN
  178    170      0              X = 2.0*(RR - R(N670))/(R(MOHO) - R(N670)) - 1.0
  179    172      0              b3 = 4
  179    173      0              DO I=1, 4
                                    (...)
                                 END DO
                              END IF
  193    184      0           IF (i1 .GT. NOC .AND. i1 .LT. N670) THEN
  194    185      0              X = 2.0*(RR - R(NOC))/(R(N670) - R(NOC)) - 1.0
  195    187      0              b3 = 5
  195    188      0              DO I=1, 5
                                    (...)
                                 END DO
                              END IF
  207    198      0  110      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 4 function calls.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 101

 Line   Stmt   Time        Program

  101      *      6        DO iv=l3, J2, 32
  101      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
  101      *      6           DO VECTOR I=iv, rv
  104     99    133              Q(I) = EIF(i1, I*2 - 1) + T*(EIF(i1, I*2) + T*(B(I) + T * A(I)))
  105    100    121              QP(I) = (EIF(i1, I*2) + T*(2.0 * B(I) + T*3.0 * A(I)))*RR
                              END DO
                           END DO


No directives were found.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 146

 Line   Stmt   Time        Program

  146    143      4        DO I=1, 4
  147    144      6           IIN = I - 1
  148    145     16           PNX = PN(IIN, X)
  149    147      8           IF (JCOM .EQ. 2) THEN
  150    148    127              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0)*HNH)
                              ELSE
  152    149    175              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0 - 2.0*ETAN*RKF0)*HNH                           )
                              END IF
  154    150     46           TEMP(I) = TEMP(I) + ADD
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 163

 Line   Stmt   Time        Program

  163    158      4        DO I=1, 5
  164    159      6           IIN = I - 1
  165    160     16           PNX = PN(IIN, X)
  166    162      8           IF (JCOM .EQ. 2) THEN
  167    163    127              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0)*HNH)
                              ELSE
  169    164    175              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0 - 2.0*ETAN*RKF0)*HNH                           )
                              END IF
  171    165     50           TEMP(4 + I) = TEMP(4 + I) + ADD
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 179

 Line   Stmt   Time        Program

  179    173      4        DO I=1, 4
  180    174      6           IIN = I - 1
  181    175     16           PNX = PN(IIN, X)
  182    177      8           IF (JCOM .EQ. 2) THEN
  183    178      8              ADD = 0.0D0
                              ELSE
  185    179    159              ADD = DBLE(WT(i2) * RRHO*DELVP2*PNX*(RKA0 + RKC0 + ETAN*RKF0)*HNH)
                              END IF
  187    180     50           TEMP(9 + I) = TEMP(9 + I) + ADD
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 195

 Line   Stmt   Time        Program

  195    188      4        DO I=1, 5
  196    189      6           IIN = I - 1
  197    190     16           PNX = PN(IIN, X)
  198    192      8           IF (JCOM .EQ. 2) THEN
  199    193      8              ADD = 0.0D0
                              ELSE
  201    194    159              ADD = DBLE(WT(i2) * RRHO*DELVP2*PNX*(RKA0 + RKC0 + ETAN*RKF0)*HNH)
                              END IF
  203    195     50           TEMP(13 + I) = TEMP(13 + I) + ADD
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 209

 Line   Stmt   Time        Program

    *      *      3        vl = 28
  209      *      4        DO VECTOR II=1, 28
  210    204     44           ACUM(II) = ACUM(II) + TEMP(II)
                           END DO


No directives were found.

--------------------------------------
             Vectorized Results From File bpumlm.f
                    Origin -- Line 217

 Line   Stmt   Time        Program

    *      *      3        vl = 28
  217      *      4        DO VECTOR I=1, 28
  218    216     54           PARM(I) = FLOAT(ACUM(I) * 5.0D-01*DBLE(WCOM))
                           END DO


No directives were found.

