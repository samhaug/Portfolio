

c----------------------------------------------------------------------
      subroutine setkr(lump,luper)
      save
      common/setker/mtot,lnts,lntt,rmp(48),indsfr(330),kntsfr(330)
     1   ,indtor(300),knttor(300),nbatch,lump1,luper1,nparm

      luper1=luper
      lump1=lump
      call bffi(lump1,1,mtot,(3+48)*4,j,m,1)
c     write(6,11) m
c  11 format(1x,i10,' bytes read')
      call bffi(lump1,1,indsfr,660*4,j,m,2)
c     write(6,11) m
      call bffi(lump1,1,indtor,600*4,j,m,3)
c     write(6,11) m
c     write(6,12) indtor
c  12 format(14i5)
      nbatch=(mtot+255)/256
c     write(6,1) nbatch,mtot
c   1 format(' from setkr: nbatch,mtot',2i10)
      return
      end
