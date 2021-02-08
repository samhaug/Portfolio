c ------------------------------------------------------------
      subroutine strgrepdelim(strin,delim,strout,ilsub,nsub)

      parameter(MAXSUB=50)
      character*50 strout(MAXSUB)
      character*(*) strin
      character*1 delim
      dimension ilsub(MAXSUB)
      integer posst(MAXSUB)

      do i=1,MAXSUB
       strout(i)=''
      enddo
  
      l=istlen(strin)
 
      ndelim=1
      posst(ndelim)=0
      do i=1,l
       if(strin(i:i).eq.delim) then
        ndelim=ndelim+1
        posst(ndelim)=i
       endif
      enddo

      posst(ndelim+1)=l

      do i=1,ndelim
       strout(i)=strin(posst(i)+1:posst(i+1)-1)
       ilsub(i)=posst(i+1)-posst(i)-1
      enddo

      end

       
