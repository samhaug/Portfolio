
c-------------------------------------------------------------------------- 

      character*80 function getwd(string,ind,term,lgot)
      character*(*) string
      character*(*) term
      lstring=len(string)
      if(term.eq.'EOL') then
        getwd=string(ind:lstring)
        lgot=lstring-ind+1
        ind=lstring+1
      else
        ib=ind
        do while(ind.le.lstring.and.string(ind:ind).ne.term)
          ind=ind+1
        enddo
        getwd=string(ib:ind-1)
        lgot=ind-ib
        return
      endif
      end
