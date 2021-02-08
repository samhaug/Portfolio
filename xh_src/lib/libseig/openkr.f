

c----------------------------------------------------------------------
      subroutine openkr(modes,kernels,kerhed)
      save
      parameter (MAXKER=34)
      character*(*) modes,kernels
      common/setker/mtot,lnts,lntt,rmp(48),indsfr(330),kntsfr(330)
     1   ,indtor(300),knttor(300),nbatch,lump,luper,nparm
      common/descs/iarray(10,MAXKER)
      lump=-1
      write(6,'(a,a)') 'openkr: opening ',modes
      call openfl(lump,modes,1,0,0,istat,4096)
      write(6,'(a,a)') 'openkr: B1'
      luper=-1
      if(kernels.ne.' ') then
      write(6,'(a,a)') 'openkr: B2'
        call openfl(luper,kernels,1,0,0,istat,-1)
      write(6,'(a,a)') 'openkr: B3 kerhed= ', kerhed
        if(kerhed.eq.0) then
          nparm=10
        else if(kerhed.eq.1) then
          call bffi(luper,1,nparm,4,j,m,0)
          call byswap4(nparm,1)
          call bffi(luper,1,iarray,40*nparm,j,m,5)
          call closfl(luper,j)
        endif
        luper=-1
        call openfl(luper,kernels,1,0,0,istat,1024*nparm)
      endif

      call bffi(lump,1,mtot,(3+48)*4,j,m,1)
      call byswap4(mtot,(3+48))
      call bffi(lump,1,indsfr,660*4,j,m,2)
      call byswap4(indsfr,660)
      call bffi(lump,1,indtor,600*4,j,m,3)
      call byswap4(indtor,600)
      nbatch=(mtot+255)/256
      if(luper.gt.0.and.kerhed.eq.1)
     1     write(6,'(i4,''.'',1x,10a4)') (i,(iarray(j,i),j=1,10),i=1,nparm)
      return
      end
