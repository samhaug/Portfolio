c -----------------------------------------------------

      subroutine rsph(infl,x,lmx,nsmx,maskl,masks,ndmx,ndmn)


      character*80 infl
      character*200 line,dum1
      character*2 c1
      dimension x(*)
      dimension maskl(*), masks(*)

      open(10,file=infl,status='old')
      read(10,*) lmx,dum,nsmx
      rewind(10)
      write(6,*) lmx,nsmx

      if(lmx.gt.100.or.nsmx.gt.100) stop'lmx.gt.100.or.nsmx.gt.100'

      read(10,'(a)') line
      ll=len(line)

c     find out where lmx is on the line
      do i=1,ll-1
       c1=line(i:i+1)
       read(c1,'(i2)') ltst
       if(ltst.eq.lmx) imb=i+3
      enddo

      dum1=line(imb:imb+lmx-1)
      read(dum1,11) (maskl(i),i=1,lmx)
11    format(100i1)
      write(6,12) (maskl(i),i=1,lmx)
12    format('maskl = ',100i1)

c     find out where nsmx is on the line
      do i=imb+lmx,ll-1
       c1=line(i:i+1)
       read(c1,'(i2)') ltst
       if(ltst.eq.nsmx) imb=i+3
      enddo

      dum1=line(imb:imb+nsmx-1)
      read(dum1,11) (masks(i),i=1,nsmx)
      write(6,13) (masks(i),i=1,nsmx)
13    format('masks = ',100i1)

      ndmn=1
      do while(masks(ndmn).ne.1)
       ndmn=ndmn+1
      enddo

      ndmx=ndmn
      write(6,*) ndmx
      do while(masks(ndmx).eq.1.and.ndmx.le.nsmx)
       write(6,*) ndmx,masks(ndmx)
       ndmx=ndmx+1
      enddo
      ndmx=ndmx-1

      write(6,*)ndmn,ndmx

      if(maskl(lmx).ne.1) stop 'do not know how to deal with this '

      natd=(lmx+1)**2
      ind=(ndmn-1)*natd+1
      do i=ndmn,ndmx
       do j=0,lmx
        ind1=ind+2*j
        read(10,'(11e12.4)',end=100)(x(k),k=ind,ind1)
        ind=ind1+1
       Enddo
      Enddo

      goto 200

 100  stop 'incompatible sph header'

 200  continue
      

      end

