      subroutine evpclm(vn,rr,coefs)
      dimension coefs(1)
      real lcon,ncon
      common/lmmdl/lmaxm,lmaxm1,leny,npmm,pertm(588),bmdl(588)
      common/modl1/n,nic,noc,moho,nsl,ifanis,r(222)
     1            ,rho(222),qrho(3,222),g(222),ell(222),eta(222)
      common/modl2/acon(222),qacon(3,222),ccon(222),qccon(3,222)
     1            ,lcon(222),qlcon(3,222),ncon(222),qncon(3,222)
     2            ,fcon(222),qfcon(3,222)
      common/modl3/qshear(222),qkappa(222)
      data n670/180/
      rt2=sqrt(2.)
      aa=rsple(1,n,r,acon,qacon,rr)
      rh=rsple(1,n,r,rho,qrho,rr)
      vp=vn*sqrt(aa/rh)/1000.
      x=2.*(rr-r(noc))/(r(n670)-r(noc))-1.
      if(x.lt.-1..or.x.gt.1.) pause 'x out of range in evpclm'
      do 20 is=0,6,2
      ky=is**2
      iy=(is*(is-1))/2
      do 20 im=0,2*is
      fac=1.
      if(im.eq.0) fac=rt2
      ky=1+ky
      iy=1+iy
      coefs(iy)=0.
      do 30 ic=1,5
      ind=(ic-1)*leny+ky
      ip=ic-1
   30 coefs(iy)=coefs(iy)+fac*pertm(ind)*pn(ip,x)/vp
   20 continue
      if(iy.ne.28.or.ky.ne.49) then
      write(6,'(''iy='',i4,''   ky='',i4)') iy,ky
      pause
      endif
      return
      end
