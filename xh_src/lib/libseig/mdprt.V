             Vectorized Results From File mdprt.f
                    Origin -- Line 64

 Line   Stmt   Time        Program

   64      *      5        DO iv=1, NINT, 32
   64      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
   64      *      6           DO VECTOR I=iv, rv
   65     35     18              ACUM(I) = 0.0D0
                              END DO
                           END DO
   65     34      0  141   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 67

 Line   Stmt   Time        Program

   67     44      0        DO IQ=l1, MOHO
   68     46      0           b2 = MAX(NINT, 0)
   68     47      0           DO I=1, NINT
                                 (...)
                              END DO
   70     55      0           IF (IQ .EQ. N) THEN
   70     56      0              GO TO 99
                              END IF
   72     57      0           IIQ = IQ
   73     58      0           CALL CORFAC(IIQ, WCOM, JCOM, XAC, XF, XLN)
   75     59      0           IQ1 = IQ + 1
   76     60      0           R1 = R(IQ)
   77     61      0           R2 = R(IQ1)
   78     62      0           HN = R2 - R1
   79     63      0           HNH = HN*5.0E-01
   80     65      0           IF (HN .LT. 1.0E-04) THEN
   80     66      0              GO TO 99
                              END IF
   81     67      0           HR = 1.0/HN
   82     68      0           HSQ = HR*HR
   83     69      0           HCU = HR*HSQ
   85     70      0           l2 = J1
   85     72      0           b2 = MAX(1 + J2 - l2, 0)
   85     73      0           DO I=l2, J2
                                 (...)
                              END DO
   92     85      0           GD = FOT * RHO(IQ)
   93     87      0           IF (IQ .NE. 1) THEN
   93     88      0              GD = 4.0 * RHO(IQ) - 2.0 * G(IQ) / R(IQ)
                              END IF
   94     89      0           GD1 = 4.0 * RHO(IQ1) - 2.0 * G(IQ1) / R(IQ1)
   95     90      0           AG = (GD + GD1)*HSQ + 2.0*(G(IQ) - G(IQ1))*HCU
   96     91      0           BG = - ((2.0*GD + GD1)*HR) - 3.0*(G(IQ) - G(IQ1))*HSQ
   98     93      0           b2 = 5
   98     94      0           DO IL=1, 5
                                 (...)
                              END DO
  185    200      0           GO TO 400
  189    201      0  99       CONTINUE 
  191    204      0  400      b2 = MAX(NINT, 0)
  191    205      0           DO II=1, NINT
                                 (...)
                              END DO
  195    213      0  100      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 3 function calls.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 68

 Line   Stmt   Time        Program

   68      *      5        DO iv=1, NINT, 32
   68      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
   68      *      6           DO VECTOR I=iv, rv
   69     49     18              TEMP(I) = 0.0D0
                              END DO
                           END DO
   69     48      0  142   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 85

 Line   Stmt   Time        Program

   85      *      6        DO iv=l2, J2, 32
   85      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
   85      *      6           DO VECTOR I=iv, rv
   88     76    172              A(I) = (EIF(i1, I*2) + EIF(IQ1, I*2))*HSQ + 2.0*(EIF(i1, I*2 - 1) -                            EIF(IQ1, I*2 - 1))*HCU
   90     78    180              B(I) = - ((2.0 * EIF(i1, I*2) + EIF(IQ1, I*2))*HR) - 3.0*(EIF(i1, 
                          $           I*2 - 1) - EIF(IQ1, I*2 - 1))*HSQ
                              END DO
                           END DO
   90     77      0  120   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 98

 Line   Stmt   Time        Program

   98     94      0        DO IL=1, 5
   99     95      0           T = 5.0E-01*HN*(XI(IL) + 1.0)
  100     96      0           RR = R1 + T
  101     97      0           RR2 = RR*RR
  102     98      0           X = 2.0*(RR - R(N670))/(R(MOHO) - R(N670)) - 1.0
  103     99      0           l3 = J1
  103    101      0           b3 = MAX(1 + J2 - l3, 0)
  103    102      0           DO I=l3, J2
                                 (...)
                              END DO
  109    114      0           AA = XAC*(ACON(i1) + T*(QACON(1, i1) + T*(QACON(2, i1)
                          $         + T * QACON(3, i1))))
  110    115      0           CC = XAC*(CCON(i1) + T*(QCCON(1, i1) + T*(QCCON(2, i1)
                          $         + T * QCCON(3, i1))))
  111    116      0           FF = XF*(FCON(i1) + T*(QFCON(1, i1) + T*(QFCON(2, i1)
                          $         + T * QFCON(3, i1))))
  112    117      0           LL = XLN*(LCON(i1) + T*(QLCON(1, i1) + T*(QLCON(2, i1)
                          $         + T * QLCON(3, i1))))
  113    118      0           NN = XLN*(NCON(i1) + T*(QNCON(1, i1) + T*(QNCON(2, i1)
                          $         + T * QNCON(3, i1))))
  114    119      0           RRHO = RHO(i1) + T*(QRHO(1, i1) + T*(QRHO(2, i1) + T * QRHO(3, i1)))
  115    120      0           GR = G(i1) + T*(GD + T*(BG + T*AG))
  116    121      0           RATV2 = RATVPS*(AA + CC)/(LL + NN)
  117    122      0           RRV2 = RATRVS/(LL + NN)
  118    123      0           ETAN = FF/(AA - 2.0*LL)
  120    125      0           IF (JCOM .EQ. 2) THEN
  120    126      0              GO TO 134
                              END IF
  121    127      0           F = 2.0*UR - FL3*VR
  122    128      0           XX = VPR - VR + UR
  123    129      0           XX2 = XX*XX
  124    130      0           VR2 = VR*VR
  125    131      0           UR2 = UR*UR
  126    132      0           RKA0 = F*F
  127    133      0           RKC0 = UPR*UPR
  128    134      0           RKF0 = 2.0*UPR*F
  129    135      0           RKL0 = FL3*XX2
  130    136      0           RKN0 = CON3*VR2 - RKA0
  131    137      0           T1 = (VR*(2.0*PR + GR*UR) - OMN2*VR2*RR)*RR
  132    138      0           RKR0 = ((8.0*RRHO - OMN2)*UR2*RR - GR*UR*(F + 2.0*UR) + 2.0*UR*PPR)*RR +                            FL3*T1
  134    139      0           GO TO 135
  136    141      0  134      XX = VPR - VR
  137    142      0           XX2 = XX*XX
  138    143      0           VR2 = VR*VR
  139    144      0           RKL0 = FL3*XX2
  140    145      0           RKN0 = CON3*VR2
  141    146      0           T1 = - (OMN2*VR2*RR2)
  142    147      0           RKR0 = FL3*T1
  147    150      0  135      IF (i1 .GE. N670 .OR. i1 .LT. N1100) THEN
  147    151      0              GO TO 204
                              END IF
  148    153      0           IF (JCOM .EQ. 2) THEN
  148    154      0              ADD = DBLE(WT(IL) * RRHO*DELV2*(RKN0 + RKL0 + RRV2*(NN*RKN0 + LL*RKL0                            + RRHO*RKR0))*HNH)
                              END IF
  150    156      0           IF (JCOM .NE. 2) THEN
  150    157      0              ADD = DBLE(WT(IL) * RRHO*DELV2*(RKN0 + RKL0 - 2.0*ETAN*RKF0 + RATV2*                           (RKA0 + RKC0 + ETAN*RKF0) + RRV2*(RKA0*AA + RKC0*CC + RKN0*NN + RKL0*LL +                            RKF0*FF + RKR0*RRHO))*HNH)
                              END IF
  154    158      0           TEMP(5) = TEMP(5) + ADD
  155    160      0           IF (IFANP .EQ. 0) THEN
  155    161      0              GO TO 204
                              END IF
  157    162      0           ADD = DBLE(WT(IL) * RRHO*DELV2*RKN0*HNH)
  158    163      0           TEMP(10) = TEMP(10) + ADD
  163    166      0  204      IF (i1 .LE. N670 .OR. i1 .GE. MOHO) THEN
  163    167      0              GO TO 224
                              END IF
  164    170      0           b3 = 4
  164    171      0           DO I=1, 4
                                 (...)
                              END DO
  174    184      0           IF (IFANP .EQ. 0) THEN
  174    185      0              GO TO 224
                              END IF
  176    188      0           b3 = 4
  176    189      0           DO I=1, 4
                                 (...)
                              END DO
  181    197      0  224      CONTINUE 
  183    198      0  110      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 2 function calls.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 103

 Line   Stmt   Time        Program

  103      *      6        DO iv=l3, J2, 32
  103      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
  103      *      6           DO VECTOR I=iv, rv
  106    105    133              Q(I) = EIF(i1, I*2 - 1) + T*(EIF(i1, I*2) + T*(B(I) + T * A(I)))
  107    107    121              QP(I) = (EIF(i1, I*2) + T*(2.0 * B(I) + T*3.0 * A(I)))*RR
                              END DO
                           END DO
  107    106      0  130   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 164

 Line   Stmt   Time        Program

  164    171      4        DO I=1, 4
  165    172      6           IIN = I - 1
  166    173     16           PNX = PN(IIN, X)
  167    175      8           IF (JCOM .EQ. 2) THEN
  167    176    239              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0 + RRV2*(NN*RKN0 + LL                           *RKL0 + RRHO*RKR0))*HNH)
                              END IF
  169    178      8           IF (JCOM .NE. 2) THEN
  169    179    463              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0 - 2.0*ETAN*RKF0 + RATV2                           *(RKA0 + RKC0 + ETAN*RKF0) + RRV2*(RKA0*AA + RKC0*CC + RKN0*NN + RKL0*LL +                            RKF0*FF + RKR0*RRHO))*HNH)
                              END IF
  173    181     46  235      TEMP(I) = TEMP(I) + ADD
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 176

 Line   Stmt   Time        Program

  176    189      4        DO I=1, 4
  177    190      6           IIN = I - 1
  178    191     16           PNX = PN(IIN, X)
  179    192    111           ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*RKN0*HNH)
  180    194     50  236      TEMP(5 + I) = TEMP(5 + I) + ADD
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 191

 Line   Stmt   Time        Program

  191      *      5        DO iv=1, NINT, 32
  191      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
  191      *      6           DO VECTOR II=iv, rv
  192    207     44              ACUM(II) = ACUM(II) + TEMP(II)
                              END DO
                           END DO
  192    206      0  146   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdprt.f
                    Origin -- Line 198

 Line   Stmt   Time        Program

  198      *      5        DO iv=1, NINT, 32
  198      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
  198      *      6           DO VECTOR I=iv, rv
  199    220     54              PARM(I) = FLOAT(ACUM(I) * 5.0D-01*DBLE(WCOM))
                              END DO
                           END DO
  199    219      0  264   CONTINUE 


No directives were found.

