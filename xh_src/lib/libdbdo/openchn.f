
c----------------------------------------------------------

      subroutine openchn(locid,chn,krate,lfmt,isub,iflap)
      character*3 chn
      character*2 locid
      character*16 ckey
      integer*4 key(4)
      integer*2 jkey(8)
      equivalence (key,ckey,jkey)

      ckey(1:8)=locid//chn//'   '
      key(3)=krate
      jkey(7)=lfmt
      jkey(8)=isub
      call byswap4(key(3),1)
      call byswap2(jkey(7),2)

      call openchnk(ckey,iflap)
      return
      end
