      subroutine getstr(cbuf,iout,string,lstring)
      character*(*) cbuf,string
      character*1 str1
      lmax=len(string)
      string=' '
      lstring=0
   10 iout=1+iout
      str1=cbuf(iout:iout)
      if(str1.ne.'~') then
        lstring=lstring+1
        if(lstring.gt.lmax) pause 'runaway string in getstr'
        string(lstring:lstring)=str1
        goto 10
      endif
      return
      end
