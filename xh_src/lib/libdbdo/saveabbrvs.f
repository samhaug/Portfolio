c---------------------------------------------------------------------
      subroutine saveabbrvs(ierr)
      include 'seeddefs.h'
      include 'seedcommun.h'
      include 'seedtrees.h'
      character*3 cod
      ierr=0
      if(kstr.eq.0) return

c first check that all units are known
      idc=DICTUT
      do i=1,MXABRS
        if(kabbr(i,idc).ne.0) then
          i1=kabbr(i,idc)
          i2=i1+labbr(i,idc)-1
          lunt=0
          io=i1+10
          do ii=1,nknowu
            if(astrings(io:i2).eq.uknown(iknowu(ii):iknowu(ii+1)-1))  then
              if(lunt.eq.0) then
                lunt=locukn(ii)
              else
                pause 'saveabbrvs: duplicate known unit'
              endif
            endif
          enddo
          if(lunt.eq.0) then
            write(6,*) 'saveabbrvs: *** Unknown unit ***',i1,i2,astrings(i1:i2)
            call wrtblk(6,astrings(i1:i1+2),STPA,astrings(i1+7:i2),1,0)
            ierr=9
          endif
        endif
      enddo

c now check that all formats are known
      idc=DICTFT
      do i=1,MXABRS
        if(kabbr(i,idc).ne.0) then
          i1=kabbr(i,idc)
          i2=i1+labbr(i,idc)-1
          lfmt=0
          io=i1+7
          do while(astrings(io:io).ne.'~')
            io=io+1
          enddo
          io=io+4
          do ii=1,nknown
            if(astrings(io+1:i2).eq.fknown(iknow(ii):iknow(ii+1)-1))  then
              if(lfmt.eq.0) then
                lfmt=locfkn(ii)
              else
                pause 'saveabrvs: duplicate known format'
              endif
            endif
          enddo
          if(lfmt.eq.0) then
            write(6,*) '*** Unknown format ***'
            call wrtblk(6,astrings(i1:i1+2),STPA,astrings(i1+7:i2),1,0)
            ierr=9
          endif
        endif
      enddo

      if(ierr.ne.0) return

c ok to go ahead
      
      do idc=1,numdicts
        do i=1,MXABRS
          if(kabbr(i,idc).ne.0.and.kabbrmap(i,idc).eq.0) then
            i1=kabbr(i,idc)
            i2=i1+labbr(i,idc)-1
            read(astrings(i1:i2),"(a3,i4)") cod,inum
            call stdize(astrings(i1:i2),STPA,astrings(i1:i2),lblock)
            labbr(i,idc)=lblock
            call setabrn(itabr(idc),itabrh(idc),lsabr(idc)
     1         ,ikey,astrings(i1:i1+lblock-1),tmpblk,ifound)
            kabbrmap(i,idc)=ikey
c            write(6,*) 'saveabbrvs:',astrings(i1:i2),'->',ikey
          endif
        enddo
      enddo
      return
      end
