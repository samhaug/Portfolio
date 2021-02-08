c-------------------------------------------------------------
      integer*4 function icrate(hz)
      integer*2 jrate(2),is1,is2
      integer*2 iabs2
      integer*4 krate
      equivalence (krate,jrate(1),is1),(jrate(2),is2)
      if(hz.le.0.) then
        icrate=0
      else
        rhz=1./hz
        if(hz.gt.rhz) then
          targ0=hz
          isign=1
        else
          targ0=rhz
          isign=-1
        endif
        mtarg=1
        if(targ0.gt.30000.) then
          targ0=targ0/60.
          mtarg=mtarg*60
        endif
        if(targ0.gt.30000.) then
          targ0=targ0/60.
          mtarg=mtarg*60
        endif
       
        imult=0
   10   imult=imult+1
        if(imult.gt.100) then
          write(6,'(''icrate:'',1pe13.7)') hz
          pause 'icrate: unable to code rate'
        endif
        targ=targ0*imult
        itarg=targ+.5
        ttarg=itarg
        test=abs(targ-ttarg)/targ
        if(test.gt.6.0e-4) goto 10

        jrate(1)=itarg*isign
        jrate(2)=-imult*isign
        if(iabs2(jrate(2)).eq.1) jrate(2)=isign*mtarg
        if(jrate(1).eq.-1) jrate(1)=1
        if(jrate(2).eq.-1) jrate(2)=1

        if(is1.gt.0) then
          hz1=float(is1)
        else
          hz1=1.0/float(-is1)
        endif
        if(is2.gt.0) then
          hz1=hz1*float(is2)
        else
          hz1=hz1/float(-is2)
        endif
        test=abs(hz-hz1)/hz
        if(test.gt.6.0e-4) then
          write(6,*) 'icrate: hz,targ0,is1,is2,test:',hz,targ0,is1,is2,test
          pause 'icrate: error 1'
        endif

        icrate=krate
      endif
      return
      end
