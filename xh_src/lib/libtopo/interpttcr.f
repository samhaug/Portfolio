      subroutine interpttcr(xla,xlo,p,typ,iinttyp,dt,dh)

      parameter(MXL=80)
      parameter(MXLENY=(MXL+1)**2)
      parameter(MXP=11)
      parameter(MXWORK=(MXL+1)*4)

      character*1 typ

      dimension wk1(MXWORK),wk2(MXWORK),wk3(MXWORK)
      dimension y(MXLENY)
      dimension tp(MXP),tpspln(MXP)

      common/intcrust/lmax,parr(MXP,2),ctt(MXLENY,MXP,2),topo(MXLENY)

c     write(6,*) xla,xlo,p,typ,dt
      if(typ.eq.'s'.or.typ.eq.'S') then
       itp=1
      else if(typ.eq.'p'.or.typ.eq.'P') then
       itp=2
      else
       stop 'interpcr: unknown typ'
      endif

      call ylm(xla,xlo,lmax,y,wk1,wk2,wk3)
      leny=(lmax+1)**2

c     check whether this is for interpolation as function of ray parameter or
c     for empirical corrections (no interpolation as function of p)
      if(iinttyp.eq.1) then
       mxdo=MXP
      else
       mxdo=1
      endif

      do i=1,mxdo
       tp(i)=sdot(leny,ctt(1,i,itp),1,y,1)
c      write(6,*) tp(i),parr(i,itp)
      enddo
     

      if(iinttyp.eq.1) then
c      interpolate to find dt for rayparameter p
c      dt is defined in maps as the tcrust_prem - tcrust_mooney
c      change sign to make dt agree to normal convention for
c      crustal corrections
       call spline(parr(1,itp),tp,MXP,1e32,1e32,tpspln)
       call splint(parr(1,itp),tp,tpspln,MXP,p,dt)
       dt=-dt
c      write(6,*) 'DT =',dt
      else
       dt=-tp(1)
      endif

c     now find dh and add 3 km for difference between 6371 and 
c     solid surface in PREM at 6368. (PREM with ocean is used as
c     reference model in the travel-time measurements)
      dh=sdot(leny,topo,1,y,1)+3.

      end

c ----------------------------------------------------------------
