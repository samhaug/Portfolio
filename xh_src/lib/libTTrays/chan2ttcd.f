      subroutine chan2ttcd(chin,ich,ierr)

      character*3 chin

c     declarations for phslist
      include 'phslist.h'

      i=0
      ifnd=0
      ierr=1
      do while(i.lt.MXNRCHAN.and.ifnd.eq.0)
       i=i+1
       if(chan(i).eq.chin) then
        ich=i
        ifnd=1
        ierr=0
       endif
      enddo
 
      end
        

