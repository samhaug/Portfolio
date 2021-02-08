c ----------------------------------------------------------------
      subroutine wint2ch(int,ch,lrch)

      character*4 ch

      if(int.lt.0) then
       ch(1:1)='-'
       int=-int
       if(int.lt.10) then
        lrch=2
        write(ch(2:2),'(i1)') int
       else if(int.ge.10.and.int.lt.100) then
        lrch=3
        write(ch(2:3),'(i2)') int
       else if(int.ge.100.and.int.lt.1000) then
        lrch=4
        write(ch(2:4),'(i3)') int
       else
        stop 'wint2ch; int.gt.999'
       endif
       int=-int
      else
       if(int.lt.10) then
        lrch=1
        write(ch,'(i1)') int
       else if(int.ge.10.and.int.lt.100) then
        lrch=2
        write(ch,'(i2)') int
       else if(int.ge.100.and.int.lt.1000) then
        lrch=3
        write(ch,'(i3)') int
       else
        stop 'wint2ch; int.gt.999'
       endif
      endif

      end

