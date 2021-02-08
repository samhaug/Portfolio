c-----------------------------------------------------------
        function cratiod(om,ntop,nbot,at,ab,a0,ipzco,iandi,rate)
        dimension at(*),ab(*)
        complex ctop,cbot,z,zm1,cfac,ctopd,cbotd,zm1d
        include 'seedparam.h'
        data tpi/6.2831853/
        cratiod=0.
        hz=om/tpi
        if(ipzco.eq.STRPZS) then
          if(iandi.eq.STRFTA) then   
            k=1
            do j=1,ntop
              cfac=cmplx(-at(k),om-at(k+1))
              if(at(k).ne.0..or.at(k+1).ne.0.)
     1           cratiod=cratiod-real( (1.0,0.0)/cfac  )
              k=k+2
            enddo
            k=1
            do j=1,nbot
              cfac=cmplx(-ab(k),om-ab(k+1))
              if(ab(k).ne.0..or.ab(k+1).ne.0.)
     1           cratiod=cratiod+real( (1.0,0.0)/cfac  )
              k=k+2
            enddo
          else if(iandi.eq.STRFTB) then
            k=1
            do j=1,ntop
              cfac=cmplx(-at(k),hz-at(k+1))
              if(at(k).ne.0..or.at(k+1).ne.0.)
     1           cratiod=cratiod-real( (1.0,0.0)/cfac  )/tpi
              k=k+2
            enddo
            k=1
            do j=1,nbot
              cfac=cmplx(-ab(k),hz-ab(k+1))
              if(ab(k).ne.0..or.ab(k+1).ne.0.)
     1           cratiod=cratiod+real( (1.0,0.0)/cfac  )/tpi
              k=k+2
            enddo
          else if(iandi.eq.STRFTD) then
c           zm1=cexp(cmplx(0.0,-om/rate))
c           zm1d=-zm1/rate
            z=cexp(cmplx(0.0,om/rate))
            k=1
            do j=1,ntop
c             cfac=(1.0-cmplx(at(k),at(k+1))*zm1)
              cfac=(z-cmplx(at(k),at(k+1)))
c             cratiod=cratiod+real( cmplx(at(k),at(k+1))*zm1d/cfac )
              cratiod=cratiod-real(z/cfac)/rate
              k=k+2
            enddo
            k=1
            do j=1,nbot
c             cfac=(1.0-cmplx(ab(k),ab(k+1))*zm1)
              cfac=(z-cmplx(ab(k),ab(k+1)))
c             cratiod=cratiod-real( cmplx(ab(k),ab(k+1))*zm1d/cfac )
              cratiod=cratiod+real(z/cfac)/rate
              k=k+2
            enddo
          endif
        else if(ipzco.eq.STRCOF) then
          if(iandi.eq.STRFTA) then
            if(ntop.ne.0) then
              ctop=(0.0,0.0)
              ctopd=(0.0,0.0)
              k=ntop
              do j=1,ntop
                ctopd=ctop+cmplx(0.0,om)*ctopd
                ctop=cmplx(0.0,om)*ctop+cmplx(at(k),0.0)
                k=k-1
              enddo
            else
              ctop=(1.0,0.0)
              ctopd=(0.0,0.0)
            endif
            if(nbot.ne.0) then
              cbot=(0.0,0.0)
              cbotd=(0.0,0.0)
              k=nbot
              do j=1,nbot
                cbotd=cbot+cmplx(0.0,om)*cbotd
                cbot=cmplx(0.,om)*cbot+cmplx(ab(k),0.)
                k=k-1
              enddo
            else
              cbot=(1.0,0.0)
              cbotd=(0.0,0.0)
            endif
            cratiod=-real(ctopd/ctop)+real(cbotd/cbot)
          else if(iandi.eq.STRFTB) then   
            if(ntop.ne.0) then
              ctop=(0.,0.)
              ctopd=(0.0,0.0)
              k=ntop
              do j=1,ntop
                ctopd=ctop+cmplx(0.0,hz)*ctopd
                ctop=cmplx(0.,hz)*ctop+cmplx(at(k),0.)
                k=k-1
              enddo
            else
              ctop=(1.0,0.0)
              ctopd=(0.0,0.0)
            endif
            if(nbot.ne.0) then
              cbot=(0.,0.)
              cbotd=(0.0,0.0)
              k=nbot
              do j=1,nbot
                cbotd=cbot+cmplx(0.0,hz)*cbotd
                cbot=cmplx(0.,hz)*cbot+cmplx(ab(k),0.)
                k=k-1
              enddo
            else
              cbot=(1.0,0.0)
              cbotd=(0.0,0.0)
            endif
            cratiod=(-real(ctopd/ctop)+real(cbotd/cbot))/tpi
          else if(iandi.eq.STRFTD) then  
            zm1=cexp(cmplx(0.,-om/rate))
            zm1d=-zm1/rate
            if(ntop.ne.0) then
              ctop=(0.0,0.0)
              ctopd=(0.,0.)
              k=ntop
              do j=1,ntop
                ctopd=zm1*ctopd+ctop*zm1d
                ctop=zm1*ctop+cmplx(at(k),0.)
                k=k-1
              enddo
            else 
              ctop=(1.0,0.0)
              ctopd=(0.,0.)
            endif
            if(nbot.ne.0) then
              cbot=(0.0,0.0)
              cbotd=(0.,0.)
              k=nbot
              do j=1,nbot
                cbotd=zm1*cbotd+cbot*zm1d
                cbot=zm1*cbot+cmplx(ab(k),0.)
                k=k-1
              enddo
              cbot=(1.0,0.0)-zm1*cbot
              cbotd=-zm1*cbotd-zm1d*cbot
            else
              cbot=(1.0,0.0)
              cbotd=0.0
            endif
            cratiod=-real(ctopd/ctop)+real(cbotd/cbot)
          endif
        endif
        return
        end
