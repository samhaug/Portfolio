c---------------------------------------------------------------

      subroutine mbffo(ifl,ifbin,ibuf,nbytes,istat,irec)
      dimension ibuf(*)

      include 'mopenfile.h'

      if(irec.le.0) stop 'mbffo: only direct access supported'
      lu=moplus(ifl)
      if(lu.gt.0) then
      else if(lu.eq.0) then
        stop 'mbffo: File not open'
      else
        call mreopen(ifl,lu,istat)
      endif
      if(lu.le.0) stop 'mbffo: lu le 0'
      call bffo(lu,ifbin,ibuf,nbytes,istat,irec)
      mopknt=mopknt+1
      mopknts(lu)=mopknt
      return
      end
