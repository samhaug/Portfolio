c------------------------------------
      subroutine head80(ibuf,id,iy,iday,ih,im,sec,ifmt,nchan,
     1irate,ibit,nsamp)
      integer*2 ibuf(10)
      dimension ibcd(28),ibit(8),idiv(8)
      data idiv/128,64,32,16,8,4,2,1/
      k=0
      do 1 i=1,14
      call ilbyte(j,ibuf,i-1)
      k=k+1
      ibcd(k)=j/16
      k=k+1
    1 ibcd(k)=mod(j,16)
      do 2 i=1,28
      if(i.eq.19.or.i.eq.20) go to 2
      if(ibcd(i).eq.12) ibcd(i)=0
    2 continue
      id=100*ibcd(1)+10*ibcd(2)+ibcd(3)
      iy=10*ibcd(4)+ibcd(5)
      iday=100*ibcd(6)+10*ibcd(7)+ibcd(8)
      ih=10*ibcd(9)+ibcd(10)
      im=10*ibcd(11)+ibcd(12)
      sec=10*ibcd(13)+ibcd(14)
      msec=100*ibcd(15)+10*ibcd(16)+ibcd(17)
      sec=sec+float(msec)*.001
      ifmt=ibcd(18)
      nchan=10*ibcd(21)+ibcd(22)
      iexprt=ibcd(23)
      irate=10*ibcd(24)+ibcd(25)
      if(iexprt.ne.5) irate=irate*(10**(5-iexprt))
      nsamp=100*ibcd(26)+10*ibcd(27)+ibcd(28)
      do 3 n=1,8
      call byswap2(ibuf(10),1)
      ibuf4=ibuf(10)
    3 ibit(n)=mod(ibuf4,idiv(n)*2)/idiv(n)
      call byswap2(ibuf(10),1)
      return
      end
