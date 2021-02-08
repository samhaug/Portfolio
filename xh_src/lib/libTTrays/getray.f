      subroutine getray(phs,mod,hdep,delt,dsstp,npt,rad,del,vel,ds,icall)

c     subroutine calculates ray coordinates in prem
c     output includes step lengths along the ray

      implicit double precision(a-h,o-z)
      character*(*) phs,mod
      character*20 phsout
      dimension rad(*),del(*),vel(*),ds(*)
      common/coefs/cofno(20,8,4),xb(20),xt(20),rnorm

c     to check whether phase file has been read
      character*20 phsold
      common/oldphs/phsold,lphsold

      real dmn,dmx,hdepmx

      if(mod(1:4).ne.'prem') stop 'getray: models other than prem not yet 
     1                             implemented in findrayprem --> findray1)'

      if(icall.ne.999) then
       call readin
       icall=999
      endif

c     distinguish between main phase and diffracted phase
      call dchkdiff(phs,hdep,delt,phsout,ierr)

c     and check whether we can find p for this phase for this
c     distance through extrapolation
      lmd=istlen(mod)
      lph=istlen(phsout)
      if(phsout(1:lph).ne.phsold(1:lph).or.lph.ne.lphsold) then
c      write(6,*) 're-initialising phase file',phsout
       call readphs(mod,lmd,phsout,lph,hdepmx)
       phsold=''
       phsold=phsout(1:lph)
       lphsold=istlen(phsold)
      endif
      call getphsmnmx(sngl(hdep),dmn,dmx)
c     write(6,*) dmn,dmx
      if(delt.gt.dble(dmx)*1.0001) ierr=3
      if(delt.lt.dble(dmn)*.9999) ierr=2

      if(ierr.eq.1) stop 'ierr=1, event depth greater than 725 km'
      if(ierr.eq.2) stop 'ierr=2, epicentral distance is too short to find ray parameter'
      if(ierr.eq.3.and.phsout(2:5).ne.'diff'.and.
     1   phsout(3:6).ne.'diff') stop 'ierr=3, epicentral distance is ' 
     1                             //'too long to find ray parameter'

      if(phsout(2:5).eq.'diff'.or.phsout(3:6).eq.'diff') then
       call getraydiff(phsout,hdep,delt,dsstp,npt,rad,del,vel,ds)
      else if(phsout(1:3).eq.'SKS'.or.phsout(1:3).eq.'PKP') then
       call getraycore(phsout,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)
      else if(phsout(2:3).eq.'KK'.or.phsout(2:2).eq.'K'.or.phsout(3:3).eq.'K') then
       call getraycore(phsout,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)
      else if(phsout(1:3).eq.'ScP'.or.phsout(1:3).eq.'PcS') then
       call getraycore(phsout,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)
      else if(phsout(1:3).eq.'ScS'.or.phsout(1:3).eq.'PcP') then
       call getraycorebounce(phsout,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)
      else if(phsout(2:4).eq.'ScS'.or.phsout(2:4).eq.'PcP') then
       call getraycorebounce(phsout,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)
      else if(phsout(1:2).eq.'SP'.or.phsout(1:2).eq.'PS'
     1        .or.phsout(1:2).eq.'sP') then
       call getraymixed(phsout,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)
      else if(phsout(1:1).eq.'s'.or.phsout(1:1).eq.'p') then
       call getrayup(phsout,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)
      else
       call getraydirect(phsout,mod,hdep,delt,dsstp,npt,rad,del,vel,ds)
      endif

      end

