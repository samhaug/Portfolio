c---------------------------------------------------------------------
      function ifindtyp(cod,indcd)
      character*(*) cod
      include 'seeddefs.h'
      itp=0
      do i=1,MXTYPES
         do j=1,ncodes(i)
           if(cod.eq.codes(j,i)) then
             itp=i
             icd=j
             goto 10
           endif
         enddo
      enddo
      if(itp.eq.0) pause 'ifindtyp: unknown code'
   10 indcd=indcods(icd,itp)
      ifindtyp=itp
      return
      end
