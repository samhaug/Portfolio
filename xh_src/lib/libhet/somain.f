      subroutine somain
      save
      common/intap/ jstat,itype,icomp,idum(13)
      common/iap5/ synt(12850)
      common/inter/ knt,xj,zz1,zz2
      if(jstat.lt.0) then
        call fvclr(synt,1,5140)
        if(jstat.lt.-1) return
        jstat=0
        knt=0
        xj=-1.
      endif
      if(itype.eq.2) then
        call sotors
      else
        call sosfrs
      endif
      return
      end
