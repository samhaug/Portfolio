c ---------------------------------------------------------------

      subroutine initmooncr(ictp)

      parameter (MXTP=360)
      parameter (MXLY=8)
      parameter (MXLAT=90)
      parameter (MXLON=180)
  
      character*80 line
      character*2 ctp
      integer*2 tpmap
      common/cr20/ntp,nlon,nlat,idlon,idlat,ctp(MXTP),vs(MXLY,MXTP),vp(MXLY,MXTP),
     1            rho(MXLY,MXTP),thck(MXLY,MXTP),
     1            tpmap(MXLON,MXLAT)

      character*2 cin(MXLON)
      character*5 dum

      if(ictp.eq.2) then
       open(15,file='/home/seiraid4/hendrikv/crust/crust2.0/CNtype2_key.txt',status='old')
      else if (ictp.eq.5) then
       open(15,file='/home/seiraid4/hendrikv/crust/crust5.1/CNtype_key.txt',status='old')
      else
       stop 'initmooncr:crustal type not known'
      endif

c     read 1st 5 comment lines
      do i=1,5
       read(15,*) line
      enddo

c     read in type models
      i=1
10    read(15,'(a2)') ctp(i)
      if(ctp(i).ne.'$$') then
       read(15,*) (vp(k,i),k=1,MXLY)
       read(15,*) (vs(k,i),k=1,MXLY)
       read(15,*) (rho(k,i),k=1,MXLY)
       read(15,*) (thck(k,i),k=1,MXLY)
       if(i.gt.MXTP) stop'initmooncr: ntp exceeds MXTP'
       i=i+1
       goto 10
      endif
      ntp=i-1

      write(6,*) ntp,' Type models read'

c     open file with type maps
      if(ictp.eq.2) then
       open(15,file='/home/seiraid4/hendrikv/crust/crust2.0/CNtype2.txt',status='old')
       nlon=180
       nlat=90
       idlon=2
       idlat=2
      else if (ictp.eq.5) then
       open(15,file='/home/seiraid4/hendrikv/crust/crust5.1/CNtype.txt',status='old')
       nlon=72
       nlat=36
       idlon=5
       idlat=5
      endif

c     skip 1st the row of longitudes
      read(15,*) line

      ilat=0
35    continue
      if(ictp.eq.2) then
       read(15,40,end=100) lat,(cin(j),j=1,nlon)
40     format(i4,1x,<nlon>(2x,a2,1x))
      else if(ictp.eq.5) then
       read(15,50,end=100) lat,(cin(j),j=1,nlon)
50     format(i3,<nlon>(2x,a2))
      endif

      ilat=ilat+1

      do ilon=1,nlon
       do j=1,ntp
        if(cin(ilon).eq.ctp(j)) then
         tpmap(ilon,ilat)=j
        endif
       enddo
      enddo

      goto 35

100   continue

      end
