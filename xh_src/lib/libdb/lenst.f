

c-------------------------------------------------------------------

      integer*4 function lenst(string)
      character*(*) string
      l=len(string)
      lenst=0
      do i=1,l
        if(string(i:i).eq.' '.or.string(i:i).eq.'<0>') then
          goto 10
        else
          lenst=i
        endif
      enddo
   10 return
      end
