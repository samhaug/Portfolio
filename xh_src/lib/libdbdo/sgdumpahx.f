      subroutine sgdumpahx(name,lname,isub,iagram)
      character*(*) name
      include 'gramblock.h'
      include '../libdb/dblib.h'
      include 'seedparam.h'
      parameter (LENFLT=1)
      include 'rspaddrs.h'
      character*95 cfstem

      call makefstem(name,isub,iagram,cfstem,lcfstem)

      luo=-1
      call opnflc(luo,cfstem(1:lcfstem)//'.ahx',4,0,0,iostat,-1,2)
      if(iostat.ne.0) then
        write(6,'(''sgdumpahx: Unable to open output file'')')
        ierr=9
        return
      endif
      call sgdumpahx1(luo,isub,iagram)
      call closfl(luo,iostat)

c open and write instrument file
      lu=10
      open(lu,file=cfstem(1:lcfstem)//'.i')
      call writedoti(lu,isub,iagram)
      close(lu)   


      return
      end

c------------------------------------------------------------------
      subroutine writedoti(lu,isub,iagram)
      character*200 str
      include 'gramblock.h'
      include '../libdb/dblib.h'
      include 'seedparam.h'
      parameter (LENFLT=1)
      include 'rspaddrs.h'



      call sgstation(iagram,str,lstr)
      write(lu,'(a)') str(1:lstr)
      call sgchannel(isub,iagram,str,lstr)
      write(lu,'(a)') str(1:lstr)

      iach=iagram+ibig(iagram+OGSTCHO+isub-1)
      write(str,'(i6)') ibig(iach+OGRSREF)
      ip=iststa(str(1:6))
      str(7:12)=str(ip:6)
      iaresp=iach+ibig(iach+OGRSBLO)


      ipi=iaresp
      ipf=iaresp/LENFLT
      ipi0=iaresp
      nstage=ibig(ipi+IRSNCS)
      ipow=ibig(ipi+IRSPOW)

      write(lu,"('  Response cr.',a6,' has',i2,' stages. Units are ',a5
     1     ,'.',' Rate is ',f8.4,'Hz.  DS=',1pe13.5,' at ',0pf8.4,'Hz.')") 
     1  str(7:12),nstage,utext(ipow),rbig(ipf+FRSSRT),rbig(ipf+FRSOSN),rbig(ipf+FRSFOV)
      del=1./rbig(ipf+FRSSRT)
      ipi=ipi+ILENRS
      ipf=ipi/LENFLT
      do istage=1,nstage
        if(rbig(ipf+FSGINR).lt.1000.) then
          write(lu,"('  Stage:',i2,'. ',2i1,2i2,1pe13.5,0p2f8.4,2i4,2f10.4)")
     1        istage, ibig(ipi+ISGPZC),ibig(ipi+ISGABD)
     1       ,ibig(ipi+ISGINU),ibig(ipi+ISGOUU),rbig(ipf+FSGGAI),rbig(ipf+FSGFGA)
     1       ,rbig(ipf+FSGINR),ibig(ipi+ISGDCF),ibig(ipi+ISGDCO)
     1       ,rbig(ipf+FSGEDL),rbig(ipf+FSGCAP)
        else
          write(lu,"('  Stage:',i2,'. ',2i1,2i2,1pe13.5,0pf8.4,f8.3,2i4,2f10.4)")
     1        istage, ibig(ipi+ISGPZC),ibig(ipi+ISGABD)
     1       ,ibig(ipi+ISGINU),ibig(ipi+ISGOUU),rbig(ipf+FSGGAI),rbig(ipf+FSGFGA)
     1       ,rbig(ipf+FSGINR),ibig(ipi+ISGDCF),ibig(ipi+ISGDCO)
     1       ,rbig(ipf+FSGEDL),rbig(ipf+FSGCAP)
        endif
        ipzco=ibig(ipi+ISGPZC)
        if(ipzco.eq.STRPZS) then
          write(lu,"(3x,'a0=',1pe13.5,' at ',0pf8.4,'Hz')") rbig(ipf+FSGAZE),rbig(ipf+FSGFAZ)
          ntop=ibig(ipi+ISGNTP)
          nbot=ibig(ipi+ISGNBT)
          write(lu,"(i4,' zeros')") ntop
          ipf1=ipf+FLENSG
          if(ntop.ne.0) write(lu,"(4x,1p6e13.5)") (rbig(ipf1+i-1),i=1,2*ntop)
          write(lu,"(i4,' poles')") nbot
          ipf1=ipf1+ibig(ipi+ISGLNT)
          if(nbot.ne.0) write(lu,"(4x,1p6e13.5)") (rbig(ipf1+i-1),i=1,2*nbot)
        else if(ipzco.eq.STRCOF) then
          ntop=ibig(ipi+ISGNTP)
          nbot=ibig(ipi+ISGNBT)
          write(lu,"(i4,' numerator coefficients')") ntop
          ipf1=ipf+FLENSG
          if(ntop.ne.0) write(lu,"(4x,1p6e13.5)") (rbig(ipf1+i-1),i=1,ntop)
          ipf1=ipf1+ibig(ipi+ISGLNT)
          write(lu,"(i4,' denominator coefficients')") nbot
          if(nbot.ne.0) write(lu,"(4x,1p6e13.5)") (rbig(ipf1+i-1),i=1,nbot)
        else 
          pause 'sgdumpascii: unknown response format'
        endif
        ipi=ipi0+ibig(ipi+ISGADN)
        ipf=ipi/LENFLT
      enddo
      return
      end

c-------------------------------------------------------
      subroutine makefstem(name,isub,iagram,cfstem,lcfstem)
      character*(*) name,cfstem
      include 'gramblock.h'
      include '../libdb/dblib.h'
      character*5 sta
      character*2 lid
      character*3 cha

      lname=istlen(name)
c define instrument and sac file name
      ica=4*(iagram+OGSTNAM)
      k=0
      do i=ica,ica+4
         k=k+1
         sta(k:k)=cbig(i)
      enddo
      iach=iagram+ibig(iagram+OGSTCHO+isub-1)
      k=0
      ica=4*(iach+OGCHLID)
      do i=ica,ica+1
        k=k+1
        lid(k:k)=cbig(i)
      enddo
      k=0
      ica=4*(iach+OGCHCID)
      do i=ica,ica+2
         k=k+1
         cha(k:k)=cbig(i)
      enddo
      ksub=ibig(iach+OGCHSUB)
      if(ksub.eq.0) then
      else if(ksub.eq.1.and.cha(3:3).eq.' ') then
        cha(3:3)='Z'
      else if(ksub.eq.2.and.cha(3:3).eq.' ') then
        cha(3:3)='N'
      else if(ksub.eq.3.and.cha(3:3).eq.' ') then
        cha(3:3)='E'
      else
        write(6,*) 'makefstem: Trouble reformatting channel name', cha,' ksub=',ksub,' isub=',isub
      endif

      if(name(lname:lname).ne.'/') then
        cfstem=name(1:lname)//'.'//sta//lid//cha
      else
        cfstem=name(1:lname)//sta//lid//cha
      endif
      lcfstem=istlen(cfstem)
      do i=1,lcfstem
        if(cfstem(i:i).eq.' ') cfstem(i:i)='_'
      enddo
      return
      end

c-------------------------------------------------------------
      subroutine sgdumpahx1(luo,isub,iagram)
      include 'gramblock.h'
      include '../libdb/dblib.h'
      include 'phstable.h'
      include 'seedparam.h'
      parameter (LENFLT=1)
      include 'rspaddrs.h'
      include 'ahheader.h'

      common/plevel/iprtlv

      character*5 sta
      character*2 lid
      character*3 cha
      character*80 str80


c     Write ah data file

c     Initialize header
      call balloc(LAHHDR,iaahh)
      do i=0,LAHHDR-1
        ibig(iaahh+i)=0
      enddo
      ibig(iaahh+AAHLCD)=6
      ibig(iaahh+AAHLCH)=6
      ibig(iaahh+AAHLTP)=8
      ibig(iaahh+AAHLEC)=80
      ibig(iaahh+AAHLDC)=80
      ibig(iaahh+AAHLLG)=202
      ibig(iaahh+AAHNXR)=MAHXRS



c     Get station and channel names
      ica=4*(iagram+OGSTNAM)
      k=0
      do i=ica,ica+4
         k=k+1
         sta(k:k)=cbig(i)
      enddo
      iach=iagram+ibig(iagram+OGSTCHO+isub-1)
      k=0
      ica=4*(iach+OGCHLID)
      do i=ica,ica+1
        k=k+1
        lid(k:k)=cbig(i)
      enddo
      k=0
      ica=4*(iach+OGCHCID)
      do i=ica,ica+2
         k=k+1
         cha(k:k)=cbig(i)
      enddo
      ksub=ibig(iach+OGCHSUB)
      if(ksub.eq.0) then
      else if(ksub.eq.1.and.cha(3:3).eq.' ') then
        cha(3:3)='Z'
      else if(ksub.eq.2.and.cha(3:3).eq.' ') then
        cha(3:3)='N'
      else if(ksub.eq.3.and.cha(3:3).eq.' ') then
        cha(3:3)='E'
      else
        write(6,*) 'sgdumpah1: Trouble reformatting channel name:', cha,' ksub=',ksub,' isub=',isub
      endif

      iads=iach+ibig(iach+OGCHSGA)
      nsamp=ibig(iach+OGCHSGL)
      iaresp=iach+ibig(iach+OGRSBLO)



      call loadchr(ibig(iaahh+AAHACD),2,sta(1:4)//lid//'\0\0')
      call loadchr(ibig(iaahh+AAHACH),2,cha(1:3)//'\0\0\0\0\0')
      call loadchr(ibig(iaahh+AAHATP),2,'\0')
      rbig(iaahh+AAHSLT)=rbig(iaresp+FRSLAT)
      rbig(iaahh+AAHSLN)=rbig(iaresp+FRSLON)
      rbig(iaahh+AAHSEL)=rbig(iaresp+FRSELV)
c event if present
      call loadchr(ibig(iaahh+AAHAEC),20,' ')
      if(nevt.gt.0) then
        ievt=1  ! only one event is defined
        rbig(iaahh+AAHELT)=xlatevs(ievt)
	rbig(iaahh+AAHELN)=xlonevs(ievt)
	rbig(iaahh+AAHEDP)=xdepevs(ievt)
        call sectim(itimevs(1,ievt),jye,jde,ihe,ime,fsece)
        fsece=fsece+1.e-4*ishft(itimevs(2,ievt),-16)

  
        call juldat(jye,jde,imoe,idme)
	ibig(iaahh+AAHEYR)=jye
	ibig(iaahh+AAHEMO)=imoe
	ibig(iaahh+AAHEDA)=idme
	ibig(iaahh+AAHEHR)=ihe
	ibig(iaahh+AAHEMI)=ime
	rbig(iaahh+AAHESC)=fsece
        call getvar('cmtname',str80,lstr80)
        write(str80(lstr80+1:80),'(1x,i3,''h '')') ifix(xdepevs(ievt)+.5)
        lstr80=lstr80+6
        call getvar('mw',str80(lstr80+1:80),ll)
        lstr80=lstr80+ll
        call loadchr(ibig(iaahh+AAHAEC),20,str80) 



      endif

      ipi=iaresp
      ipf=iaresp/LENFLT
      ipi0=iaresp
      nstage=ibig(ipi+IRSNCS)
      ipow=ibig(ipi+IRSPOW)


      if(nstage.ne.1) then
        write(6,'(a)') 'sgdumpah: *** Warning: can only enter 1 stage response ***'
        rbig(iaahh+AAHDSN)=1.
        rbig(iaahh+AAHAZR)=1.
        rbig(iaahh+AAHNPL)=0.
        rbig(iaahh+AAHNZR)=0.
      else

        if(rbig(ipf+FRSOSN).ne.0.) then
          rbig(iaahh+AAHDSN)=rbig(ipf+FRSOSN)
        else
          rbig(iaahh+AAHDSN)=1.
        endif
        del=1./rbig(ipf+FRSSRT)
        ipi=ipi+ILENRS
        ipf=ipi/LENFLT
        nz=0
        np=0
        rbig(iaahh+AAHAZR)=1./rbig(iaahh+AAHDSN)
        do i=1,ipow
          rbig(iaahh+AAHPZS+2*(1+2*nz))=0.
          rbig(iaahh+AAHPZS+1+2*(1+2*nz-1))=0.
          nz=nz+1
        enddo
        
        do istage=1,nstage
          ipzco=ibig(ipi+ISGPZC)
          if(ipzco.eq.STRPZS) then
            ntop=ibig(ipi+ISGNTP)
            nbot=ibig(ipi+ISGNBT)
            rbig(iaahh+AAHAZR)=rbig(iaahh+AAHAZR)*rbig(ipf+FSGGAI)*rbig(ipf+FSGAZE)
            ipf1=ipf+FLENSG
            if(ibig(ipi+ISGABD).eq.STRFTA) then
              fcfron=1.
              fcfreq=1.
            else if(ibig(ipi+ISGABD).eq.STRFTB) then
              fcfron=(2.*3.14159265)**(nbot-ntop)
              fcfreq=2.*3.14159265
            else
              write(6,*) 'sgdumahx: invalid response type'
              fcfron=1.
              fcfreq=1.
            endif

            do i=1,ntop
              if(nz.ge.MAHPZS) then
                write(6,'(a)') 'sgdumpah: *** Warning too many zeros ***'
              else
                rbig(iaahh+AAHPZS+4*nz+2)=rbig(ipf1+2*i-2)*fcfreq
                rbig(iaahh+AAHPZS+4*nz+3)=rbig(ipf1+2*i-1)*fcfreq
                nz=nz+1
              endif
            enddo
            ipf1=ipf1+ibig(ipi+ISGLNT)
            do i=1,nbot
              if(np.ge.MAHPZS) then
                 write(6,'(a)') 'sgdumpah: *** Warning too many poles ***'
              else
                rbig(iaahh+AAHPZS+4*np)=rbig(ipf1+2*i-2)*fcfreq
                rbig(iaahh+AAHPZS+4*np+1)=rbig(ipf1+2*i-1)*fcfreq
                np=np+1
              endif
            enddo
          else
            write(6,'(a)') 'sgdumpah: ***Warning: can only enter poles and zeroes'
          endif
          ipi=ipi0+ibig(ipi+ISGADN)
          ipf=ipi/LENFLT
          rbig(iaahh+AAHAZR)=rbig(iaahh+AAHAZR)*fcfron
        enddo

        rbig(iaahh+AAHNPL)=np
        rbig(iaahh+AAHNZR)=nz


      endif
      ibig(iaahh+AAHITP)=1
      ibig(iaahh+AAHNDT)=nsamp
      rbig(iaahh+AAHDEL)=del
      call sectim(ibig(iach+OGCHSGS),jy,jd,ih,im,fsec)
      fsec=fsec+1.e-4*ishft(ibig(iach+OGCHSGS+1),-16)
      call juldat(jy,jd,imo,idm)
      ibig(iaahh+AAHSYR)=jy
      ibig(iaahh+AAHSMO)=imo
      ibig(iaahh+AAHSDA)=idm
      ibig(iaahh+AAHSHR)=ih
      ibig(iaahh+AAHSMI)=im
      rbig(iaahh+AAHSSC)=fsec
      aa=0.
      ka=iads
      do i=1,nsamp
         aa=amax1(aa,abs(rbig(ka)))
         ka=ka+1
      enddo
      rbig(iaahh+AAHAMX)=aa

      if(nz+2.le.MAHPZS) then  ! put in flag,dip,azim
        rbig(iaahh+AAHPZS+4*nz+2)=XDIPA ! flag indicating dip, azm
        rbig(iaahh+AAHPZS+4*nz+3)=rbig(iaresp+FRSDIP)
        rbig(iaahh+AAHPZS+4*nz+6)=rbig(iaresp+FRSAZM)
      else
        write(6,'(a)') 'sgdumpah: ***Warning: No space for dip and azimuth'
      endif


c  write ah file
      call bffo(luo,1,ibig(iaahh),LAHHDR*4,j,0)
      call bffo(luo,1,rbig(iads),nsamp*4,j,0)

c check the ah-style response

      if(iprtlv.gt.4) call chekahrspx(rbig(iaahh))
      call dalloc(LAHHDR,iaahh)
      return
      end
c-----------------------------------------------
      subroutine chekahrspx(headr)
      real*4 headr(0:*)
      include 'seedparam.h'
      include 'ahheader.h'
      dimension ftest(12)
      data ftest
     1               /00.002
     1               ,00.004
     1               ,00.010
     1               ,00.020
     1               ,00.040
     1               ,00.100
     1               ,00.200
     1               ,00.500
     1               ,01.000
     1               ,02.000
     1               ,05.000
     1               ,10.000/
      data ntest/12/
      data tpi/6.2831853/
      complex resp(0:2),respahx

      write(6,'(a,i4,a,i4,a,1pe13.5,a,e13.5)')
     1   'Response from AH header: np=',ifix(headr(AAHNPL)),' nz=',ifix(headr(AAHNZR))
     1    ,' ds=',headr(AAHDSN),' a0=',headr(AAHAZR)

      do i=1,ntest
        om=ftest(i)*tpi
        resp(0)=respahx(om,headr)
        resp(1)=resp(0)/cmplx(0.0,om)
        resp(2)=resp(1)/cmplx(0.0,om)
        write(6,"(a1,f7.4,f7.2,3x,3(1pe10.4,0pf9.2,2x,a5),f7.2)") 
     1         ' ',ftest(i),1./ftest(i)
     1       ,(cabs(resp(j)),360.*atan2(aimag(resp(j)),real(resp(j)))/tpi,utext(j)
     1       ,j=0,2)
      enddo
      return
      end




c------------------------------------------------
      complex function respahx(om,headr)
      real*4 headr(0:*)
      include 'ahheader.h'

      respahx=headr(AAHDSN)*headr(AAHAZR)
      k=AAHPZS+2
      knt=0
      do i=1,ifix(headr(AAHNZR))
        respahx=respahx*cmplx(-headr(k),om-headr(k+1))
        k=k+4
        amp=cabs(respahx)
        if(amp.gt.1.e20) then
          respahx=respahx*1.e-20
          knt=knt+1
        endif
        if(amp.lt.1.e-20) then
          respahx=respahx*1.e20
          knt=knt-1
        endif
      enddo
      k=AAHPZS
      do i=1,ifix(headr(AAHNPL))
        respahx=respahx/cmplx(-headr(k),om-headr(k+1))
        k=k+4
        amp=cabs(respahx)
        if(amp.gt.1.e20) then
          respahx=respahx*1.e-20
          knt=knt+1
        endif
        if(amp.lt.1.e-20) then
          respahx=respahx*1.e20
          knt=knt-1
        endif
      enddo
      if(knt.ne.0) respahx=respahx*1.e20**knt
      return
      end


c------------------------------------------------
      subroutine dipazmahx(dip,azm,ierr,headr)
      real*4 headr(0:*)
      include 'ahheader.h'

      ierr=0
      nz=ifix(headr(AAHNZR))

      if(nz+2.le.MAHPZS) then
        if(headr(AAHPZS+4*nz+2).eq.XDIPA) then
          dip=headr(AAHPZS+4*nz+3)
          azm=headr(AAHPZS+4*nz+6)
        else
          ierr=1   ! dip, azm not in record
        endif
      else
        ierr=2     ! no space for dip, azm (shouldnt occur)
      endif
      return
      end

c------------------------------------------------ 

      subroutine setdpazah(dip,azm,ierr,headr)
      real*4 headr(0:*)
      include 'ahheader.h'
      ierr=0
      nz=ifix(headr(AAHNZR))

      if(nz+2.le.MAHPZS) then
        headr(AAHPZS+4*nz+2)=XDIPA
        headr(AAHPZS+4*nz+3)=dip
        headr(AAHPZS+4*nz+6)=azm
      else
        ierr=2     ! no space for dip, azm (shouldnt occur)
      endif
      return
      end

c------------------------------------------------ 

      function rspconfac(headr,headr1)
      real*4 headr(0:*),headr1(0:*)
      include 'ahheader.h'
      rspconfac=0.0
      nz=ifix(headr(AAHNZR))
      nz1=ifix(headr1(AAHNZR))
      np=ifix(headr(AAHNPL))
      np1=ifix(headr1(AAHNPL))
      if(nz.ne.nz1.or.np.ne.np1) return

      k=AAHPZS+2
      do i=1,nz
        if(headr(k).ne.headr1(k).or.headr(k+1).ne.headr1(k+1)) return
        k=k+4
      enddo
      k=AAHPZS
      do i=1,np
        if(headr(k).ne.headr1(k).or.headr(k+1).ne.headr1(k+1)) return
        k=k+4
      enddo
c poles and zeros are the same

      rspconfac= (headr(AAHDSN)/headr1(AAHDSN))
     1          *(headr(AAHAZR)/headr1(AAHAZR))
      return
      end
