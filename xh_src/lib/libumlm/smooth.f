      subroutine smooth(grid,igrid,ikla,iklo,rnsm,work)
      dimension grid(igrid,1),work(1)
      factor=2./rnsm
      ispan=rnsm/2.
      do 20 ilo=1,iklo
      do 10 ila=1,ikla
   10 work(ila)=grid(ila,ilo)
      do 30 ila=1,ikla
      ila1=max0(1,ila-ispan)
      ila2=min0(ikla,ila+ispan)
      sumn=0.
      sumd=0.
      do 40 ip=ila1,ila2
      fac=1.-float(iabs(ip-ila))*factor
      sumn=sumn+fac*work(ip)
      sumd=sumd+fac
   40 continue
   30 grid(ila,ilo)=sumn/sumd
   20 continue
      return
      end
