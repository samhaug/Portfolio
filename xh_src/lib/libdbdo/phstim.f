c---------------------------------------------------------------
      subroutine phstim(gtime,flat,flon,ievt,time,ltime,istat)
      character*(*) gtime,time
      include '../libdb/dblib.h'
      include 'phstable.h'
      dimension itim(2),prm(3)
      istat=0
      ic=ichar(gtime(1:1))
      lgtime=istlen(gtime)-1      ! omit the required tilde

      if(ic.lt.z'30'.or.ic.gt.z'39') then
        ip=1
        do while(gtime(ip:ip).ne.'+'.and.gtime(ip:ip).ne.'-'
     1      .and.ip.le.lgtime)
          ip=ip+1
        enddo
        if(ievt.lt.1.or.ievt.gt.nevt) then
          write(6,'(a)') 'phstim: event out of range'
          istat=9
          return
        endif
        if(ip.lt.lgtime) then
         read(gtime(ip:lgtime),*) tinc
        else
         tinc=0.
        endif

        iph=0
        if(gtime(1:ip-1).ne.'o'.and.gtime(1:ip-1).ne.'O') then
          do i=1,nphase
            if(gtime(1:ip-1).eq.phasenm(i)) iph=i
          enddo
          if(iph.eq.0) then
            write(6,'(a)') 'phstim: phase not found'
            istat=9
            return
          endif
        endif

        call delaz(xlatevs(ievt),xlonevs(ievt),flat,flon,delta,azep,azst)
c       write(6,'(''Testing delta:'',3f10.3)') phsdel1,phsdel2,delta
        if(delta.lt.phsdel1.or.delta.gt.phsdel2) then
          istat=1
          return
        endif

        if(iph.ne.0) then
          tt=tinc+evlphs(delta,xdepevs(ievt)
     1      ,rbig(iphaddr(iph)),ibig(iphaddr(iph)),istat,prm)
        else
          tt=tinc
        endif
        call itimadd(itimevs(1,ievt),itim,dble(tt))
        call timeint(itim,time,ltime)

      else
        time=gtime
        ip=1
        do while(gtime(ip:ip).ne.'~')
          ip=ip+1
        enddo
        ltime=ip+1
      endif
      return
      end


