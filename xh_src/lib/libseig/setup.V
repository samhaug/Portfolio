             Vectorized Results From File setup.f
                    Origin -- Line 25

 Line   Stmt   Time        Program

   25      *      5        DO iv=1, N, 32
   25      *      9           rv = MIN(N, 31 + iv)
    *      *      9           vl = rv - iv + 1
   25      *      6           DO VECTOR I=iv, rv
   26      8     28              R(I) = RECD(I)
                              END DO
                           END DO


No directives were found.

--------------------------------------
             Vectorized Results From File setup.f
                    Origin -- Line 40

 Line   Stmt   Time        Program

   40      *      5        DO I=1, LTOT
    *     31      7           br1 = I .LT. LTOT
   41     32     18           IF (br1) I1 = INT(IADDR(1 + I))
    *     34      7           br2 = I .EQ. LTOT
   42     35     16           IF (br2) I1 = INT(IADDR(I))
    *     37      7           br3 = I .EQ. LTOT
   43     38      7           IF (br3) I1 = ABS(I1) + 1
   45     40     32           NOVERT(I) = ABS(I1) - ABS(INT(IADDR(I)))
   46     42     20           IF (IADDR(I) .LT. IZERO) THEN
   46     43      3              GO TO 1
                              END IF
   47     44      6           KNTS = KNTS + 1
   48     45      6           LMAXS = 1 + LMAXS
   49     46     18           NUMBS = NUMBS + NOVERT(I)
   50     47     27           INDSFR(KNTS) = INT(IADDR(I))
   51     48     26           KNTSFR(KNTS) = NOVERT(I)
   52     49      0  1        CONTINUE 
                           END DO


No directives were found.

--------------------------------------
             Vectorized Results From File setup.f
                    Origin -- Line 56

 Line   Stmt   Time        Program

   56      *      5        DO I=1, LTOT
   57     67     20           IF (IADDR(I) .GT. IZERO) THEN
   57     68      3              GO TO 2
                              END IF
   58     69      6           KNTT = KNTT + 1
   59     70      6           LMAXT = 1 + LMAXT
   60     71     28           INDTOR(KNTT) = INT(-IADDR(I))
   61     72     26           KNTTOR(KNTT) = NOVERT(I)
   62     73     18           NUMBT = NUMBT + NOVERT(I)
   63     74      0  2        CONTINUE 
                           END DO


No directives were found.

