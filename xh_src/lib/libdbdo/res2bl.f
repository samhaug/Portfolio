      subroutine res2bl(lu,infile,ierr)
      character*(*) infile
      character*80 line
      character*3 cod
      include 'seeddefs.h'
      include 'cbufcm.h'

      close(77)
      open(77,file=infile,status='old',iostat=ioerr)
      if(ierr.ne.0) then
        write(6,*) 'res2bl: Cannot open input file; ioerr=',ioerr
        ierr=9
        return
      endif

  100 continue
      read(77,'(a80)',end=99) line
      lline=istlen(line)
      if(line(1:1).eq.'+'.or.lline.eq.0) goto 100

      cod='   '
      if(line(1:14).eq.'Response type:') then
        if(line(40:55).eq.'Poles and zeroes') then
          cod='053'
          goto 120
        else if(line(40:51).eq.'Coefficients') then
          cod='054'
          goto 120
        else if(line(40:49).eq.'Decimation') then
          cod='057'
          goto 120
        endif
      else if(line(1:22).eq.'Stage sequence number:') then
        cod='058'
        goto 120
      else
        stop 'Unexpected input line'
      endif
      stop 'Shouldn''t reach here'


  120 continue
      cbuf(1:3)=cod
      lcbuf=7

      ityp=ifindtyp(cod,indcd)

      if(cod.eq.'053') then
  
      else if(cod.eq.'054') then

      else if(cod.eq.'057') then

      else if(cod.eq.'058') then

      else
        stop 'unexpected code'
      endif


   99 continue
      close(77)
      return
      end


