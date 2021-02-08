             Vectorized Results From File getkr.f
                    Origin -- Line 31

 Line   Stmt   Time        Program

   31     37      4        DO IVAR=1, 3
   32     38     16           IRECMP = 3 + NBATCH*(IVAR - 1) + IBATCH
   33     40     60  30       CALL BFFI(LUMP1, 1, B(1, 1 + (IVAR - 1)*4), 4*256*4, J, M, IRECMP)
                           END DO


Loop was not analyzed for the following reasons:

   1) This loop contains 1 function calls.

--------------------------------------
             Vectorized Results From File getkr.f
                    Origin -- Line 37

 Line   Stmt   Time        Program

    *      *      3        vl = 12
   37      *      4        DO VECTOR I=1, 12
   38     50     40           AMP(I) = B(IND, I)
                           END DO
   38     49      0  60    CONTINUE 


No directives were found.

--------------------------------------
             Vectorized Results From File getkr.f
                    Origin -- Line 39

 Line   Stmt   Time        Program

   39      *      5        DO iv=1, NPARM, 32
   39      *      9           rv = MIN(NPARM, 31 + iv)
    *      *      9           vl = rv - iv + 1
   39      *      6           DO VECTOR I=iv, rv
   40     60     40              AKER(I) = BKER(IND, I)
                              END DO
                           END DO
   40     59      0  70    CONTINUE 


No directives were found.

