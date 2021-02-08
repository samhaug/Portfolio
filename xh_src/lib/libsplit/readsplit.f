c -------------------------------------------------------------------
      subroutine readsplit(fnm,mdtp,nord,lord,lmax,x,xerr)

      dimension x(*),xerr(*)
      character*80 fnm
      character*80 dnm
      character*1 mdtp

c    take directory out of model name
      lm=istlen(fnm)
      write(6,*) 'readsplit: lm= ', lm
      ip1=lm
      do while(ip1.gt.0.and.fnm(ip1:ip1).ne.'/')
        write(6,*) 'readsplit: i= ',ip1,' char= ',fnm(ip1:ip1)
        ip1=ip1-1
      enddo
      dnm=fnm(ip1+1:lm-3)
      lo=istlen(dnm)

      write(6,*) 'readsplit: ip1= ', ip1
      write(6,*) 'readsplit: lm= ', lm
      write(6,*) 'readsplit: dnm= ', dnm
      write(6,*) 'readsplit: lo= ', lo
      write(6,*) 'readsplit: string= ', dnm
      write(6,*) 'readsplit: n= ',dnm(1:2),' tp= ',dnm(3:3),' lord= ',dnm(4:5)
      read(dnm(1:2),'(i2)') nord
      read(dnm(3:3),'(a1)') mdtp
      read(dnm(4:5),'(i2)') lord
c-- jeroen

      open(14,file=fnm,status='old')
      read(14,*) lmax
      numatd=(lmax+1)**2
      read(14,'(5e16.8)') (x(i),i=1,numatd)
      close(14)

      lf=istlen(fnm)

      open(14,file=fnm(1:lf)//'.err',status='old')
      read(14,*) lmaxerr
      if(lmaxerr.ne.lmax)  then
        write(6,*) 'in readsplit fnm= ', fnm
        stop 'readsplit: lmaxerr.ne.lmax'
      endif
      read(14,'(5e16.8)') (xerr(i),i=1,numatd)
      close(14)


      end

c -----------------------------------------------------------------------
