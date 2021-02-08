      subroutine apsour(itaper,ifpstr,iter,nodep,kpar)
      save
      real kerbuf
      integer*4 ihtmdl(3)
      complex eptryg,resp,asrins,sroins,rspida
      common/intap/ jstat,itype,icomp,ifact,jter,neig,npoint
     1   ,jifdep,jnstr,jtrans,j1s,j1f,j2s,j2f,jnpar,jiftwo
      common/ap1/ t0,dt,ommax,delta,caz,saz,eptryg(4),f(6),f2pf3,
     1f2mf3,r0,dom,dtorg,durtn
      complex resp5
      common/iap6/ resp5(257,5)
      common/ap2/ bkern(8740)
      common/iap5/ skern(12850)
      common/bigspa/  kerbuf(8740),resp(257,5),fillb(6366)
      common/ap3/ delt1,factt,facto,ppert(24)
      common/tape/ b(536),comp(514),npar,nsol,pert(24),save(325),
     1fillt(112),nbatch
      common/dblem/ xmd(6),r0d
      common/dblec/ epla,eplon,dep,torg,durt
      dimension it1(2),it2(2),synt(5140),taperd(514)
      common/scan/ nsour,npath,nprec(3,50),nogood(50),ratioi,ratiom
     1  ,ihtmdl,ifanm,lmaxm,leny,nprmm,pertm(588),ifcc,mfil(4),mfilan(4)
      equivalence (b(1),id),(b(2),lcomp),(b(3),inst),(b(4),rate),
     1(b(7),iyear),(b(15),iday),(b(16),idelay),(b(17),nfirst),
     2(b(18),nend),(b(22),iflag),(kerbuf(1),synt(1)),(kerbuf(5141),
     3taperd(1))
      save itaperi
      data it1,it2,domida,domsro/135,205,183,257,0.0001917476
     1   ,0.0007669904/
c
      write(6,'(''apsour 1 - '',2i4)') itaper,ifpstr
      itaperi=itaper
      jstat=-2
      call somain
      zzero=0.
      resp(1,1)=asrins(zzero,0)
      do n=1,5
        do i=1,257
          resp(i,n)=(0.,0.)
        enddo
      enddo
      do i=2,244
        om=float(i-1)*domida
        fact=-1./(om*om)
        resp(i,2)=cmplx(fact,0.)*sroins(om)
        resp(i,3)=cmplx(fact,0.)*asrins(om,1)
      enddo
      i2=it2(itaper)
      i1=it1(itaper)
      do i=2,i2
        om=float(i-1)*domsro
        fact=-1./(om*om)
        resp(i,4)=cmplx(fact,0.)*sroins(om)
        resp(i,5)=cmplx(fact,0.)*asrins(om,1)
      enddo
      do i=2,5
        do j=1,257
          resp5(j,i)=resp(j,i)
        enddo
      enddo
      write(6,'(''apsour 2 - '',2i4)') itaper,ifpstr
      return
c
c
      entry apsynt(itaper,ifpstr,iter,nodep,kpar)
      write(6,'(''apsynt 1 - '',4i4)')ifpstr,iter,nodep,kpar
      write(6,*) 'xmd, r0d:',(xmd(i),i=1,6),r0d
      write(6,*) 'epla,eplon,dep,torg,durt',
     1     epla,eplon,dep,torg,durt
      call rewfl(7)
      nsour=1
      fact=0.
      npar=kpar
      if(iter.lt.0) then
c       write(7) (xmd(i),i=1,6),epla,eplon,dep,torg,durt,fact
c       call rewfl(7)
c       call bffin(7,1,b,13,j,m)
        do i=1,6
          b(i)=xmd(i)
        enddo
        b(7)=epla
        b(8)=eplon
        b(9)=dep
        b(10)=torg
        b(11)=durt
        b(12)=fact
        call rewfl(7)
        call bffout(7,1,nsour,808,j)
        call bffout(7,1,b,12,j)
      endif
      ifact=1
      if(iter.eq.0) ifact=6
      if(iter.gt.0) ifact=9
      jter=iter
      call epcntr(epla,eplon)
      do i=1,6
        if(iter.eq.0) f(i)=0.
        if(iter.ne.0) f(i)=xmd(i)
      enddo
      f2pf3=f(2)+f(3)
      f2mf3=f(2)-f(3)
      r0=r0d
      jifdep=0
      if(nodep.eq.0) jifdep=1
      dtorg=torg
      durtn=durt
      jtrans=8
      do nnn=1,npath
        nrec=nprec(1,nnn)
        irf=nprec(2,nnn)
        do nn=1,nrec
          jrec=irf+nn-1
          call bffi(7,1,b,5604,j,m,jrec)
          if(iflag.lt.0) go to 700
          if(iflag.ne.0.and.iter.ge.0) go to 700
          icomp=lcomp
          jnpar=kpar
          jiftwo=0
          if(rate.gt.20.) jiftwo=1
          dt=rate
          call statn(id,name,inst,stlat,stlong,ilev)
          call angles(stlat,stlong,delta,azep,azst
     1         ,theta,phi,psi,az12)
          cz=cos(azst)
          sz=sin(azst)
          if(lcomp.eq.1) then
            caz=-1.
            saz=0.
          else if(lcomp.eq.2) then
            caz=cz
            saz=sz
          else if(lcomp.eq.3) then
            caz=sz
            saz=-cz
          else if(lcomp.eq.4) then
            caz=-1.
            saz=0.
          else if(lcomp.eq.5) then
            caz=0.
            saz=-1.
          else 
            stop 'apsour: invalid component'
          endif
          do i=1,4
            xm=float(i-1)*(3.1415926536-azep)
            eptryg(i)=cmplx(cos(xm),sin(xm))
          enddo
          if(rate.le.20.) then
            dom=domsro
            ommax=0.1396263
            if(itaperi.eq.2) ommax=0.1963495
            idelay=0
            j2s=nend+10
            if(inst.eq.3) stop 'wrong rate'
            if(inst.eq.2) jnstr=5
            if(inst.ne.2) jnstr=4
          else
            dom=domida
            ommax=0.0465421
            j2s=nend+min0(10,514-nend)
            if(inst.ne.3) then
              if(inst.eq.2) jnstr=3
              if(inst.ne.2) jnstr=2
            else
              resp(1,1)=(0.,0.)
              do i=2,257
                om=float(i-1)*domida
                call idaresp(resp(i,1),iday,iyear+1900,name,om,i)
              enddo
              do i=1,257
                resp5(i,1)=resp(i,1)
              enddo
              jnstr=1
            endif
          endif
          j1s=nfirst-min0(10,nfirst-1)
          j1f=nfirst
          j2f=nend
          npoint=j2s-j1s+1
          i1s=j1s
          t0=rate*float(idelay+i1s-1)
          cot2t=cos(2.*theta)
          s2t=0.5*(1.-cot2t)
          c2t=0.5*(1.+cot2t)
          factt=-3.*sin(delta)*cos(az12)*s2t
          facto=1.-3.*c2t
          delt1=delta
          do i=1,24
            ppert(i)=pert(i)
          enddo
          if(ifpstr.eq.0) call reinit(ppert,kpar)
          neig=4
          if(iter.gt.0) neig=6
          jstat=-1
          itype=1
          iu=3
          if(lcomp.ne.1) iu=4
          call rewfl(iu)
          kstat=0
          do while (kstat.eq.0)
            call bffin(iu,1,kerbuf,8740,j,m)
            do i=1,8740
              bkern(i)=kerbuf(i)
            enddo
            call somain
            kstat=jstat
          enddo
          if(lcomp.ne.1) then
            jstat=0
            itype=2
            neig=2
            if(iter.gt.0) neig=3
            kstat=0
            do while (kstat.eq.0)
              call bffin(4,1,kerbuf,8740,j,m)
              do i=1,8740
                bkern(i)=kerbuf(i)
              enddo
              call somain
              kstat=jstat
            enddo
          endif
          if(jnstr.le.3) then
            npoint=183
            jifdep=244
          else
            npoint=i1
            jifdep=i2
          endif
          call strnsf
          if(iter.ne.0) then
            do i=1,514
              if(iter.gt.0) comp(i)=bkern(i)
              if(iter.lt.0) comp(i)=skern(i)
            enddo
            if(iter.lt.0) go to 499
          endif
          do i=1,5140
            synt(i)=skern(i)
          enddo
  499     continue
          wate=1.
          if(inst.eq.3.and.ratioi.ne.0.) wate=ratioi**2
          if(inst.eq.3.and.ratioi.eq.0.) wate=.2e-1
          if(inst.ne.3.and.rate.gt.20..and.ratiom.ne.0.)
     1       wate=ratiom**2
          write(6,1000) nnn,nn,name,lcomp,wate
 1000     format(' path=',i3,' record=',i3
     1        ,' station=',a4,' comp=',i2,' weight=',e10.3)
          if(iter.ge.0.and.rate.lt.20.)
     1         call tapclr(b(23),taperd,nfirst,nend,i1,i2,sum2)
          if(iter.ge.0.and.rate.gt.20.)
     1      call tapclr(b(23),taperd,nfirst,nend,183,244,sum2)
          if(iter.ge.0) call inpmtx(wate)
          if(iter.lt.0) call bffo(7,1,b,5604,j,jrec)
  700     continue
        enddo
      enddo
      write(6,'(''apsynt 2 - '',4i4)')ifpstr,iter,nodep,kpar
      return
      end
