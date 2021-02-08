c-----------------------------------------------------------------
      subroutine jsegs(x,y,inc,nseg,arect,ifinbl
     1 ,ind,nind,nout,work,nwork)
      logical endsleft
      dimension ind(nind),work(nwork),arect(2,2)
      dimension x(inc,2,nseg),y(inc,2,nseg)
      data twopi/6.283185307/

c     ifinbl =  0; lower left corner is an exterior point
c     ifinbl =  1; lower left corner is an interior point
c     ifinbl = -1; segments are oriented so that interior is on the right
c     ifinbl = -2; segments are oriented so that interior is on the left.

      if(nwork.lt.(nseg*2+4)*2) stop 'increase work space in jsegs'
      xmid=.5*(arect(1,1)+arect(1,2))
      ymid=.5*(arect(2,1)+arect(2,2))
      endsleft=.true.

      k=0
      do 20 ibe=1,2
      do 10 i=1,nseg
      k=k+1
      ind(k)=(2*ibe-3)*i
   10 work(k)=atan2(y(1,ibe,i)-ymid,x(1,ibe,i)-xmid)
      do 20 i=1,2
      k=k+1
      ind(k)=nseg+i+2*(ibe-1)
   20 work(k)=atan2(arect(2,ibe)-ymid,arect(1,i)-xmid)
      n=k

      a0=work(nseg+1)
      do 30 i=1,n
   30 work(i)=amod(work(i)-a0+twopi,twopi)
      work(nseg+1)=0.

      call sortri(work,ind,n,work(n+1))

      ko=n
      i0=0
      ifb=ifinbl
      if(ifb.lt.-2.or.ifb.gt.1) stop 'error 1 in jsegs'

  101 itry=0
  100 i0=1+mod(i0,n)
      itry=1+itry
      if(itry.gt.n) then
        if(endsleft) then
          endsleft=.false.
          itry=0
          goto 100
        else
          goto 99
        endif
      endif
      if(ind(i0).eq.0.or.ind(i0).gt.nseg) goto 100
      if(endsleft.and.((i0.gt.1.and.work(i0).eq.work(i0-1))
     1   .or.(i0.lt.n.and.work(i0).eq.work(i0+1)))) goto 100

      i=i0
      i1=i0+1
      if(i1.gt.n) goto 102
      if(work(i1).ne.work(i0)) goto 102
      iseg0=iabs(ind(i0))
      ibe0=1
      if(ind(i0).gt.0) ibe0=2
      iseg1=iabs(ind(i1))
      ibe1=1
      if(ind(i1).gt.0) ibe1=2
      if(x(1,ibe0,iseg0).ne.x(1,ibe1,iseg1)
     1    .or.y(1,ibe0,iseg0).ne.y(1,ibe1,iseg1)) goto 102
      i=i0
      if(ifinbl.eq.-2) i=i1
      goto 103

  102 if(ifb.eq.-1.and.ind(i0).lt.0) ifb=0
      if(ifb.eq.-2.and.ind(i0).gt.0) ifb=0
      if(ifb.ne.0) then
      ifb=0
      goto 100
      endif

  103 ind0=ind(i)
      ind1=ind0
      itry=0
      ko=1+ko
      if(ko.gt.nind) stop 'increase index space in jsegs'
      ind(ko)=-ind(i)

      j=0
  110 j=1+mod(j,n)
      if(ind(j).ne.-ind1) goto 110
      j1=1+j
      if(j1.gt.n.or.ind(j1).gt.nseg) goto 121

      if(work(j1).ne.work(j)) goto 121
      iseg0=iabs(ind(j))
      ibe0=1
      if(ind(j).gt.0) ibe0=2
      iseg1=iabs(ind(j1))
      ibe1=1
      if(ind(j1).gt.0) ibe1=2

      if(x(1,ibe0,iseg0).ne.x(1,ibe1,iseg1)
     1   .or.y(1,ibe0,iseg0).ne.y(1,ibe1,iseg1)) goto 121
      itemp=ind(j)
      ind(j)=ind(j1)
      ind(j1)=itemp
      temp=work(j)
      work(j)=work(j1)
      work(j1)=temp
      j=j1
  121 ind(j)=0

  120 j=1+mod(j-2+n,n)
      if(ind(j).eq.0) goto 120
      if(ind(j).gt.nseg) then
        ko=1+ko
        if(ko.gt.nind) stop 'increase index space in jsegs'
        ind(ko)=ind(j)
        ind(j)=0
        goto 120
      endif

      j1=j-1
      if(j1.eq.0.or.ind(j1).gt.n.or.ind(j1).eq.0) goto 210
      if(work(j1).ne.work(j)) goto 210
      iseg0=iabs(ind(j))
      ibe0=1
      if(ind(j).gt.0) ibe0=2
      iseg1=iabs(ind(j1))
      ibe1=1
      if(ind(j1).gt.0) ibe1=2
      if(x(1,ibe0,iseg0).ne.x(1,ibe1,iseg1)
     1   .or.y(1,ibe0,iseg0).ne.y(1,ibe1,iseg1)) goto 210
      j=j1
      goto 120

  210 ko=1+ko
      if(ko.gt.nind) stop 'increase index space in jsegs'
      ind(ko)=-ind(j)
      ind1=ind(j)
      ind(j)=0
      if(ind1.eq.ind0) goto 101

      goto 110

   99 nout=ko-n

      if(ifinbl.eq.-2) then
      nswap=nout/2
      nbot=n+1
      ntop=ko
      do 991 i=1,nswap
      itemp=ind(nbot)
      ind(nbot)=ind(ntop)
      ind(ntop)=itemp
      ntop=ntop-1
  991 nbot=nbot+1
      do 992 i=n+1,ko
      if(iabs(ind(i)).le.nseg) ind(i)=-ind(i)
  992 continue
      endif

      do 990 i=1,nout
  990 ind(i)=ind(i+n)
      return
      end

