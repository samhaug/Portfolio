c---------------------------------------------------------------

      subroutine mopnflc(ifl,name,iap,ifile,irec,istat,lrec,inewi)
      character*(*) name


      include 'mopenfile.h'


      character*80 str80

      data mopnfls,mopnact,knt/0,0,0/
      str80=name
      ifl=0
      do i=1,mopnfls
        if(moplus(i).ne.0) then
          if(str80.eq.mopnames(i)) then
            ifl=i
            goto 121
          endif
        endif
      enddo
  121 continue
      if(ifl.eq.0) then
        do i=1,mopnfls
          if(moplus(i).eq.0) then
            ifl=i
            mopnames(ifl)=str80
            moplus(ifl)=-1
            goto 122
          endif
        enddo
      endif
  122 continue
      if(ifl.eq.0) then
        mopnfls=mopnfls+1
        if(mopnfls.gt.MXFILS) stop 'mopnflc: too many files'
        ifl=mopnfls
        mopnames(ifl)=str80
        moplus(ifl)=-1
      endif
      mopiap(ifl)=iap
      moplrec(ifl)=lrec
      mopinew(ifl)=inewi
      if(moplus(ifl).lt.0) call mreopen(ifl,lu,istat)
      mopknt=mopknt+1
      mopknts(lu)=mopknt
      return
      end
