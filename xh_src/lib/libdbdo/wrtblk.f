c--------------------------------------------------------------
      subroutine wrtblk(lu,cod,itp,cbuf,iformat,ifunab)
      character*(*) cod,cbuf
      include 'seeddefs.h'
      include 'seedtrees.h'
      character*200 mess
      character*132 line
      character*1 tabs(MXLEVLS)/MXLEVLS*'\t'/
      character*200 str
      character*10 form
      character*4 str4
      character*3 codi
      logical getabr
      codi=cod
      k=0
      ient=0
      lline=0
      lsee=0
      ifgot=0
      inum=len(cbuf)
      if(iformat.eq.1.or.iformat.eq.2) then
        do while(ient.ge.0)
          call getfield(cod,itp,cbuf,k,indcd,ient,ilev,mess,lmess,icdstat)
          if(ient.eq.0) then
            if(iformat.eq.1) then
              write(lu,'(4a)') '{Code: ','[',cod,']  '
     1        ,cdescrs(indcd)(1:lcdescrs(indcd))
            else if(iformat.eq.2) then
              lline=6
              lsee=6
              line(1:lline)='{['//codi//']'
              ifgot=1
            else if(iformat.eq.3) then
            else
              write(0,*) 'Unknown format'
              call exit(2)
            endif
            
            iflush=0
            if(icdstat.eq.IUNSPT) then
              write(0,'(2a)') 'Encountered blockette code:',cod
              stop 'wrtblk: code unsupported'
c             return
            else if(icdstat.eq.IGNORE) then
              write(0,'(3a)') 'Code:',cod,' ignored'
              return
            else if(icdstat.eq.IREFCD) then
              iflush=1
            else if(icdstat.eq.INTRPC) then
              continue
            else
              stop 'wrtblk: unknown code status'
            endif

          else if(ient.gt.0) then
            itt=MXDICTS*(entstat(ient,indcd)/MXDICTS)
            if(ifunab.eq.0) then
            else if(ifunab.eq.1) then
              if(itt.eq.LOOKUP.or.itt.eq.INSERT) then
                idc=mod(entstat(ient,indcd),MXDICTS)
                str=dicfls(idc)//'.'//mess(1:lmess)
                lmess=lmess+3
                if(lmess.gt.10) stop 'wrtblk: unexpected 5'
                mess(1:lmess)=str(1:lmess)
              endif
            else if(ifunab.eq.2) then
              if(itt.eq.INSERT) then
                idc=mod(entstat(ient,indcd),MXDICTS)
                str=dicfls(idc)//'.'//mess(1:lmess)
                lmess=lmess+3
                if(lmess.gt.10) stop 'wrtblk: unexpected 5'
                mess(1:lmess)=str(1:lmess)
              else if(itt.eq.LOOKUP) then
                idc=mod(entstat(ient,indcd),MXDICTS)
                form='('//fstr(ient,indcd)//')'
                read(mess,form) ilkup
                lmess=0
                if(idc.eq.DICTFT) then
                  lfmt=locfmc(ilkup)
                  mess(lmess+1:lmess+lfkndscr(lfmt))=fkndscr(lfmt)
                  lmess=lmess+lfkndscr(lfmt)
                else if(idc.eq.DICTUT) then
                  if(ilkup.eq.0) then
                    mess(lmess+1:lmess+8)='No units'
                    lmess=lmess+8
                  else
                    lunt=locunc(ilkup)
                    io=iknowu(lunt)-1
                    call getstr(uknown,io,mess(lmess+1:200),ladd)
                    lmess=lmess+ladd
                  endif
                else 
                  if(idc.eq.DICTGC) then
                    if(.not.getabr(itabr(idc),ilkup,str,lstr))
     1                  stop 'wrtblk: dictionary entry not found'
                    io=10
                    call getstr(str,io,mess(lmess+1:200),ladd)
                    lmess=lmess+ladd
                  else if(idc.eq.DICTCT) then
                    if(.not.getabr(itabr(idc),ilkup,str,lstr))
     1                  stop 'wrtblk: dictionary entry not found'
                    io=7
                    mess(lmess+1:lmess+1)=str(io+1:io+1)
                    lmess=lmess+1
                    io=io+1
                    mess(lmess+1:lmess+1)=':'
                    lmess=lmess+1
                    call getstr(str,io,mess(lmess+1:200),ladd)
                    lmess=lmess+ladd
                    mess(lmess+1:lmess+2)=' ('
                    lmess=lmess+2
                    read(str(io+1:io+3),'(i3)') ilkup
                    write(6,*) 'wrblk: ilkup=',ilkup
                    if(ilkup.eq.0) then
                      mess(lmess+1:lmess+8)='No units'
                      lmess=lmess+8
                    else
                      lunt=locunc(ilkup)
                      write(6,*) 'wrtblk: lunt=',lunt
                      io=iknowu(lunt)-1
                      call getstr(uknown,io,mess(lmess+1:200),ladd)
                      lmess=lmess+ladd
                    endif
                    mess(lmess+1:lmess+1)=')'
                    lmess=lmess+1
                  else
                    stop 'wrtblkt: Dictonary type unsupported for ifunab=2'
                  endif
                endif
              endif
            else 
              stop 'wrtblk: Unknown ifunab code'
            endif
              
            if(iformat.eq.1) then
            write(lu,*) (tabs(i),i=1,ilev+1)
     1          ,edescr(ient,indcd)(1:ledescr(ient,indcd))
     1          ,' ['//mess(1:lmess)//']'
            else if(iformat.eq.2) then
              if(ifgot.ne.0.and.(
     1                  (lsee+lmess+2.gt.80) 
     1          .or.    (MXDICTS*(entstat(ient,indcd)/MXDICTS).eq.ISCOUNT) )
     1                 ) then
                write(lu,*) line(1:lline)
                lline=0
                lsee=0
                ifgot=0
              endif
              if(lline.eq.0) then
                do i=1,ilev+1
                  lline=lline+1
                  line(lline:lline)='\t'
                  lsee=lsee+8
                enddo
              endif
              line(lline+1:lline+lmess+2)='['//mess(1:lmess)//']'
              lline=lline+lmess+2
              lsee=lsee+lmess+2
              if(MXDICTS*(entstat(ient,indcd)/MXDICTS).eq.ISCOUNT) then
                lsee1=(lsee/8+1)*8
                if(lsee1.eq.8*(ilev+2)) then
                  lline=lline+1
                  line(lline:lline)='\t'
                  lsee=lsee1
                endif
              endif
              ifgot=1
            endif
          endif

        enddo
        if(iformat.eq.1) then
          write(lu,*) '}'
        else if(iformat.eq.2) then
          lline=lline+1
          lsee=lsee+1
          line(lline:lline)='}'
          write(lu,*) line(1:lline)
          lline=0
          lsee=0
          ifgot=0
  
        endif
     
      else if(iformat.eq.3) then
        call getfield(cod,itp,cbuf,k,indcd,ient,ilev,mess,lmess,icdstat)
        iflush=0
        if(icdstat.eq.IUNSPT) then
          stop 'wrtblk: code unsupported'
c         return
        else if(icdstat.eq.IGNORE) then
          write(0,'(3a)') 'Code:',cod,' ignored'
          return
        else if(icdstat.eq.IREFCD) then
          iflush=1
        else if(icdstat.eq.INTRPC) then
          continue
        else
          stop 'wrtblk: unknown code status'
        endif
        call putblockb(cod,inum,cbuf,itp,iflush)
      else if(iformat.eq.80) then
c       replace format and units abbreviations 
c       by standard ones used in seeddefs



c       end of abbreviation replacement
        io=0
        do while(io.lt.inum)
          if(io.eq.0) then
            write(str4,'(i4)') inum+7
            do i=1,4
              if(str4(i:i).eq.' ') str4(i:i)='0'
            enddo
            io1=min0(io+73,inum)
            write(lu,'(3a)') cod,str4,cbuf(io+1:io1)
          else
            io1=min0(io+80,inum)
            write(lu,'(a)') cbuf(io+1:io1)
          endif
          io=io1
        enddo
      endif
      return
      end
