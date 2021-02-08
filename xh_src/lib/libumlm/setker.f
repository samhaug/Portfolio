      subroutine setker(lump,luper)
      common/setkr/mtot,lnts,lntt,rmp(48),indsfr(330),kntsfr(330)
     1   ,indtor(300),knttor(300),nbatch,lump1,luper1

      luper1=luper
      lump1=lump
      call bffi(lump1,1,mtot,(3+48)*4,j,m,1)
      call bffi(lump1,1,indsfr,660*4,j,m,2)
      call bffi(lump1,1,indtor,600*4,j,m,3)
      nbatch=(mtot+255)/256
      return
      end
