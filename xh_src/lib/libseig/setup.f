c----------------------------------------------------------------------
      subroutine setup
      save
c   this subroutine calculates the record numbers of
c   records containing data for fundamental modes (spheroidal
c   and toroidal, separately) and number of overtones
c   (including fundamental) for each s(l) and t(l).
c   lu1 is the logical unit number of input tape (john's
c   tape with eigenfunctions stored on big0 in a file
c   eig1066b.bin/200).
c
      common/dddu/ltot,mmax,nr,nslr,ninf,recd(222)
      common/tape/ r(222),indsfr(330),indtor(300)
     1    ,kntsfr(330),knttor(300),knts,kntt,lu1,nbytes,lmaxs,lmaxt
     2            ,numbs,numbt
      common/modl1/n,nic,noc,moho,nsl,ifanis,rmod(222)
     1            ,rho(222),qrho(3,222),g(222),ell(222),eta(222)
      integer*2 iaddr,izero
      common novert(700),iaddr(700)
      equivalence (iaddr4,iaddr(1))
      izero=0
cc    rewind lu1
cc    read(lu1) ltot,mmax,nr,nslr,ninf,(r(i),i=1,n)
      call bffi(lu1,1,ltot,(222+5)*4,jstat,nread,1)
      do i=1,n
      r(i)=recd(i)
      enddo

      nbytes=2*ninf
      nfir=1
      nlas=min0(ninf,ltot)
cc 10 read(lu1) (iaddr(i),i=nfir,nlas)
   10 call bffi(lu1,1,iaddr4,(nlas-nfir+1)*2,jstat,nread,0)
      nfir=1+nlas
      nlas=min0(nlas+ninf,ltot)
      if(nfir.le.ltot) goto 10
      knts=0
      lmaxs=-1
      numbs=0
      do 1 i=1,ltot
      if(i.lt.ltot) i1=iaddr(i+1)
      if(i.eq.ltot) i1=iaddr(i)
      if(i.eq.ltot) i1=iabs(i1)+1
      i2=iaddr(i)
      novert(i)=iabs(i1)-iabs(i2)
      if(iaddr(i).lt.izero) go to 1
      knts=knts+1
      lmaxs=1+lmaxs
      numbs=numbs+novert(i)
      indsfr(knts)=iaddr(i)
      kntsfr(knts)=novert(i)
    1 continue
      kntt=0
      lmaxt=0
      numbt=0
      do 2 i=1,ltot
      if(iaddr(i).gt.izero) go to 2
      kntt=kntt+1
      lmaxt=1+lmaxt
      indtor(kntt)=-iaddr(i)
      knttor(kntt)=novert(i)
      numbt=numbt+novert(i)
    2 continue
      return
      end
