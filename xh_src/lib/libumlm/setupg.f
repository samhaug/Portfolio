      subroutine setupg(file,lur,luw,luf,mnem,prm)
      character*(*) file
      dimension mnem(1),prm(1)
      call setupa(file,lur,luw,luf,mnem,prm,0)
      return
      end
