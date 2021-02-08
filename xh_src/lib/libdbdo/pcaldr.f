c--------------------------------------------------------------------
      subroutine pcaldr(patt,lpatt,tim1,tim2,irank,tp,ltp,ierr)
      character*32 patt(*)
      character*(*) tp,tim1,tim2
      dimension lpatt(*)
      dimension itim1(2),itim2(2),key(2)
      include 'seeddefs.h'
      include 'seedtrees.h'

      character*5 stnopnd
      character*9 chnopnd
      character*24 timelo,timehi,timelor,timehir
      common/dbdocm/inetopnd,stnopnd,chnopnd,timelo,timehi,timelor,timehir

      integer SIADR,SCADR,CIADR,CCADR,CRADR,CTADR,NMADR
      parameter (SIADR=1,SCADR=2,CIADR=3,CCADR=4,CRADR=5,CTADR=6,NMADR=6)

      character*1 c

      call inttime(tim1,itim1)
      call inttime(tim2,itim2)


      do it=1,NMADR
        if(lpatt(it).gt.0) then
          if(stnopnd.eq.' '.or.inetopnd.eq.0) then
            write(6,*) 'No station selected'
            ierr=9
            return
          else
            call openstn(stnopnd,inetopnd,4)
          endif
          if(it.eq.CIADR.or.it.eq.CCADR.or.it.eq.CRADR.or.it.eq.CTADR) then

            if(chnopnd.eq.' ') then
              write(6,*) 'No channel selected'
              ierr=9
              return
            else
              call openchn(chnopnd(1:2),chnopnd(3:5),chnopnd(6:9),4)
            endif
          endif
          mode=1
          k1=0
          do i=1,lpatt(it)
            c=patt(it)(i:i)
            if(c.eq.'(') goto 20
            k1=k1+1
            ic=ichar(c)
            if(ic.lt.z'30'.or.ic.gt.z'39') mode=2
          enddo
   20     continue
          k2=lpatt(it)
          if(patt(it)(k2:k2).eq.')') k2=k2-1
          key(2)=0
          if(k1+2.le.k2) then
            read(patt(it)(k1+2:k2),*) key(2)
          endif
          if(mode.eq.1) then
            read(patt(it)(1:k1),*) key(1)
            if(it.eq.SIADR) then
              call setcldr(itsticl,mssticl,mtsticl,itim1,itim2,key(1),1,irank)
            else if(it.eq.SCADR) then
              call setcldr(itstccl,msstccl,mtstccl,itim1,itim2,key(1),2,irank)
            else if(it.eq.CIADR) then
              call setcldr(itchicl,mschicl,mtchicl,itim1,itim2,key(1),1,irank)
            else if(it.eq.CCADR) then
              call setcldr(itchccl,mschccl,mtchccl,itim1,itim2,key(1),2,irank)
            else if(it.eq.CRADR) then
              call setcldr(itchrcl,mschrcl,mtchrcl,itim1,itim2,key(1),1,irank)
            else if(it.eq.CTADR) then
              call setcldr(itchpcl,mschpcl,mtchpcl,itim1,itim2,key(1),1,irank)
            endif
          else
            call eatseed(patt(it)(1:k1),it,tp(1:ltp),-1,tim1,tim2,ierr)
          endif
        endif
      enddo
      return
      end
