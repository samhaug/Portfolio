      subroutine sgdumpsac(name,lname,isub,iagram)
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
      dimension xardum(1)

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
        write(6,*) 'sgdumpsac: Trouble reformatting channel name', cha,' ksub=',' isub=',isub
      endif

      if(name(lname:lname).ne.'/') then
        sacf=name(1:lname)//'.'//sta//lid//cha//'.s'
        instf=name(1:lname)//'.'//sta//lid//cha//'.i'
      else
        sacf=name(1:lname)//sta//lid//cha//'.s'
        instf=name(1:lname)//sta//lid//cha//'.i'
      endif
      lenght=istlen(sacf)
      do i=1,lenght
        if(sacf(i:i).eq.' ') sacf(i:i)='_'
        if(instf(i:i).eq.' ') instf(i:i)='_'
      enddo
      lutemp=-1
      call opnflc(lutemp,sacf(1:lenght),4,0,0,kk,-1,2)
      call closfl(lutemp,kk)


c open and write instrument file
      lu=10
      open(lu,file=instf(1:lenght))
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
      del=1./rbig(ipf+FRSSRT)
      if(nstage.gt.0) then
        ipow=ibig(ipi+IRSPOW)

        write(lu,"('  Response cr.',a6,' has',i2,' stages. Units are ',a5
     1       ,'.',' Rate is ',f8.4,'Hz.  DS=',1pe13.5,' at ',0pf8.4,'Hz.')") 
     1    str(7:12),nstage,utext(ipow),rbig(ipf+FRSSRT),rbig(ipf+FRSOSN),rbig(ipf+FRSFOV)
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
      else
        write(lu,'(''  No response.'')')
      endif
      close(lu)   

c-----write sac data file

      iads=iach+ibig(iach+OGCHSGA)
      nsamp=ibig(iach+OGCHSGL)
      iaresp=iach+ibig(iach+OGRSBLO)
      k=iaresp
    
      nerr=0
      call newhdr
      call setnhv('NPTS',nsamp,merr)
      nerr=nerr+merr
      beg=0.
      call setfhv('B',beg,merr)
      nerr=nerr+merr
      end=beg+(nsamp-1)*del
      call setfhv('E',end,merr)
      nerr=nerr+merr
      call setihv('IFTYPE','ITIME',merr)
      nerr=nerr+merr
      call setlhv('LEVEN',.TRUE.,merr)
      nerr=nerr+merr
      call setfhv('DELTA',del,merr)
      nerr=nerr+merr


      call sectim(ibig(iach+OGCHSGS),jy,jd,ih,im,fsec)
      nsec=fsec
      msec=(ishft(ibig(iach+OGCHSGS+1),-16))/10.+.5


      call setnhv('NZYEAR',jy,merr)
      nerr=nerr+merr
      call setnhv('NZJDAY',jd,merr)
      nerr=nerr+merr
      call setnhv('NZHOUR',ih,merr)
      nerr=nerr+merr
      call setnhv('NZMIN',im,merr)
      nerr=nerr+merr
      call setnhv('NZSEC',nsec,merr)
      nerr=nerr+merr
      call setnhv('NZMSEC',msec,merr)
      nerr=nerr+merr
      call setihv('IZTYPE','IB',merr)
      nerr=nerr+merr
      call setkhv('KSTNM',sta(1:4),merr)
      nerr=nerr+merr
      call setkhv('KCMPNM',cha,merr)
      nerr=nerr+merr
      call setfhv('STLA',rbig(iaresp+FRSLAT),merr)
      nerr=nerr+merr
      call setfhv('STLO',rbig(iaresp+FRSLON),merr)
      nerr=nerr+merr
      call setfhv('STEL',rbig(iaresp+FRSELV),merr)
      nerr=nerr+merr
      call setfhv('STDP',rbig(iaresp+FRSDEP),merr)
      nerr=nerr+merr
      if (cha(3:3).EQ.'Z') then
         call setfhv('CMPINC',0.,merr)
         nerr=nerr+merr
         if(rbig(iaresp+FRSDIP).eq.-90.) call setlhv('LPSPOL',.TRUE.,merr)
         if(rbig(iaresp+FRSDIP).eq.90.) call setlhv('LPSPOL',.FALSE.,merr)
         nerr=nerr+merr
         if(rbig(iaresp+FRSDIP).ne.90..and.rbig(iaresp+FRSDIP).ne.-90.) then
           write(6,*) 'sgdumpsac: unknown vertical orientation ',rbig(iaresp+FRSDIP)
         endif      
         call setfhv('CMPAZ',0.,merr)
      endif
      if (cha(3:3).EQ.'N') then
         call setfhv('CMPINC',90.,merr)
         nerr=nerr+merr
         call setfhv('CMPAZ',0.,merr)
         nerr=nerr+merr
         if(rbig(iaresp+FRSAZM).eq.0.) call setlhv('LPSPOL',.TRUE.,merr)
         if(rbig(iaresp+FRSAZM).eq.180.) call setlhv('LPSPOL',.FALSE.,merr)
         nerr=nerr+merr
         if(rbig(iaresp+FRSAZM).ne.0..and.rbig(iaresp+FRSAZM).ne.180.) then
           write(6,*) 'sgdumpsac: unknown N-S orientation ',rbig(iaresp+FRSAZM)
         endif
      endif
      if (cha(3:3).EQ.'E') then
         call setfhv('CMPINC',90.,merr)
         nerr=nerr+merr
         call setfhv('CMPAZ',90.,merr)
         nerr=nerr+merr
         if(rbig(iaresp+FRSAZM).eq.90.) call setlhv('LPSPOL',.TRUE.,merr)
         if(rbig(iaresp+FRSAZM).eq.270.) call setlhv('LPSPOL',.FALSE.,merr)
         nerr=nerr+merr
         if(rbig(iaresp+FRSAZM).ne.90..and.rbig(iaresp+FRSAZM).ne.270.) then
           write(6,*) 'sgdumpsac: unknown E-W orientation ',rbig(iaresp+FRSAZM)
         endif
      endif
      if(nevt.gt.0) then
        ievt=1  ! only one event is defined
        call setfhv('EVLA',xlatevs(ievt),merr)
        nerr=nerr+merr
        call setfhv('EVLO',xlonevs(ievt),merr)
        nerr=nerr+merr
        call setfhv('EVDP',xdepevs(ievt),merr)
        nerr=nerr+merr

        ot=itimevs(1,ievt)-ibig(iach+OGCHSGS)
     1     +1.e-4*( ishft(itimevs(2,ievt),-16)-ishft(ibig(iach+OGCHSGS+1),-16) )
        call setfhv('O',ot,merr)
        nerr=nerr+merr
      endif

c      call setlhv('LCALDA',.TRUE.,merr)
c      nerr=nerr+merr

      call setnhv('NVHDR',6,merr)
      nerr=nerr+merr
c  write sac file
      call wsac0(sacf(1:lenght),xardum(1),rbig(iads),merr)
      nerr=nerr+merr
      if(nerr.eq.0) then
        write(6,*) 'sac ok for ',sacf(1:lenght)
      else
        write(6,*) 'nerr from sac ', nerr,sacf(1:lenght)
      endif

      return
      end
c should set these some time
c       call getfhv('BAZ', BAZ, nerr)
c       call getfhv('gcarc', gcarc, nerr)

