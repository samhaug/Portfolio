             Vectorized Results From File spread.f
                    Origin -- Line 8

 Line   Stmt   Time        Program

   10      9      6        b2 = MAX(N, 0)
   10     10      4        r2 = N
   12     12      0  10    CONTINUE 
    8      *      4        DO I=1, 6
   10      *      5           DO J=1, r2
   12     13     65              EIF(1 - J + N, 7 - I) = EIFS(1 + N*(6 - I) - J + N)
                              END DO
                           END DO


No directives were found.

