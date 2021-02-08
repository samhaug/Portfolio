      logical function pmatcht(patt,string)
      character*(*) patt,string

      character*1 ch,chr
      lpatt=istlen(patt)
      lstring=istlen(string)
      ic=0


      ik=0


      mode=0
      do while (.TRUE.)
        if(ic.ge.lpatt) then
          if(mode.eq.1) goto 101
          do i=ik,lstring-1
            chr=string(i+1:i+1)
            if(chr.ne.' ') then
              if(mode.eq.0) goto 102
              ik0=1+ik0
              ik=ik0
              ic=ic0
              goto 111
            endif
          enddo
          goto 101
  111     continue

        endif

        ch=patt(ic+1:ic+1)
        ich=ichar(ch)
        if(ch.ne.'?'.and.ch.ne.'*') then
          if(ik.ge.lstring) goto 102
          ichr=ichar(string(ik+1:ik+1))
          if(mode.eq.1) mode=2
          if(ichr.ne.ich) then
            if(mode.eq.0) goto 102
            ik0=1+ik0
            ik=ik0
            ic=ic0
          else




            ic=1+ic
            ik=1+ik
          endif
        else if(ch.eq.'?') then

          if(ik.ge.lstring) goto 102
          ichr=ichar(string(ik+1:ik+1))
          if(mode.eq.1) mode=2
          if(ichr.eq.z'20') then
            if(mode.eq.0) goto 102
            ik0=1+ik0
            ik=ik0
            ic=ic0
          else




            ic=1+ic
            ik=1+ik
          endif
        else if(ch.eq.'*') then
          mode=1
          ic=ic+1
          ik0=ik
          ic0=ic
        endif
      enddo
  102 continue
  100 continue
      pmatcht=.FALSE.
      return
  101 continue
      pmatcht=.TRUE.
      return
      end
