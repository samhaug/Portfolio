      subroutine sgdumpah(name,lname,isub,iagram)
      include 'gramblock.h'
      include '../libdb/dblib.h'
      include 'phstable.h'
      include 'seedparam.h'
      parameter (LENFLT=1)
      include 'rspaddrs.h'
      character*200 str
      character*5 sta
      character*2 lid
      character*3 cha
      character*80 name
      character*95 instf,sacf

c the folowing was kindly given by G. Ekstrom
c-------------------------------------------------------------
      integer*2 iah(512),ifool(2),i2_ssecah(2),i2_esecah(2)
	equivalence (ifool,rfool)
       integer*4 ahequi(256),dumah(21)
	complex pz(2,29)
      character*6 codeah,chanah
      character*8 typeah
      integer*2 ieyrah,iemoah,iedaah,iehrah,iemnah
      integer*2 isyrah,ismoah,isdaah,ishrah,ismnah
      character*80 ecomah
      integer*2 itypah
      character*202 logah
	equivalence (iah(1),codeah,ahequi),(iah(4),chanah)
      equivalence (iah(7),typeah),(iah(11),slatah)
      equivalence (iah(13),slonah),(iah(15),elevah)
      equivalence (iah(17),dsah),(iah(19),a0ah)
      equivalence (iah(21),xnpah),(iah(23),nu1)
      equivalence (iah(25),xnzah),(iah(27),nu2)
      equivalence (iah(29),pz(1,1))
      equivalence (iah(261),elatah),(iah(263),elonah)
      equivalence (iah(265),edepah),(iah(267),ieyrah)
      equivalence (iah(268),iemoah),(iah(269),iedaah)
      equivalence (iah(270),iehrah),(iah(271),iemnah)
      equivalence (iah(272),i2_esecah),(iah(274),ecomah)
      equivalence (iah(314),itypah),(iah(315),ndatah)
      equivalence (iah(317),deltah),(iah(319),amaxah)
      equivalence (iah(321),isyrah),(iah(322),ismoah)
      equivalence (iah(323),isdaah),(iah(324),ishrah)
c....................................
      equivalence (iah(325),ismnah),(iah(326),i2_ssecah)
      equivalence (iah(370),logah),(iah(471),dumah(1))
c end of G. Ekstrom gift ------------------------

      do i=1,256
        ahequi(i)=0
      enddo


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
        write(6,*) 'sgdumpah: Trouble reformatting channel name', cha,' ksub=',' isub=',isub
      endif

      if(name(lname:lname).ne.'/') then
        sacf=name(1:lname)//'.'//sta//lid//cha//'.ah'
        instf=name(1:lname)//'.'//sta//lid//cha//'.i'
      else
        sacf=name(1:lname)//sta//lid//cha//'.ah'
        instf=name(1:lname)//sta//lid//cha//'.i'
      endif
      lsacf=istlen(sacf)
      linstf=istlen(instf)
      do i=1,lsacf
        if(sacf(i:i).eq.' ') sacf(i:i)='_'
      enddo
      do i=1,linstf
        if(instf(i:i).eq.' ') instf(i:i)='_'
      enddo

c open and write instrument file
      lu=10
      open(lu,file=instf(1:linstf))
      call sgstation(iagram,str,lstr)
      write(lu,"(200a1)") (str(i:i),i=1,lstr)
      call sgchannel(isub,iagram,str,lstr)
      write(lu,"(200a1)") (str(i:i),i=1,lstr)
      write(str,"(i6)") ibig(iach+OGRSREF)
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
      close(lu)   

c-----write ah data file

      iads=iach+ibig(iach+OGCHSGA)
      nsamp=ibig(iach+OGCHSGL)
      iaresp=iach+ibig(iach+OGRSBLO)

      codeah(1:4)=sta(1:4)
      chanah(1:3)=cha
      typeah=char(0)
      slatah=rbig(iaresp+FRSLAT)
      slonah=rbig(iaresp+FRSLON)
      elevah=rbig(iaresp+FRSELV)
c event if present
      if(nevt.gt.0) then
        ievt=1  ! only one event is defined
        elatah=xlatevs(ievt)
	elonah=xlonevs(ievt)
	edepah=xdepevs(ievt)
        call sectim(itimevs(1,ievt),jye,jde,ihe,ime,fsece)
        fsece=fsece+1.e-4*ishft(itimevs(2,ievt),-16)
        call juldat(jye,jde,imoe,idme)
	ieyrah=jye
	iemoah=imoe
	iedaah=idme
	iehrah=ihe
	iemnah=ime
        rfool=fsece
        i2_esecah(1)=ifool(1)
        i2_esecah(2)=ifool(2)
	esecah=fsece
      endif
      ecomah=' '

      if(nstage.ne.1) then
        write(6,'(a)') 'sgdumpah: *** Warning: can only enter 1 stage response ***'
        dsah=1.
        a0ah=1.
        xnzah=0.
        xnpah=0.
      else

        ipi=iaresp
        ipf=iaresp/LENFLT
        ipi0=iaresp
        nstage=ibig(ipi+IRSNCS)
        ipow=ibig(ipi+IRSPOW)
        dsah=rbig(ipf+FRSOSN)
        ipi=ipi+ILENRS
        ipf=ipi/LENFLT
        nz=0
        np=0
        a0ah=1./dsah
        do i=1,ipow
          nz=nz+1
          pz(2,nz)=(0.,0.)
        enddo
        
        do istage=1,nstage
          ipzco=ibig(ipi+ISGPZC)
          if(ipzco.eq.STRPZS) then
            ntop=ibig(ipi+ISGNTP)
            nbot=ibig(ipi+ISGNBT)
            a0ah=a0ah*rbig(ipf+FSGGAI)*rbig(ipf+FSGAZE)
            ipf1=ipf+FLENSG
            do i=1,ntop
              nz=nz+1
              if(nz.gt.29) then
                write(6,'(a)') 'sgdumpah: *** Warning too many zeros ***'
              else
                pz(2,nz)=cmplx(rbig(ipf1+2*i-2),rbig(ipf1+2*i-1))
              endif
            enddo
            ipf1=ipf1+ibig(ipi+ISGLNT)
            do i=1,nbot
              np=np+1
              if(np.gt.29) then
                 write(6,'(a)') 'sgdumpah: *** Warning too many poles ***'
              else
                pz(1,np)=cmplx(rbig(ipf1+2*i-2),rbig(ipf1+2*i-1))
              endif
            enddo
          else
            write(6,'(a)') 'sgdumpah: ***Warning: can only enter poles and zeroes'
          endif
          ipi=ipi0+ibig(ipi+ISGADN)
          ipf=ipi/LENFLT
        enddo

        xnzah=nz
        xnpah=np
      endif
      itypah=1
      ndatah=nsamp
      deltah=del
      call sectim(ibig(iach+OGCHSGS),jy,jd,ih,im,fsec)
      fsec=fsec+1.e-4*ishft(ibig(iach+OGCHSGS+1),-16)
      call juldat(jy,jd,imo,idm)
      isyrah=jy
      ismoah=imo
      isdaah=idm
      ishrah=ih
      ismnah=im
      rfool=fsec
      i2_ssecah(1)=ifool(1)
      i2_ssecah(2)=ifool(2)

      amaxah=0.
      ka=iads
      do i=1,nsamp
         amaxah=amax1(amaxah,abs(rbig(ka)))
         ka=ka+1
      enddo

c  write ah file
      luo=-1
      call opnflc(luo,sacf(1:lsacf),4,0,0,iostat,-1,2)
      call bffo(luo,1,ahequi,1024,j,0)
      call bffo(luo,1,rbig(iads),nsamp*4,j,0)
      call closfl(luo,iostat)

c check the ah-style response

      call chekahrsp(ahequi)

      return
      end
c-----------------------------------------------
      subroutine chekahrsp(headr)
      real*4 headr(*)
      include 'seedparam.h'
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
      complex resp(0:2),respah

c     write(6,'(a,i4,a,i4,a,1pe13.5,a,e13.5)')
c    1   'Response from AH header: np=',ifix(headr(11)),' nz=',ifix(headr(13))
c    1    ,' ds=',headr(9),' a0=',headr(10)

c     do i=1,ntest
c       om=ftest(i)*tpi
c       resp(0)=respah(om,headr)
c       resp(1)=resp(0)/cmplx(0.0,om)
c       resp(2)=resp(1)/cmplx(0.0,om)
c       write(6,"(a1,f7.4,f7.2,3x,3(1pe10.4,0pf9.2,2x,a5),f7.2)") 
c    1         ' ',ftest(i),1./ftest(i)
c    1       ,(cabs(resp(j)),360.*atan2(aimag(resp(j)),real(resp(j)))/tpi,utext(j)
c    1       ,j=0,2)
c     enddo
      return
      end




c------------------------------------------------
      complex function respah(om,headr)
      real*4 headr(*)

      respah=headr(9)*headr(10)
      k=17
      do i=1,ifix(headr(13))
        respah=respah*cmplx(-headr(k),om-headr(k+1))
        k=k+4
      enddo
      k=15
      do i=1,ifix(headr(11))
        respah=respah/cmplx(-headr(k),om-headr(k+1))
        k=k+4
      enddo
      return
      end



      
