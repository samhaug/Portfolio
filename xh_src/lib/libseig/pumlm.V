             Vectorized Results From File pumlm.f
                    Origin -- Line 67

 Line   Stmt   Time        Program

   67      *      5        DO iv=1, NINT, 32
   67      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
   67      *      6           DO VECTOR I=iv, rv
   68     36     18              ACUM(I) = 0.0D0
                              END DO
                           END DO
   68     35      0  141   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 70

 Line   Stmt   Time        Program

   70     45      0        DO IQ=l1, NTOP
   71     47      0           b2 = MAX(NINT, 0)
   71     48      0           DO I=1, NINT
                                 (...)
                              END DO
   73     56      0           IF (IQ .EQ. N) THEN
   73     57      0              GO TO 99
                              END IF
   75     58      0           IIQ = IQ
   76     59      0           CALL CORFAC(IIQ, WCOM, JCOM, XAC, XF, XLN)
   78     60      0           IQ1 = IQ + 1
   79     61      0           R1 = R(IQ)
   80     62      0           R2 = R(IQ1)
   81     63      0           HN = R2 - R1
   82     64      0           HNH = HN*5.0E-01
   83     66      0           IF (HN .LT. 1.0E-04) THEN
   83     67      0              GO TO 99
                              END IF
   84     68      0           HR = 1.0/HN
   85     69      0           HSQ = HR*HR
   86     70      0           HCU = HR*HSQ
   88     71      0           l2 = J1
   88     73      0           b2 = MAX(1 + J2 - l2, 0)
   88     74      0           DO I=l2, J2
                                 (...)
                              END DO
   95     86      0           GD = FOT * RHO(IQ)
   96     88      0           IF (IQ .NE. 1) THEN
   96     89      0              GD = 4.0 * RHO(IQ) - 2.0 * G(IQ) / R(IQ)
                              END IF
   97     90      0           GD1 = 4.0 * RHO(IQ1) - 2.0 * G(IQ1) / R(IQ1)
   98     91      0           AG = (GD + GD1)*HSQ + 2.0*(G(IQ) - G(IQ1))*HCU
   99     92      0           BG = - ((2.0*GD + GD1)*HR) - 3.0*(G(IQ) - G(IQ1))*HSQ
  101     94      0           b2 = 5
  101     95      0           DO IL=1, 5
                                 (...)
                              END DO
  184    192      0           GO TO 400
  187    194      0  99       RR = R(IQ)
  188    195      0           RR2 = RR*RR
  189    197      0           b2 = 2
  189    198      0           DO IDIS=1, 3, 2
                                 (...)
                              END DO
  257    280      0  400      b2 = MAX(NINT, 0)
  257    281      0           DO II=1, NINT
                                 (...)
                              END DO
  261    289      0  100      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 4 function calls.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 71

 Line   Stmt   Time        Program

   71      *      5        DO iv=1, NINT, 32
   71      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
   71      *      6           DO VECTOR I=iv, rv
   72     50     18              TEMP(I) = 0.0D0
                              END DO
                           END DO
   72     49      0  142   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 88

 Line   Stmt   Time        Program

   88      *      6        DO iv=l2, J2, 32
   88      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
   88      *      6           DO VECTOR I=iv, rv
   91     77    172              A(I) = (EIF(i1, I*2) + EIF(IQ1, I*2))*HSQ + 2.0*(EIF(i1, I*2 - 1) -                            EIF(IQ1, I*2 - 1))*HCU
   93     79    180              B(I) = - ((2.0 * EIF(i1, I*2) + EIF(IQ1, I*2))*HR) - 3.0*(EIF(i1, 
                          $           I*2 - 1) - EIF(IQ1, I*2 - 1))*HSQ
                              END DO
                           END DO
   93     78      0  120   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 101

 Line   Stmt   Time        Program

  101     95      0        DO IL=1, 5
  102     96      0           T = 5.0E-01*HN*(XI(IL) + 1.0)
  103     97      0           RR = R1 + T
  104     98      0           RR2 = RR*RR
  105     99      0           X = 2.0*(RR - R(N670))/(R(MOHO) - R(N670)) - 1.0
  106    100      0           l3 = J1
  106    102      0           b3 = MAX(1 + J2 - l3, 0)
  106    103      0           DO I=l3, J2
                                 (...)
                              END DO
  112    115      0           AA = XAC*(ACON(i1) + T*(QACON(1, i1) + T*(QACON(2, i1)
                          $         + T * QACON(3, i1))))
  113    116      0           CC = XAC*(CCON(i1) + T*(QCCON(1, i1) + T*(QCCON(2, i1)
                          $         + T * QCCON(3, i1))))
  114    117      0           FF = XF*(FCON(i1) + T*(QFCON(1, i1) + T*(QFCON(2, i1)
                          $         + T * QFCON(3, i1))))
  115    118      0           LL = XLN*(LCON(i1) + T*(QLCON(1, i1) + T*(QLCON(2, i1)
                          $         + T * QLCON(3, i1))))
  116    119      0           NN = XLN*(NCON(i1) + T*(QNCON(1, i1) + T*(QNCON(2, i1)
                          $         + T * QNCON(3, i1))))
  117    120      0           RRHO = RHO(i1) + T*(QRHO(1, i1) + T*(QRHO(2, i1) + T * QRHO(3, i1)))
  118    121      0           GR = G(i1) + T*(GD + T*(BG + T*AG))
  119    122      0           RATV2 = RATVPS*(AA + CC)/(LL + NN)
  120    123      0           RRV2 = RATRVS/(LL + NN)
  121    124      0           ETAN = FF/(AA - 2.0*LL)
  123    126      0           IF (JCOM .EQ. 2) THEN
  123    127      0              GO TO 134
                              END IF
  124    128      0           F = 2.0*UR - FL3*VR
  125    129      0           XX = VPR - VR + UR
  126    130      0           XX2 = XX*XX
  127    131      0           VR2 = VR*VR
  128    132      0           UR2 = UR*UR
  129    133      0           RKA0 = F*F
  130    134      0           RKC0 = UPR*UPR
  131    135      0           RKF0 = 2.0*UPR*F
  132    136      0           RKL0 = FL3*XX2
  133    137      0           RKN0 = CON3*VR2 - RKA0
  134    138      0           T1 = (VR*(2.0*PR + GR*UR) - OMN2*VR2*RR)*RR
  135    139      0           RKR0 = ((8.0*RRHO - OMN2)*UR2*RR - GR*UR*(F + 2.0*UR) + 2.0*UR*PPR)*RR +                            FL3*T1
  137    140      0           GO TO 135
  139    142      0  134      XX = VPR - VR
  140    143      0           XX2 = XX*XX
  141    144      0           VR2 = VR*VR
  142    145      0           RKL0 = FL3*XX2
  143    146      0           RKN0 = CON3*VR2
  144    147      0           T1 = - (OMN2*VR2*RR2)
  145    148      0           RKR0 = FL3*T1
  150    151      0  135      IF (i1 .LE. N670 .OR. i1 .GE. MOHO) THEN
  150    152      0              GO TO 224
                              END IF
  151    153      0           X = 2.0*(RR - R(N670))/(R(MOHO) - R(N670)) - 1.0
  152    155      0           b3 = 4
  152    156      0           DO I=1, 4
                                 (...)
                              END DO
  167    171      0  224      IF (i1 .LE. NOC .OR. i1 .GE. N670) THEN
  167    172      0              GO TO 424
                              END IF
  169    173      0           X = 2.0*(RR - R(NOC))/(R(N670) - R(NOC)) - 1.0
  170    175      0           b3 = 5
  170    176      0           DO I=1, 5
                                 (...)
                              END DO
  180    189      0  424      CONTINUE 
  182    190      0  110      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 2 function calls.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 106

 Line   Stmt   Time        Program

  106      *      6        DO iv=l3, J2, 32
  106      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
  106      *      6           DO VECTOR I=iv, rv
  109    106    133              Q(I) = EIF(i1, I*2 - 1) + T*(EIF(i1, I*2) + T*(B(I) + T * A(I)))
  110    108    121              QP(I) = (EIF(i1, I*2) + T*(2.0 * B(I) + T*3.0 * A(I)))*RR
                              END DO
                           END DO
  110    107      0  130   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 152

 Line   Stmt   Time        Program

  152    156      4        DO I=1, 4
  153    157      6           IIN = I - 1
  154    158     16           PNX = PN(IIN, X)
  155    160      8           IF (JCOM .EQ. 2) THEN
  155    161    239              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0 + RRV2*(NN*RKN0 + LL                           *RKL0 + RRHO*RKR0))*HNH)
                              END IF
  157    163      8           IF (JCOM .NE. 2) THEN
  157    164    463              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0 - 2.0*ETAN*RKF0 + RATV2                           *(RKA0 + RKC0 + ETAN*RKF0) + RRV2*(RKA0*AA + RKC0*CC + RKN0*NN + RKL0*LL +                            RKF0*FF + RKR0*RRHO))*HNH)
                              END IF
  161    166     46  235      TEMP(I) = TEMP(I) + ADD
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 170

 Line   Stmt   Time        Program

  170    176      4        DO I=1, 5
  171    177      6           IIN = I - 1
  172    178     16           PNX = PN(IIN, X)
  173    180      8           IF (JCOM .EQ. 2) THEN
  173    181    239              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0 + RRV2*(NN*RKN0 + LL                           *RKL0 + RRHO*RKR0))*HNH)
                              END IF
  175    183      8           IF (JCOM .NE. 2) THEN
  175    184    463              ADD = DBLE(WT(i2) * RRHO*DELV2*PNX*(RKN0 + RKL0 - 2.0*ETAN*RKF0 + RATV2                           *(RKA0 + RKC0 + ETAN*RKF0) + RRV2*(RKA0*AA + RKC0*CC + RKN0*NN + RKL0*LL +                            RKF0*FF + RKR0*RRHO))*HNH)
                              END IF
  179    186     50  435      TEMP(4 + I) = TEMP(4 + I) + ADD
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 189

 Line   Stmt   Time        Program

  189    198      0        DO IDIS=1, 3, 2
  190    199      0           IQT = i1 + (IDIS - 1)/2
  191    201      0           IF (IQT .GT. N) THEN
  191    202      0              GO TO 119
                              END IF
  193    203      0           CALL CORFAC(IQT, WCOM, JCOM, XAC, XF, XLN)
  195    204      0           l3 = J1
  195    206      0           b3 = MAX(1 + J2 - l3, 0)
  195    207      0           DO I=l3, J2
                                 (...)
                              END DO
  201    220      0           IF (JCOM .EQ. 2) THEN
  201    221      0              GO TO 192
                              END IF
  202    222      0           GR = G(IQT)
  203    223      0           AA = XAC * ACON(IQT)
  204    224      0           CC = XAC * CCON(IQT)
  205    225      0           FF = XF * FCON(IQT)
  206    227      0  192      LL = XLN * LCON(IQT)
  207    228      0           NN = XLN * NCON(IQT)
  208    229      0           RRHO = RHO(IQT)
  210    231      0           IF (JCOM .EQ. 2) THEN
  210    232      0              GO TO 194
                              END IF
  211    233      0           F = 2.0*UR - FL3*VR
  212    234      0           XX = VPR - VR + UR
  213    235      0           XX2 = XX*XX
  214    236      0           VR2 = VR*VR
  215    237      0           UR2 = UR*UR
  216    238      0           T1 = (VR*(2.0*PR + GR*UR) - OMN2*VR2*RR)*RR
  217    239      0           RKA0 = F*F
  218    240      0           RKC0 = - (UPR*UPR)
  220    242      0           RKF0 = 0.0
  222    244      0           RKL0 = FL3*XX2 - 2.0*FL3*VPR*XX
  224    246      0           RKN0 = CON3*VR2 - RKA0
  226    248      0           RKR0 = ((8.0*RRHO - OMN2)*UR2*RR - GR*UR*(F + 2.0*UR) + 2.0*UR*PPR)*RR +                            FL3*T1
  229    250      0           GO TO 195
  231    252      0  194      XX = VPR - VR
  232    253      0           XX2 = XX*XX
  233    254      0           VR2 = VR*VR
  234    255      0           T1 = - (OMN2*VR2*RR2)
  235    256      0           RKL0 = FL3*XX2 - 2.0*FL3*VPR*XX
  237    258      0           RKN0 = CON3*VR2
  239    260      0           RKR0 = FL3*T1
  245    264      0  195      IF (i1 .NE. N670) THEN
  245    265      0              GO TO 304
                              END IF
  246    266      0           DELH = DELDIS
  247    268      0           IF (JCOM .NE. 2) THEN
  247    269      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(AA*RKA0 + CC*RKC0 + FF*RKF0 + LL                           *RKL0 + NN*RKN0 + RRHO*RKR0)))
                              END IF
  250    271      0           IF (JCOM .EQ. 2) THEN
  250    272      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(LL*RKL0 + NN*RKN0 + RRHO*RKR0)))                           
                              END IF
  252    273      0           TEMP(10) = TEMP(10) + ADD
  253    274      0  304      CONTINUE 
  255    275      0  119      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 195

 Line   Stmt   Time        Program

  195      *      6        DO iv=l3, J2, 32
  195      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
  195      *      6           DO VECTOR I=iv, rv
  198    210     46              Q(I) = EIF(IQT, I*2 - 1)
  199    212     55              QP(I) = EIF(IQT, I*2) * RR
                              END DO
                           END DO
  199    211      0  129   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 257

 Line   Stmt   Time        Program

  257      *      5        DO iv=1, NINT, 32
  257      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
  257      *      6           DO VECTOR II=iv, rv
  258    283     44              ACUM(II) = ACUM(II) + TEMP(II)
                              END DO
                           END DO
  258    282      0  146   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File pumlm.f
                    Origin -- Line 264

 Line   Stmt   Time        Program

  264      *      5        DO iv=1, NINT, 32
  264      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
  264      *      6           DO VECTOR I=iv, rv
  265    296     54              PARM(I) = FLOAT(ACUM(I) * 5.0D-01*DBLE(WCOM))
                              END DO
                           END DO
  265    295      0  264   CONTINUE 


No directives were found.

