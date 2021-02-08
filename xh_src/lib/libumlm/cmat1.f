      subroutine cmat1(c,mlow,lmode,kmax,work,ifrot,msr,mtr,msi,mti
     1   ,iswitch)
      double precision work(mlow:lmode,mlow:lmode)
      dimension c(1:2,mlow:lmode,mlow:lmode,1:kmax)
      data pi/3.141592653589/
      do 20 iri=1,2
      do 20 mrow=-lmode,lmode
      do 20 mcol=-lmode,lmode
      do 20 k=1,kmax
   20 c(iri,mrow,mcol,k)=0.
      k=0
      if(ifrot.ne.0) then
        k=k+1
        sum=0.
        do 10 m=-lmode,lmode
        sum=sum+float(m*m)
   10   c(1,m,m,k)=float(m)
        sum=sqrt(sum)
        do 101 m=-lmode,lmode
  101   c(1,m,m,k)=c(1,m,m,k)/sum
      endif
      kalen=0
      do 55 is=0,2*lmode,2
      if(is.gt.msr) goto 55
      do 56 it=0,is
      if(it.gt.mtr) goto 56
      kalen=1+kalen
      if(it.ne.0) kalen=1+kalen
   56 continue
   55 continue
      ka=k
      kb=ka+kalen
      do 100 is=0,2*lmode,2
      isarg=is
      call wig2(lmode,isarg,lmode,work(-lmode,-lmode),2*lmode+1)
      fls=float(2*lmode+1)*sqrt(float(2*is+1)/(4.*pi))*work(0,0)
      if(iswitch.eq.1) factr=.5*fls
      if(iswitch.eq.-1) factr=float(2*is+1)/fls
      do 120 mrow=-lmode,lmode
      do 120 mcol=-lmode,lmode
  120 work(mrow,mcol)=work(mrow,mcol)*factr
      sgn=-1.
      do 110 it=0,is
      sgn=-sgn

      fac=1.

      if(it.eq.0) fac=sqrt(2.)
c   it used to be:
c     if(it.eq.0.and.iswitch.eq.1) fac=sqrt(8.)
c     if(it.eq.0.and.iswitch.eq.-1) fac=sqrt(.5)

      if(is.le.msr.and.it.le.mtr) then
      ka=1+ka
      do 151 mcol=-lmode,lmode
      if(iabs(mcol+it).gt.lmode) goto 151
      c(1,mcol+it,mcol,ka)=c(1,mcol+it,mcol,ka)+fac*work(mcol+it,mcol)
  151 continue
      endif
      if(is.le.msi.and.it.le.mti) then
      kb=1+kb
      do 152 mcol=-lmode,lmode
      if(iabs(mcol+it).gt.lmode) goto 152
      c(2,mcol+it,mcol,kb)=c(2,mcol+it,mcol,kb)+fac*work(mcol+it,mcol)
  152 continue
      endif
      if(it.eq.0) goto 110
      if(is.le.msr.and.it.le.mtr) then
      do 161 mcol=-lmode,lmode
      if(iabs(mcol-it).gt.lmode) goto 161
      c(1,mcol-it,mcol,ka)=c(1,mcol-it,mcol,ka)+sgn*work(mcol-it,mcol)
  161 continue
      endif
      if(is.le.msi.and.it.le.mti) then
      do 162 mcol=-lmode,lmode
      if(iabs(mcol-it).gt.lmode) goto 162
      c(2,mcol-it,mcol,kb)=c(2,mcol-it,mcol,kb)+sgn*work(mcol-it,mcol)
  162 continue
      endif
      if(is.le.msr.and.it.le.mtr) then
      ka=1+ka
      do 171 mcol=-lmode,lmode
      if(iabs(mcol+it).gt.lmode) goto 181
      c(2,mcol+it,mcol,ka)=c(2,mcol+it,mcol,ka)-work(mcol+it,mcol)
  181 continue
      if(iabs(mcol-it).gt.lmode) goto 171
      c(2,mcol-it,mcol,ka)=c(2,mcol-it,mcol,ka)+sgn*work(mcol-it,mcol)
  171 continue
      endif
      if(is.le.msi.and.it.le.mti) then
      kb=1+kb
      do 172 mcol=-lmode,lmode
      if(iabs(mcol+it).gt.lmode) goto 182
      c(1,mcol+it,mcol,kb)=c(1,mcol+it,mcol,kb)+work(mcol+it,mcol)
  182 continue
      if(iabs(mcol-it).gt.lmode) goto 172
      c(1,mcol-it,mcol,kb)=c(1,mcol-it,mcol,kb)-sgn*work(mcol-it,mcol)
  172 continue
      endif
  110 continue
  100 continue
      if(kb.ne.kmax) stop 'error 1 in cmat1'
cc    do 99 k=1,kmax
cc    write(6,"(i4,'.')") k
cc    do 99 m=-lmode,lmode
cc    write(6,"(i3,'.',1p10e12.4/(4x,10e12.4))")
cc   1  m,((c(iri,m,mp,k)-(-1)**(m-mp)*c(iri,-mp,-m,k)
cc   1 ,iri=1,2),mp=-lmode,lmode)
cc 99 continue
      return
      end
