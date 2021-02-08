c --------------------------------------------------------------------

      subroutine int2char(in,char,lchar)

      character*(*) char
      character*20 basis,tmp
      data basis/'0000000000000000000'/

      if(in.eq.0) then
       leni=1
      else
       leni=int(alog10(float(abs(in))))+1
       if(in.le.0) then leni=leni+1
      endif

      write(tmp,'(i20)') in
      char=basis(1:lchar-leni)//tmp(20-leni+1:20)

      end

