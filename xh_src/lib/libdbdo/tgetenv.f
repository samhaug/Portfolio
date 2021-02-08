      character*80 str,fgetenv
      str=fgetenv('PWD',lstr)
      str(lstr+1:lstr+1)='%'
      write(6,*) lstr
      write(6,*) ':'//str(1:lstr+1)//':'
      call wtout(str(1:lstr+1)//':')
      end
      subroutine wtout(str)
      character*(*) str
      character*80 str1
      lstr=len(str)
      str1=str
      write(6,*) len(str)
      write(6,*) ':'//str1(1:lstr)//':'
      return
      end


