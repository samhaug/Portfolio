

c----------------------------------------------------------------------
      subroutine seedhdr(jbuf,str5,str2,str3,iy,id,ih,im,fs
     1  ,nsamp,smpin,iblks,corr,iflgs,ibytdta)
      integer*2 jbuf(*)
      character*(*) str5,str3,str2
      double precision smpin
      integer*2 minus8/-8/,right/Z'00FF'/,it2(2)
      equivalence (it,it2(1))
      character*12 str12
      write(str12,"(6a2)") (jbuf(i),i=1,6)
      str5=str12(1:5)
      str2=str12(6:7)
      str3=str12(8:10)
      do i=1,5
        if(str5(i:i).eq.'\0') str5(i:i)=' '
      enddo
      do i=1,2
        if(str2(i:i).eq.'\0') str2(i:i)=' '
      enddo
      do i=1,3
        if(str3(i:i).eq.'\0') str3(i:i)=' '
      enddo
      call byswap2(jbuf(7),14)
      iwd=7
      iy=jbuf(iwd)
      iwd=iwd+1
      id=jbuf(iwd)
      iwd=iwd+1
      ih=ishft(jbuf(iwd),minus8)
      im=and(jbuf(iwd),right)
      iwd=1+iwd
      is=ishft(jbuf(iwd),minus8)
      iwd=1+iwd
      fs=float(is)+float(jbuf(iwd))*1.e-4
      iwd=iwd+1
      nsamp=jbuf(iwd)
      iwd=1+iwd
      is1=jbuf(iwd)
      iwd=iwd+1
      is2=jbuf(iwd)

c      if(is1.gt.0) then
c        smpin=float(is1)
c      else
c        smpin=1./float(-is1)
c      endif
c      if(is2.gt.0) then
c        smpin=smpin*float(is2)
c      else
c        smpin=smpin/float(-is2)
c      endif
c      smpin=1./smpin


      if(is1.gt.0) then
        smpin=1.d0/float(is1)
      else
        smpin=float(-is1)
      endif
      if(is2.gt.0) then
        smpin=smpin/float(is2)
      else
        smpin=smpin*float(-is2)
      endif



      iwd=iwd+1
      it2(1)=jbuf(iwd)
      iwd=iwd+1
      it2(2)=jbuf(iwd)
      iflgs=ishft(it,-8)
      iblks=and(right,it2(2))
      iwd=iwd+1
      it2(1)=jbuf(iwd)
      iwd=iwd+1
      it2(2)=jbuf(iwd)
      corr=float(it)*1.e-4
      iwd=iwd+1
      ibytdta=jbuf(iwd)
      call byswap2(jbuf(7),14)
      return
      end
