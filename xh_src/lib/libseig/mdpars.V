             Vectorized Results From File mdpars.f
                    Origin -- Line 70

 Line   Stmt   Time        Program

   70      *      5        DO iv=1, NINT, 32
   70      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
   70      *      6           DO VECTOR I=iv, rv
   71     35     18              ACUM(I) = 0.0D0
                              END DO
                           END DO
   71     34      0  141   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdpars.f
                    Origin -- Line 75

 Line   Stmt   Time        Program

   75     49      0        DO IQ=l1, N
   76     51      0           b2 = MAX(NINT, 0)
   76     52      0           DO I=1, NINT
                                 (...)
                              END DO
   78     60      0           IF (IQ .EQ. N) THEN
   78     61      0              GO TO 99
                              END IF
   80     62      0           IIQ = IQ
   81     63      0           CALL CORFAC(IIQ, WCOM, JCOM, XAC, XF, XLN)
   83     64      0           IQ1 = IQ + 1
   84     65      0           R1 = R(IQ)
   85     66      0           R2 = R(IQ1)
   86     67      0           HN = R2 - R1
   87     68      0           HNH = HN*5.0E-01
   88     70      0           IF (HN .LT. 1.0E-04) THEN
   88     71      0              GO TO 99
                              END IF
   89     72      0           HR = 1.0/HN
   90     73      0           HSQ = HR*HR
   91     74      0           HCU = HR*HSQ
   93     75      0           l2 = J1
   93     77      0           b2 = MAX(1 + J2 - l2, 0)
   93     78      0           DO I=l2, J2
                                 (...)
                              END DO
  101     90      0           ELLD = 0.0
  102     92      0           IF (IQ .NE. 1) THEN
  102     93      0              ELLD = ELL(IQ) * ETA(IQ) / R(IQ)
                              END IF
  103     94      0           ELLD1 = ELL(IQ1) * ETA(IQ1) / R(IQ1)
  104     95      0           AE = (ELLD + ELLD1)*HSQ + 2.0*(ELL(IQ) - ELL(IQ1))*HCU
  105     96      0           BE = - ((2.0*ELLD + ELLD1)*HR) - 3.0*(ELL(IQ) - ELL(IQ1))*HSQ
  107     97      0           GD = FOT * RHO(IQ)
  108     99      0           IF (IQ .NE. 1) THEN
  108    100      0              GD = 4.0 * RHO(IQ) - 2.0 * G(IQ) / R(IQ)
                              END IF
  109    101      0           GD1 = 4.0 * RHO(IQ1) - 2.0 * G(IQ1) / R(IQ1)
  110    102      0           AG = (GD + GD1)*HSQ + 2.0*(G(IQ) - G(IQ1))*HCU
  111    103      0           BG = - ((2.0*GD + GD1)*HR) - 3.0*(G(IQ) - G(IQ1))*HSQ
  113    105      0           b2 = 5
  113    106      0           DO IL=1, 5
                                 (...)
                              END DO
  235    293      0           GO TO 400
  237    295      0  99       RR = R(IQ)
  238    296      0           RR2 = RR*RR
  239    298      0           b2 = 2
  239    299      0           DO IDIS=1, 3, 2
                                 (...)
                              END DO
  356    436      0  400      b2 = MAX(NINT, 0)
  356    437      0           DO II=1, NINT
                                 (...)
                              END DO
  360    445      0  100      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 2 function calls.

--------------------------------------
             Vectorized Results From File mdpars.f
                    Origin -- Line 76

 Line   Stmt   Time        Program

   76      *      5        DO iv=1, NINT, 32
   76      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
   76      *      6           DO VECTOR I=iv, rv
   77     54     18              TEMP(I) = 0.0D0
                              END DO
                           END DO
   77     53      0  142   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdpars.f
                    Origin -- Line 93

 Line   Stmt   Time        Program

   93      *      6        DO iv=l2, J2, 32
   93      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
   93      *      6           DO VECTOR I=iv, rv
   96     81    172              A(I) = (EIF(i1, I*2) + EIF(IQ1, I*2))*HSQ + 2.0*(EIF(i1, I*2 - 1) -                            EIF(IQ1, I*2 - 1))*HCU
   98     83    180              B(I) = - ((2.0 * EIF(i1, I*2) + EIF(IQ1, I*2))*HR) - 3.0*(EIF(i1, 
                          $           I*2 - 1) - EIF(IQ1, I*2 - 1))*HSQ
                              END DO
                           END DO
   98     82      0  120   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdpars.f
                    Origin -- Line 113

 Line   Stmt   Time        Program

  117    110      4        l3 = J1
  117    112     11        b3 = MAX(1 + J2 - l3, 0)
  117    113      4        r3 = J2
  121    117      0  130   CONTINUE 
  113      *      4        DO IL=1, 5
  114    107     67           T = 5.0E-01*HN*(XI(IL) + 1.0)
  115    108     24           RR = R1 + T
  116    109     24           RR2 = RR*RR
  122    125    115           EL = ELL(i1) + T*(ELLD + T*(BE + T*AE))
  123    126    141           ET = (ELLD + T*(2.0*BE + T*3.0*AE))*RR/EL
  117      *      6           DO iv=l3, r3, 32
  117      *      9              rv = MIN(r3, 31 + iv)
    *      *      9              vl = rv - iv + 1
  117      *      6              DO VECTOR I=iv, rv
  120    116    133                 Q(I) = EIF(i1, I*2 - 1) + T*(EIF(i1, I*2) + T*(B(I) + T * A(I)))
  121    118    121                 QP(I) = (EIF(i1, I*2) + T*(2.0 * B(I) + T*3.0 * A(I)))*RR
                                 END DO
                              END DO
  125    128      8           IF (JCOM .EQ. 2) THEN
  125    129      3              GO TO 132
                              END IF
  126    130    115           GR = G(i1) + T*(GD + T*(BG + T*AG))
  127    131    194           AA = XAC*(ACON(i1) + T*(QACON(1, i1) + T*(QACON(2, i1)
                          $         + T * QACON(3, i1))))
  128    132    194           CC = XAC*(CCON(i1) + T*(QCCON(1, i1) + T*(QCCON(2, i1)
                          $         + T * QCCON(3, i1))))
  129    133    194           FF = XF*(FCON(i1) + T*(QFCON(1, i1) + T*(QFCON(2, i1)
                          $         + T * QFCON(3, i1))))
  130    134    183           AAP = XAC*(QACON(1, i1) + T*(2.0 * QACON(2, i1) + T*3.0 * QACON(3, i1))                           )
  131    135    183           CCP = XAC*(QCCON(1, i1) + T*(2.0 * QCCON(2, i1) + T*3.0 * QCCON(3, i1))                           )
  132    136    183           FFP = XF*(QFCON(1, i1) + T*(2.0 * QFCON(2, i1) + T*3.0 * QFCON(3, i1)
                          $        ))
  133    138    194  132      LL = XLN*(LCON(i1) + T*(QLCON(1, i1) + T*(QLCON(2, i1)
                          $         + T * QLCON(3, i1))))
  134    139    194           NN = XLN*(NCON(i1) + T*(QNCON(1, i1) + T*(QNCON(2, i1)
                          $         + T * QNCON(3, i1))))
  135    140    178           RRHO = RHO(i1) + T*(QRHO(1, i1) + T*(QRHO(2, i1) + T * QRHO(3, i1)))
  136    141    183           LLP = XLN*(QLCON(1, i1) + T*(2.0 * QLCON(2, i1) + T*3.0 * QLCON(3, i1))                           )
  137    142    183           NNP = XLN*(QNCON(1, i1) + T*(2.0 * QNCON(2, i1) + T*3.0 * QNCON(3, i1))                           )
  138    143    167           RHOP = QRHO(1, i1) + T*(2.0 * QRHO(2, i1) + T*3.0 * QRHO(3, i1))
  139    145      8           IF (JCOM .EQ. 2) THEN
  139    146      3              GO TO 134
                              END IF
  140    147     56           F = 2.0*UR - FL3*VR
  141    148     40           XX = VPR - VR + UR
  142    149     24           XX2 = XX*XX
  143    150     24           VR2 = VR*VR
  144    151     24           UR2 = UR*UR
  145    152    136           T1 = (VR*(2.0*PR + GR*UR) - OMN2*VR2*RR)*RR
  146    153     24           RKA0 = F*F
  147    154     24           RKC0 = UPR*UPR
  148    155     40           RKF0 = 2.0*UPR*F
  149    156     24           RKL0 = FL3*XX2
  150    157     40           RKL2 = RKL0 - 3.0*XX2
  151    158     40           RKN0 = CON3*VR2 - RKA0
  152    159     40           RKN2 = RKN0 - CON4*VR2
  153    160    248           RKR0 = ((8.0*RRHO - OMN2)*UR2*RR - GR*UR*(F + 2.0*UR) + 2.0*UR*PPR)*RR +                            FL3*T1
  155    161     40           RKR2 = RKR0 - 3.0*T1
  156    162    168           G1 = RRHO*(6.0*UR2 + 3.0*(UR*VPR - VR*(UPR + 2.0*F - UR)))
  157    163    120           G2 = RRHO*RR*(-2.0*UR*F + 3.0*UR*VR)
  158    164      8           PHP1 = GR
  159    165     93           PHP2 = 4.0*RRHO + (ET - 1.0)*GR/RR
  160    166      3           GO TO 135
  162    168     24  134      XX = VPR - VR
  163    169     24           XX2 = XX*XX
  164    170     24           VR2 = VR*VR
  165    171     52           T1 = - (OMN2*VR2*RR2)
  166    172     24           RKL0 = FL3*XX2
  167    173     40           RKL2 = RKL0 - 3.0*XX2
  168    174     24           RKN0 = CON3*VR2
  169    175     40           RKN2 = RKN0 - CON4*VR2
  170    176     24           RKR0 = FL3*T1
  171    177     40           RKR2 = RKR0 - 3.0*T1
  175    179     24  135      T1 = VR2*FL3
    *    181      6           br1 = JCOM .NE. 2
  176    182     24           IF (br1) T1 = T1 + UR2
  177    183     95           ADD = DBLE(WT(IL) * RR2*T1*RRHO*HNH)
  178    184     44           TEMP(13) = TEMP(13) + ADD
    *    186      6           br2 = JCOM .NE. 2
  182    187    351           IF (br2) ADD = DBLE(WT(IL) * RR*TWTH*EL*(AAP*RKA0 + CCP*RKC0 + FFP*RKF0                            + LLP*RKL2 + NNP*RKN2 + RHOP*RKR2 + PHP1*G1 + PHP2*G2)*HNH)
    *    189      6           br3 = JCOM .EQ. 2
  185    190    191           IF (br3) ADD = DBLE(WT(IL) * RR*TWTH*EL*(LLP*RKL2 + NNP*RKN2 + RHOP*RKR2                           )*HNH)
  187    191     44           TEMP(6) = TEMP(6) + ADD
  191    193     15           IF (i1 .GT. MOHO .OR. i1 .LT. N220) THEN
  191    194      3              GO TO 204
                              END IF
  192    196      8           IF (JCOM .EQ. 2) THEN
  192    197      3              GO TO 204
                              END IF
  193    198    127           ADD = DBLE(WT(IL) * RRHO*DELV2*(RKA0 + RKC0 + RKF0)*HNH)
  194    199     44           TEMP(8) = TEMP(8) + ADD
  199    202      9  204      IF (i1 .LT. MOHO) THEN
  199    203      3              GO TO 401
                              END IF
  200    204     33           VS =  MA_SQRT(LL/RRHO)
  201    205     33           VVP =  MA_SQRT(AA/RRHO)
  202    207      9           IF (i1 .GT. NMIDC) THEN
  202    208      3              GO TO 402
                              END IF
  203    209      8           DDRHO = DRLC
  204    210     56           DDVS2 = 2.0*VS*DVSLC*DELV
  205    211     56           DDVP2 = 2.0*VVP*DVPLC*DELV
  206    212      3           GO TO 404
  207    215      9  402      IF (i1 .GT. NSL) THEN
  207    216      3              GO TO 403
                              END IF
  208    217      8           DDRHO = DRUC
  209    218     56           DDVS2 = 2.0*VS*DVSUC*DELV
  210    219     56           DDVP2 = 2.0*VVP*DVPUC*DELV
  211    220      3           GO TO 404
  212    222      8  403      DDRHO = DROC
  213    223     56           DDVS2 = 2.0*VS*DVSOC*DELV
  214    224     56           DDVP2 = 2.0*VVP*DVPOC*DELV
  215    226     61  404      ETAN = FF/(AA - 2.0*LL)
    *    228      6           br4 = JCOM .NE. 2
  216    229    468           IF (br4) ADD = DBLE(WT(IL) * HNH*(RRHO*(DDVP2*(RKA0 + RKC0 + ETAN*RKF0)                            + DDVS2*(RKN0 + RKL0 - 2.0*ETAN*RKF0)) + (AA*RKA0 + CC*RKC0 + NN*RKN0 + LL                           *RKL0 + FF*RKF0 + RRHO*RKR0)*DDRHO/RRHO))
    *    231      6           br5 = JCOM .EQ. 2
  220    232    244           IF (br5) ADD = DBLE(WT(IL) * HNH*(RRHO*(DDVS2*(RKN0 + RKL0)) + (NN*RKN0                            + LL*RKL0 + RRHO*RKR0)*DDRHO/RRHO))
  223    233     44           TEMP(7) = TEMP(7) + ADD
  229    235      8  401      ADD = 0.0D0
    *    237      6           br6 = JCOM .NE. 2
  230    238    143           IF (br6) ADD = DBLE(WT(IL) * RR2*(VR2 + 2.0*UR*VR)*RRHO*HNH)
  231    239     44           TEMP(12) = TEMP(12) + ADD
                           END DO


No directives were found.

--------------------------------------
             Vectorized Results From File mdpars.f
                    Origin -- Line 239

 Line   Stmt   Time        Program

  239    299      0        DO IDIS=1, 3, 2
  240    300      0           IQT = i1 + (IDIS - 1)/2
  241    302      0           IF (IQT .GT. N) THEN
  241    303      0              GO TO 119
                              END IF
  243    304      0           CALL CORFAC(IQT, WCOM, JCOM, XAC, XF, XLN)
  245    305      0           l3 = J1
  245    307      0           b3 = MAX(1 + J2 - l3, 0)
  245    308      0           DO I=l3, J2
                                 (...)
                              END DO
  250    320      0           EL = ELL(IQT)
  252    322      0           IF (JCOM .EQ. 2) THEN
  252    323      0              GO TO 192
                              END IF
  253    324      0           GR = G(IQT)
  254    325      0           AA = XAC * ACON(IQT)
  255    326      0           CC = XAC * CCON(IQT)
  256    327      0           FF = XF * FCON(IQT)
  257    329      0  192      LL = XLN * LCON(IQT)
  258    330      0           NN = XLN * NCON(IQT)
  259    331      0           RRHO = RHO(IQT)
  261    333      0           IF (JCOM .EQ. 2) THEN
  261    334      0              GO TO 194
                              END IF
  262    335      0           F = 2.0*UR - FL3*VR
  263    336      0           XX = VPR - VR + UR
  264    337      0           XX2 = XX*XX
  265    338      0           VR2 = VR*VR
  266    339      0           UR2 = UR*UR
  267    340      0           T1 = (VR*(2.0*PR + GR*UR) - OMN2*VR2*RR)*RR
  268    341      0           RKA0 = F*F
  269    342      0           RKC0 = - (UPR*UPR)
  270    343      0           RKC2 = RKC0 + 6.0*VR*UPR
  271    344      0           RKF0 = 0.0
  272    345      0           RKF2 = 6.0*VR*F
  273    346      0           RKL0 = FL3*XX2 - 2.0*FL3*VPR*XX
  274    347      0           RKL2 = RKL0 - 3.0*XX2 + 6.0*VPR*XX
  275    348      0           RKN0 = CON3*VR2 - RKA0
  276    349      0           RKN2 = RKN0 - CON4*VR2
  277    350      0           RKR0 = ((8.0*RRHO - OMN2)*UR2*RR - GR*UR*(F + 2.0*UR) + 2.0*UR*PPR)*RR +                            FL3*T1
  279    351      0           RKR2 = RKR0 - 3.0*T1
  280    352      0           GO TO 195
  282    354      0  194      XX = VPR - VR
  283    355      0           XX2 = XX*XX
  284    356      0           VR2 = VR*VR
  285    357      0           T1 = - (OMN2*VR2*RR2)
  286    358      0           RKL0 = FL3*XX2 - 2.0*FL3*VPR*XX
  287    359      0           RKL2 = RKL0 - 3.0*XX2 + 6.0*VPR*XX
  288    360      0           RKN0 = CON3*VR2
  289    361      0           RKN2 = RKN0 - CON4*VR2
  290    362      0           RKR0 = FL3*T1
  291    363      0           RKR2 = RKR0 - 3.0*T1
  296    366      0  195      IF (JCOM .NE. 2) THEN
  296    367      0              ADD = DBLE(FLOAT(IDIS - 2)*RR*TWTH*EL*(AA*RKA0 + CC*RKC2 + FF*RKF2 +                            LL*RKL2 + NN*RKN2 + RRHO*RKR2))
                              END IF
  299    369      0           IF (JCOM .EQ. 2) THEN
  299    370      0              ADD = DBLE(FLOAT(IDIS - 2)*RR*TWTH*EL*(LL*RKL2 + NN*RKN2 + RRHO*RKR2                           ))
                              END IF
  301    371      0           TEMP(6) = TEMP(6) + ADD
  305    373      0           IF (i1 .NE. NMIDC .AND. i1 .NE. MOHO .AND. i1 .NE. NSL .AND. i1 .NE. N) THEN                           
  305    374      0              GO TO 301
                              END IF
  306    376      0           IF (i1 .EQ. N) THEN
  306    377      0              DELH = DRN*DELDIS
                              END IF
  307    379      0           IF (i1 .EQ. NSL) THEN
  307    380      0              DELH = DRNSL*DELDIS
                              END IF
  308    382      0           IF (i1 .EQ. NMIDC) THEN
  308    383      0              DELH = DRMIDC*DELDIS
                              END IF
  309    385      0           IF (i1 .EQ. MOHO) THEN
  309    386      0              DELH = DRMOHO*DELDIS
                              END IF
  310    388      0           IF (JCOM .NE. 2) THEN
  310    389      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(AA*RKA0 + CC*RKC0 + FF*RKF0 + LL                           *RKL0 + NN*RKN0 + RRHO*RKR0)))
                              END IF
  313    391      0           IF (JCOM .EQ. 2) THEN
  313    392      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(LL*RKL0 + NN*RKN0 + RRHO*RKR0)))                           
                              END IF
  315    393      0           TEMP(7) = TEMP(7) + ADD
  320    396      0  301      IF (i1 .NE. MOHO .AND. i1 .NE. NMIDC .AND. i1 .NE. NSL .AND. i1 .NE. N) THEN                           
  320    397      0              GO TO 302
                              END IF
  321    398      0           DELH = DELDIS
  322    400      0           IF (JCOM .NE. 2) THEN
  322    401      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(AA*RKA0 + CC*RKC0 + FF*RKF0 + LL                           *RKL0 + NN*RKN0 + RRHO*RKR0)))
                              END IF
  325    403      0           IF (JCOM .EQ. 2) THEN
  325    404      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(LL*RKL0 + NN*RKN0 + RRHO*RKR0)))                           
                              END IF
  327    405      0           TEMP(9) = TEMP(9) + ADD
  332    408      0  302      IF (i1 .NE. N) THEN
  332    409      0              GO TO 303
                              END IF
  333    410      0           DELH = DELDIS
  334    412      0           IF (JCOM .NE. 2) THEN
  334    413      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(AA*RKA0 + CC*RKC0 + FF*RKF0 + LL                           *RKL0 + NN*RKN0 + RRHO*RKR0)))
                              END IF
  337    415      0           IF (JCOM .EQ. 2) THEN
  337    416      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(LL*RKL0 + NN*RKN0 + RRHO*RKR0)))                           
                              END IF
  339    417      0           TEMP(10) = TEMP(10) + ADD
  344    420      0  303      IF (i1 .NE. N670) THEN
  344    421      0              GO TO 304
                              END IF
  345    422      0           DELH = DELDIS
  346    424      0           IF (JCOM .NE. 2) THEN
  346    425      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(AA*RKA0 + CC*RKC0 + FF*RKF0 + LL                           *RKL0 + NN*RKN0 + RRHO*RKR0)))
                              END IF
  349    427      0           IF (JCOM .EQ. 2) THEN
  349    428      0              ADD = DBLE(- (FLOAT(IDIS - 2)*DELH*(LL*RKL0 + NN*RKN0 + RRHO*RKR0)))                           
                              END IF
  351    429      0           TEMP(11) = TEMP(11) + ADD
  352    430      0  304      CONTINUE 
  354    431      0  119      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File mdpars.f
                    Origin -- Line 245

 Line   Stmt   Time        Program

  245      *      6        DO iv=l3, J2, 32
  245      *      9           rv = MIN(J2, 31 + iv)
    *      *      9           vl = rv - iv + 1
  245      *      6           DO VECTOR I=iv, rv
  248    311     46              Q(I) = EIF(IQT, I*2 - 1)
  249    313     55              QP(I) = EIF(IQT, I*2) * RR
                              END DO
                           END DO
  249    312      0  129   CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File mdpars.f
                    Origin -- Line 356

 Line   Stmt   Time        Program

  356      *      5        DO iv=1, NINT, 32
  356      *      9           rv = MIN(NINT, 31 + iv)
    *      *      9           vl = rv - iv + 1
  356      *      6           DO VECTOR II=iv, rv
  357    439     44              ACUM(II) = ACUM(II) + TEMP(II)
                              END DO
                           END DO
  357    438      0  146   CONTINUE 


No directives were found.

