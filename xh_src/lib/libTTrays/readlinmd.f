      subroutine readlinmd(fli)

      implicit double precision(a-h,o-z)
      character*80 fli
      parameter(MXLAY=500)
      common/linmd/depl(MXLAY),vell(MXLAY),nlay

      open(10,file=fli,status='old')
      i=1
10    read(10,*,end=20) depl(i),vell(i)
       i=i+1
       if(i.gt.MXLAY) stop 'readlinmd: i.gt.MXLAY'
      goto 10

20    continue
      nlay=i-1
      
      end
      
