      subroutine getavetopo(itop,pnts,nrp,avsol,avwat,dg)

c     for etopo5
      parameter(NLA=2160)
      parameter(NLO=4320)
      integer*2 itop(NLO,NLA)

c     for cgrc
      dimension pnts(2,*)

      nsolav=0
      nwatav=0
      do i=1,nrp
       call getilalo(pnts(2,i),pnts(1,i),ila,ilo,dg)
       nsol=itop(ilo,ila)
       nwat=(nsol+abs(nsol))*.5
       nsolav=nsolav+nsol
       nwatav=nwatav+nwat
      enddo

      avwat=.001*(real(nwatav)/real(nrp))
      avsol=.001*(real(nsolav)/real(nrp)+3000)
 

      end

c -----------------------------------------------------------------
      subroutine getilalo(rla,rlo,ila,ilo,dg)

      parameter(NLA=2160)
      parameter(NLO=4320)

      duma=rla
      dumo=rlo
      if(dumo.lt.0) dumo=dumo+360
      
      ila=int((rla+90)/dg)+1
      ila=NLA-ila+1
      ilo=int((dumo)/dg)+1

      if(ila.gt.NLA.or.ilo.gt.NLO) stop 'programmeren!'

      end


