             Vectorized Results From File seteig.f
                    Origin -- Line 26

 Line   Stmt   Time        Program

   26      *      5        DO iv=1, NO, 32
   26      *      9           rv = MIN(NO, 31 + iv)
    *      *      9           vl = rv - iv + 1
   26      *      6           DO VECTOR I=iv, rv
   28     19     37              R(I) = RBUF(5 + I)
                              END DO
                           END DO
   28     18      0  5533  CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File seteig.f
                    Origin -- Line 34

 Line   Stmt   Time        Program

   34     33      0        DO I=1, NUMR
   35     34      0           I1 = I2 + 1
   36     35      0           I2 = MIN(NUF, I1 + NINF - 1)
   37     36      0           CALL BFFI(LLU, 1, IOBUF, (I2 - I1 + 1)*2, JSTAT, NREAD, 0)
   38     37      0           l2 = I1
   38     39      0           b2 = MAX(1 + I2 - l2, 0)
   38     40      0           DO K=l2, I2
                                 (...)
                              END DO
   40     48      0  230      CONTINUE 
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File seteig.f
                    Origin -- Line 38

 Line   Stmt   Time        Program

   38     40      4        r2 = I2
   39     41      0  5511  CONTINUE 
   38      *      6        DO K=l2, r2
   39     42     31           INDF(K) = JOBUF(1 + K - I1)
                           END DO


No directives were found.

--------------------------------------
             Vectorized Results From File seteig.f
                    Origin -- Line 42

 Line   Stmt   Time        Program

   42      *      5        DO I=1, NUF
   43     54      3           ITORS = 2
    *     56     17           br1 = INDF(I) .LT. 0
   44     57      3           IF (br1) ITORS = 1
   45     58     28           MAXL(ITORS) = MAXL(ITORS) + 1
   46     59     18           IND = INT(MAXL(ITORS) + 1)
   48     61     42           NREC(IND, ITORS) = CONVERT(ABS(INT(INDF(I))) + 1)
   49     62     25           MAXN(IND, ITORS) = 0
   50     64      9           IF (I .EQ. NUF) THEN
   50     65      3              GO TO 10
                              END IF
   52     67     68           MAXN(IND, ITORS) = CONVERT(ABS(INT(INDF(1 + I))) - INT(NREC(IND, 
                          $        ITORS)))
   53     68     50           NREC(IND, ITORS) = NREC(IND, ITORS) - 1
   54     69      0  10       CONTINUE 
                           END DO


No directives were found.

