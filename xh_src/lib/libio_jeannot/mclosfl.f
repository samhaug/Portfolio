c---------------------------------------------------------------
      subroutine mclosfl(ifl,istat)

      include 'mopenfile.h'

      istat=0
      if(moplus(ifl).gt.0) then
        lmin=moplus(ifl)
        call closfl(moplus(ifl),istat)
        mopifls(lmin)=0
        mopnact=mopnact-1
      endif
      moplus(ifl)=0

      mopiap(ifl)=0
      moplrec(ifl)=0
      mopinew(ifl)=0
      mopnames(ifl)=' '

      return
      end
