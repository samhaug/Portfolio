c-----------------------------------------------------------------
      subroutine lparseh(file,prompt,delim,suffix,commds,ncommds,doit)
      character*(*) file,suffix
      character*20 commds(*)
      character*1 prompt,delim

      call lparse(file,prompt,delim,suffix,commds,ncommds,doit)
      return
      end
