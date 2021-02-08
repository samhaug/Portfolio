      subroutine smoothr(grid,igrid,ikla,iklo,rnsm,work)
      dimension grid(igrid,1),work(1)
      factor=2./rnsm
      ispan=rnsm/2.
      do 20 ila=1,ikla
      do 10 ilo=1,iklo
   10 work(ilo)=grid(ila,ilo)
      do 30 ilo=1,iklo
      ilo1=max0(1,ilo-ispan)
      ilo2=min0(iklo,ilo+ispan)
      sumn=0.
      sumd=0.
      do 40 ip=ilo1,ilo2
      fac=1.-float(iabs(ip-ilo))*factor
      sumn=sumn+fac*work(ip)
      sumd=sumd+fac
   40 continue
   30 grid(ila,ilo)=sumn/sumd
   20 continue
      return
      end
