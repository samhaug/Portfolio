
C$**********************************************************************
      FUNCTION ATANT(X,Y)
      IF(X.NE.0..OR.Y.NE.0.) THEN
        ATANT=ATAN2(X,Y)
      ELSE
        ATANT=0.
      ENDIF
      RETURN
      END
