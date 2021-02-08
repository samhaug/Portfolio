      subroutine spharmap(hmodeli,hfmt,param,depth,ycofs,lhigh)
      character*(*) hmodeli,hfmt,param
      character*80 hmodel
      dimension ycofs(*)
      parameter (MXPARM=20)
      parameter (MXLORD=12)
      parameter (MXLENY=(MXLORD+1)**2)
      parameter (MXMDLL=MXLENY*MXPARM)
      common/hetmdl/ifani,lmaxum,lmaxum1,lenyu,npmm,pertmu(588),bmdlu(588)
      common/lmmdl/lmaxlm,lmaxlm1,lenyl,npar,pertml(588),bmdll(588)
      common/nmdl/lmaxn,nstr,anmdl(MXMDLL),bnmdl(MXMDLL)
      dimension mask(MXPARM),mask1(MXPARM),lask(0:MXLORD),lask1(0:MXLORD)
      common/mmdl/cmod(15,222,3),cmob(15,4),ycofs0(100),ycofs1(100)
      common/dvce/dvcof(121),divco(121),ifproj
      common/cmbc/lmcmb,cmbcof(121),cmbrot(121)
      common/gcof/lmgeoid,geocof(121),gcofr(121)
      common/rawcof/lmraw,rawmdl(MXLENY)
      parameter (MXLJNO=50)
      common/mdljno/lmjno,amjno( (MXLJNO+1)**2 )

      dimension vsc(5)
      call complnam(hmodeli,hmodel,lhmodel)
      if(hfmt.eq.'div') then
        call rddivc(1,hmodel,10,dvcof)
        do i=1,121
          dvcof(i)=dvcof(i)*1.e+09
        enddo
        lmdiv=10

      else if(hfmt.eq.'geo') then
        call rgeoid(1,hmodel,lmgeoid,geocof)

      else if(hfmt.eq.'cmb') then
        call rdcmb(1,hmodel,lmcmb,cmbcof)

      else if(hfmt.eq.'htm') then
        open(1,file=hmodel,status='old')
        call rdmdl(1)
        close(1)

      else if(hfmt.eq.'lmm') then
        open(1,file=hmodel,status='old')
        call rdmdll(1)
        close(1)

      else if(hfmt.eq.'pct') then
        call heread(1,hmodel,bnmdl,nstr,lmaxn,mask,lask,0)
        do i=1,nstr
          mask1(i)=1
        enddo
        do i=0,lmaxn
          lask1(i)=1
        enddo
        call mskmdl(bnmdl,nstr,lmaxn,mask,lask
     1       ,anmdl,nstr,lmaxn,mask1,lask1)

      else if(hfmt.eq.'mml') then
        open(1,file=hmodel,status='old')
        read(1,'(5e12.5)') cmod,cmob
        close(1)

      else if(hfmt.eq.'raw') then
        open(1,file=hmodel,status='old')
        read(1,*) lmraw
        do i=1,(lmraw+1)**2
          read(1,*) rawmdl(i)
        enddo
        close(1)

      else if(hfmt.eq.'jno') then
        open(1,file=hmodel,status='old')
        read(1,*) lmjno
        read(1,'(5e16.8)') (amjno(i),i=1,(lmjno+1)**2)
        close(1)

      else 
        write(0,'(''spharmap: Unknown model format'')')
        call exit(2)
      endif
      

      rmoho=6346619.
      r670=5701000.
      r1500=6371000.-1500000.
      rcmb=3479958.
      rx=6371000.-depth*1000.


      if(hfmt.eq.'div') then
        lhigh=lmdiv
        do i=1,(lhigh+1)**2
          ycofs(i)=dvcof(i)
        enddo

      else if(hfmt.eq.'geo') then
        lhigh=lmgeoid
        do i=1,(lhigh+1)**2
          ycofs(i)=geocof(i)
        enddo

      else if(hfmt.eq.'cmb') then
        lhigh=lmcmb
        do i=1,(lhigh+1)**2
          ycofs(i)=cmbcof(i)
        enddo

      else if(hfmt.eq.'htm') then
        if(param.eq.'vs') then
          x=-1.+2.*(rx-r670)/(rmoho-r670)
          if(x.gt.1..or.x.lt.-1.) then
            write(0,'(''spharmap: htm: depth out of range'')')
            call exit(2)
          endif
          call evprem(rx,xaaa,xccc,xlll,xnnn,xfff,xrho,vn,rhobar,iq)
          vs2=2.*(vn/1000.)**2*xlll/xrho
          do icof=1,4
            vsc(icof)=100.*pn(icof-1,x)/vs2
          enddo

          lhigh=lmaxum
          do i=1,(lhigh+1)**2
            sum=0.
            do icof=1,4
              sum=sum+vsc(icof)*pertmu((1+icof)*lenyu+i)
            enddo
            ycofs(i)=sum
          enddo
        else if(param.eq.'crust') then
          lhigh=lmaxum
          do i=1,(lhigh+1)**2
            ycofs(i)=pertmu(i)
          enddo
        else
          write(0,'(''spharmap: htm: unknown parameter'')')
          call exit(2)
        endif

      else if(hfmt.eq.'lmm') then
        if(param.eq.'vp') then
          x=-1.+2.*(rx-rcmb)/(r670-rcmb)
          if(x.gt.1..or.x.lt.-1.) then
            write(0,'(''spharmap: htm: depth out of range'')')
            call exit(2)
          endif
          call evprem(rx,xaaa,xccc,xlll,xnnn,xfff,xrho,vn,rhobar,iq)
          vs2=(vn/1000.)*sqrt(xaaa/xrho)
          do icof=1,5
            vsc(icof)=100.*pn(icof-1,x)/vs2
          enddo

          lhigh=lmaxlm
          do i=1,(lhigh+1)**2
            sum=0.
            do icof=1,5
              sum=sum+vsc(icof)*pertml((icof-1)*lenyl+i)
            enddo
            ycofs(i)=sum
          enddo
        else
          write(0,'(''spharmap: lmm: unknown parameter'')')
          call exit(2)
        endif

      else if(hfmt.eq.'pct') then
        if(param.eq.'vs'.and.rx.ge.r670.and.rx.lt.rmoho) then
          ip1=3
          ip2=6
          rtop=rmoho
          rbot=r670
        else if(param.eq.'vs'.and.rx.ge.rcmb.and.rx.lt.r670) then
          ip1=7
          ip2=11
          rtop=r670
          rbot=rcmb
        else if(param.eq.'vp'.and.rx.ge.r670.and.rx.lt.rmoho) then
          ip1=12
          ip2=15
          rtop=rmoho
          rbot=r670
        else if(param.eq.'vp'.and.rx.ge.rcmb.and.rx.lt.r670) then
          ip1=16
          ip2=20
          rtop=r670
          rbot=rcmb
        else if(param.eq.'crust') then
          ip1=1
          ip2=1
        else
          write(0,'(''spharmap: pct: unknown parameter or wrong depth'')')
          call exit(2)
        endif
        if(ip1.ne.1) then
          x=-1.+2.*(rx-rbot)/(rtop-rbot)
          if(x.gt.1..or.x.lt.-1.) then
            write(0,'(''spharmap: pct: depth out of range'')')
            call exit(2)
          endif
          do icof=1,ip2-ip1+1
            vsc(icof)=100.*pn(icof-1,x)
          enddo
          lhigh=lmaxn
          lenyh=(lhigh+1)**2
          do i=1,lenyh
            sum=0.
            do icof=1,ip2-ip1+1
              sum=sum+vsc(icof)*anmdl((ip1+icof-2)*lenyh+i)
            enddo
            ycofs(i)=sum
          enddo
        else
          do i=1,(lhigh+1)**2
            ycofs(i)=anmdl(i)
          enddo
        endif

      else if(hfmt.eq.'mml') then
        lhigh=4
        ipar=0
        if(param.eq.'vp') ipar=1
        if(param.eq.'vs') ipar=2
        if(param.eq.'rho') ipar=3
        if(param.eq.'icb') ipar=4
        if(param.eq.'cmb') ipar=5
        if(param.eq.'670') ipar=6
        if(param.eq.'fsf') ipar=7
        if(ipar.eq.0) then
          write(0,'(''sparmap: format mml: unknown parameter'')')
          call exit(2)
        endif

        if(ipar.le.3) then
          call evprem(rx,xaaa,xccc,xlll,xnnn,xfff,xrho,vn,rhobar,iq)
          iyk=0
          iyke=0
          do iyl=0,4
            do iym=0,2*iyl
              iyk=1+iyk
              if(mod(iyl,2).eq.0) then
                iyke=1+iyke
                ycofs(iyk)=cmod(iyke,iq,ipar)*100.
                if(iym.eq.0.) ycofs(iyk)=ycofs(iyk)*sqrt(.5)
              else
                ycofs(iyk)=0.
              endif
            enddo
          enddo
          if(iyk.ne.25.or.iyke.ne.15) pause 'counting error'

        else
          iyk=0
          iyke=0
          do iyl=0,4
            do iym=0,2*iyl
              iyk=1+iyk
              if(mod(iyl,2).eq.0) then
                iyke=1+iyke
                ycofs(iyk)=cmob(iyke,ipar-3)*6371.
                if(iym.eq.0.) ycofs(iyk)=ycofs(iyk)*sqrt(.5)
              else
                ycofs(iyk)=0.
              endif
            enddo
          enddo
          if(iyk.ne.25.or.iyke.ne.15) pause 'counting error'

        endif

      else if(hfmt.eq.'raw') then
        lhigh=lmraw
        do i=1,(lmraw+1)**2
          ycofs(i)=rawmdl(i)
        enddo
      else 
        write(0,'(''spharmap: Unknown model format'')')
        call exit(2)
      endif
      return
      end
