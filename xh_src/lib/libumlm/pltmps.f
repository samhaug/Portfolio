      subroutine pltmps(iu,urot,ifplb,it1,it2,jt1,jt2
     1   ,x1,x2,y1,y2,iwork,nwork,ifshd,ispac)
      dimension urot(3,3)
      integer*2 icor(2,500)
      dimension ibuff(501)
      dimension iwork(nwork)
      equivalence (ibuff(1),m),(ibuff(2),icor(1,1))
      call twindo(it1,it2,jt1,jt2)
      call dwindo(x1,x2,y1,y2)
      call rewfl(iu)
      nvrt=(jt2-jt1)/ispac
      nvrt2=2+nvrt
      nhor=(it2-it1)/ispac
      nhor1=nhor+1
      fcx=float(it2-it1)/((x2-x1)*float(ispac))
      fcy=float(jt2-jt1)/((y2-y1)*float(ispac))
      icheck=1
      if(ifshd.eq.0) icheck=0
      nume=0
      irec=0
  100 call bffin(iu,1,ibuff,501,j,mk)
      if(j.eq.3) go to 99
      if(m.eq.0.and.ifplb.eq.0) goto 99
      if(m.eq.0) icheck=0
      np=m/2
      x=float(icor(2,1))/10.
      y=float(icor(1,1))/10.
      call rotll(y,x,y,x,urot)
      if(x.lt.0.)x=x+360.
      call movea(x,y)
      xs=x
      ys=y
      x0=x
      do 1 i=2,np
      x=float(icor(2,i))/10.
      y=float(icor(1,i))/10.
      call rotll(y,x,y,x,urot)
      if(x.lt.0.)x=x+360.
      dif=x-xs
      if(abs(dif).lt.350.)go to 133
      if(dif.lt.0.)vx=360.
      if(dif.gt.0.)vx=0.
      xf=amod(xs+180.,360.)-180.
      xt=amod(x+180.,360.)-180.
      ycc=(ys*xt-xf*y)/(xt-xf)
      call drawa(vx,ycc)
      xn=vx
      yn=ycc
      iret=1
      if(icheck.ne.0) goto 1000
 1001 xs=xn
      ys=yn
      vx=360.-vx
      call movea(vx,ycc)
      xs=vx
      ys=ycc
c
      if(ycc.lt.y1.or.ycc.gt.y2) goto 133
      if(icheck.eq.0) goto 133
      nume=1+nume
      if(nume.gt.nwork) stop ' insufficient work space in pltmps'
      iwork(nume)=(ycc-y1)*fcy
  133 call drawa(x,y)
      xn=x
      yn=y
      iret=2
      if(icheck.ne.0) goto 1000
 1002 xs=xn
      ys=yn
      goto 1
c
 1000 int0=(ys-y1)*fcy
      int1=(yn-y1)*fcy
      inmin=1+min0(int0,int1)
      inmax=max0(int0,int1)
      if(inmin.gt.inmax) goto 89
      do 88 int=inmin,inmax
      if(int.lt.1.or.int.gt.nvrt) goto 88
      yc=float(int)/fcy+y1
      xc=xs+(yc-ys)*(xn-xs)/(yn-ys)
      ixc=(xc-x1)*fcx
      nume=1+nume
      if(nume.gt.nwork) stop ' insufficient work space in pltmps'
      iwork(nume)=nvrt2+nhor1*int+ixc
   88 continue
   89 continue
      goto (1001,1002),iret
    1 continue
c
      call tsend
      go to 100
  99  call anmode
c
 2000 if(ifshd.eq.0) goto 299
      nume=1+nume
      if(nume.gt.nwork) stop ' insufficient work space in pltmps'
      iwork(nume)=(nhor+2)*nvrt2
      nume1=1+nume
      nume2=2*nume
      if(nume2.gt.nwork) stop 'insufficient space for index in pltmps'
      call isoinc(iwork,nume,iwork(nume1))
c
      write(6,55)
   55 format(' is lower left corner shaded?')
      read(5,56) iswits
   56 format(i1)
      ip1=1
      ip2=1
      ihor=nhor
      ivrt=0
c
  209 ihor=1+ihor
      if(ihor.le.nhor) goto 203
      ihor=1
      ivrt=1+ivrt
      iswit=iswits
      if(ivrt.gt.nvrt) goto 299
  181 ivtp=(iwork(ip2)-nvrt2)/nhor1
      if(ivtp.ge.ivrt) goto 182
      ip2=1+ip2
      goto 181
  182 ihzp=mod(iwork(ip2)-nvrt2,nhor1)
  208 if(ivrt.le.iwork(ip1)) goto 211
      iswit=1-iswit
      ip1=1+ip1
      goto 208
  211 iswits=iswit
c
  203 continue
  205 if((ivrt.eq.ivtp.and.ihor.le.ihzp).or.(ivrt.lt.ivtp)) goto 204
      iswit=1-iswit
      ip2=1+ip2
      ivtp=(iwork(ip2)-nvrt2)/nhor1
      ihzp=mod(iwork(ip2)-nvrt2,nhor1)
      goto 205
c
  204 if(iswit.ne.0) call pntabs(it1+ispac*ihor,jt1+ispac*ivrt)
      call tsend
      goto 209
c
  299 return
      end
