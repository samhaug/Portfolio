c -------------------------------------------------------------------
      subroutine readmoon(nrl,itp,nord,lord,dcor,idcordim,ie3)

      dimension dcor(idcordim)
      character*80 filenm
      character*3 lcd
      character*1 ncd,itpcd

      numatd=(nrl+1)**2

      write(ncd,10) nord
10    format(i1)
      if(itp.eq.1) itpcd='s'
      if(itp.eq.2) itpcd='t'
      if(lord.lt.10) then
       write(lcd,13) lord
13     format('00',i1)
      else if(lord.lt.100) then
       write(lcd,11) lord
11     format('0',i2)
      else
       write(lcd,12) lord
12     format(i3)
      endif

c     this is for crust 5.0
c     filenm= '/home/hendrik/d2/oxf/s2/crust/0'//ncd//itpcd//lcd//'.raw'
c     crust 5.1
c     filenm= '/home/hendrik/d1/crust5.1/grids/0'//ncd//itpcd//lcd//'.raw'
      filenm= '/home/seiraid4/hendrikv/splitting/crust/0'//ncd//itpcd//lcd//'.c51.miaki.raw'
      write(6,*) 'opening',filenm
      open(14,file=filenm,status='old',iostat=ie3)

      if(ie3.eq.0) then
       read(14,*) lmaxhr
       write(6,*) nrl,lmaxhr
       if(nrl.gt.lmaxhr) stop 'STOP; readmoon >>> nrl.gt.lmaxhr'
       read(14,'(5e16.8)') (dcor(i),i=1,numatd)
       close(14)
      else

       write(6,*) 'Mooney crustal correction not found '//ncd//itpcd//lcd

       ierr=0
       do ltmp=lord-2,lord+2
        if(lord.lt.10) then
         write(lcd,13) lord
        else if(ltmp.lt.100) then
         write(lcd,11) ltmp
        else
         write(lcd,12) ltmp
        endif

c       crust5.0
c       filenm= '/home/hendrik/d2/oxf/s2/crust/0'//ncd//itpcd//lcd//'.raw'
c       crust5.1
c       filenm= '/home/hendrik/d1/crust5.1/grids/0'//ncd//itpcd//lcd//'.raw'
        filenm= '/home/seiraid4/hendrikv/splitting/crust/0'//ncd//itpcd//lcd//'.c51.miaki.raw'

        open(14,file=filenm,status='old',iostat=ie3)
        if(ie3.eq.0) then
         read(14,'(i3)') lmaxhr
         if(nrl.gt.lmaxhr) stop 'STOP; readmoon >>> nrl.gt.lmaxhr'
         read(14,'(5e16.8)') (dcor(i),i=1,numatd)
         close(14)
         lf=istlen(filenm)
c        write(6,*) filenm(1:lf),' USED AS CORRECTION' 
         ierr=999
        endif
       enddo
      endif

      if(ierr.eq.999) ie3=0

      end

c -----------------------------------------------------------------------
