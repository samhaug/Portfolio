c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      function istlen(string)
      character*1 null
      character*(*) string
      null=char(0)
      k=len(string)
      istlen=0
c     write(6,*) 'in istlen k= ', k, ' string= ', string
      do 10 i=1,k
        j=k+1-i
c       write(6,*) 'in istlen j= ', j,'  strj_j= ', string(j:j)
        if(string(j:j).eq.' '.or.string(j:j).eq.null) goto 10
        istlen=j
        goto 88
   10 continue
88    continue
      do 20 i=1,istlen
c       write(6,*) 'in istlen i= ', i,'  strj_i= ', string(i:i)
        if(string(i:i).eq.' '.or.string(i:i).eq.null) goto 20
        istlen=istlen-i+1
        goto 99
   20 continue
99    continue
c     write(6,*) 'istlen= ', istlen
      return
      end
