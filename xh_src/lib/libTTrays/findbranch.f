      subroutine findbranch(hdep,delta,phin,mod,brfnd,nfnd)

      parameter(MXNRBR=7)
      character*2 branch(MXNRBR)
      data branch/'ab','bc','cd','df','ac','4a','4b'/
      
      character*(*) phin,mod
      character*(*) brfnd(*)
      character*40 phstst
      character*120 ifl

      lphin=istlen(phin)
      lmd=istlen(mod)

      ibr=0
      do i=1,MXNRBR
       phstst=phin(1:lphin)//branch(i)
       lphtst=lphin+2
       
c      check whether phase file exists
       ifl='//geo/home/jritsema/Utils/phstimes/'//phstst(1:lphtst)//'.phs.'//mod(1:lmd)
       open(521,file=ifl,form='unformatted',status='old',err=10)

       iex=1
       goto 11

10     continue
       iex=0

11     continue
       
       if(iex.eq.1) then
        call readphs(mod,lmd,phstst,lphtst,hdepmx)
        call getphsmnmx(hdep,delmn,delmx)

        if(delta.gt.delmn.and.delta.lt.delmx) then
         ibr=ibr+1
         brfnd(ibr)=branch(i)
        endif

       endif

      enddo

      nfnd=ibr

      end




