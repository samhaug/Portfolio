      subroutine evltv(v,irn,ism,theta,phi,result,nresult)
      complex result(3**irn)
      complex v(3**irn,(ism+1)**2)
      double precision d(-20:20,-20:20),thet
      nmxr=3**irn
      if(nresult.lt.nmxr) pause 'insufficient space in evltv'
      thet=theta
      do i=1,nmxr
        result(i)=(0.,0.)
      enddo
      do is=0,ism
        ib=is*(is+1)+1
        call rotmx2(is,is,thet,d(-is,-is),41,41)
        do m=-is,is
          do iel=1,nmxr
            n=0
            itm=iel-1
            do i=1,irn
              ind=-1+mod(itm,3)
              n=n+ind
              itm=itm/3
            enddo
            if(iabs(n).le.is.and.iabs(m).le.is) then
              result(iel)=result(iel)+
     1         v(iel,ib+m)*d(n,m)*cexp(cmplx(0.,float(m)*phi))
            endif
          enddo
        enddo
      enddo
      return
      end
