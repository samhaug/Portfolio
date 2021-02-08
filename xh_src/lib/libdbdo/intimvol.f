
c-----------------------------------------------------------------------
      subroutine intimvol(itim1,itim2,itim1vol,itim2vol,ierr)
      dimension itim1(2),itim2(2),itim1vol(2),itim2vol(2)
c      integer*2 j(2)
c      integer*4 k
c      equivalence (j,k)
      ierr=0
      if(itcmp(itim1,itim2).gt.0) then
        write(6,*) 'intimvol: *** Warning *** Time compare error'
        itim2(1)=itim1(1)
        itim2(2)=itim1(2)
      endif
      if(itcmp(itim1,itim2vol).gt.0.or.itcmp(itim2,itim1vol).lt.0) then
        write(6,*) 'intimvol: *** Error *** Times outside volume'
        ierr=1
        return
      endif
      call itextrm(1,itim1,itim1vol,itim1)
      call itextrm(-1,itim2,itim2vol,itim2)
      call itextrm(1,itim1,itim2,itim2)
      it=itcmp(itim1,itim2)
      if(it.eq.0) then
c        k=itim2(2)
c        j(1)=j(1)+1
c        itim2(2)=k
        call inctim(itim2)
      else if(it.gt.0) then
        pause 'intimvol: *** Error *** Unexpected error'
        ierr=2
      endif
      return
      end
