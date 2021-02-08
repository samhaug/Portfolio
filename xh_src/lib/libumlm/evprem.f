      subroutine evprem(rx,xaaa,xccc,xlll,xnnn,xfff,xrho,vno,rhobaro,iq)
      include 'modl.h'
      common/modl5/rn,wn,vn,gn,rhobar
      if(n.le.0) then
        open(1,file='/home/eeyore1/john/dta/foanis05.222',form='formatted')
        call modl(1,0,rn,wn,vn,gn,rhobar)
        close(1)
      endif
      ir1=n
      ir=n-1
      rr=rx/rn
  132 if(r(ir).le.rr.and.r(ir1).gt.rr) goto 131
      ir=ir-1
      ir1=ir1-1
      if(ir.lt.1) ir=n-1
      if(ir1.lt.2) r1=n
      goto 132
  131 continue
      t=rr-r(ir)
      xaaa=acon(ir)+t*(qacon(1,ir)+t*(qacon(2,ir)+t*qacon(3,ir)))
      xccc=ccon(ir)+t*(qccon(1,ir)+t*(qccon(2,ir)+t*qccon(3,ir)))
      xlll=lcon(ir)+t*(qlcon(1,ir)+t*(qlcon(2,ir)+t*qlcon(3,ir)))
      xnnn=ncon(ir)+t*(qncon(1,ir)+t*(qncon(2,ir)+t*qncon(3,ir)))
      xfff=fcon(ir)+t*(qfcon(1,ir)+t*(qfcon(2,ir)+t*qfcon(3,ir)))
      xrho= rho(ir)+t*( qrho(1,ir)+t*( qrho(2,ir)+t* qrho(3,ir)))
      vno=vn
      rhobaro=rhobar
      iq=ir1
      return
      end
