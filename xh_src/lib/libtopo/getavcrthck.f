      subroutine getavcrthck(crthck,pnts,nrp,avth)

c     for crust5.1
      parameter(NLA=36)
      parameter(NLO=72)
      dimension crthck(NLO,NLA)

c     for cgrc
      dimension pnts(2,*)

      avthck=0
      do i=1,nrp
       call getilalocr(pnts(2,i),pnts(1,i),ila,ilo)
       th=crthck(ilo,ila)
       avth=avth+th
      enddo

      avth=avth/float(nrp)

      end

c -----------------------------------------------------------------
      subroutine getilalocr(rla,rlo,ila,ilo)

      parameter(NLA=36)
      parameter(NLO=72)

      duma=rla
      dumo=rlo
      if(dumo.lt.0) dumo=dumo+360

      dg=5.
      
      ila=int((rla+89.99)/dg)+1
      ila=NLA-ila+1
      ilo=int((dumo)/dg)+1
      if(ilo.gt.NLO) ilo=NLO

      end


