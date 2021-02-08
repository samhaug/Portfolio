c-----------------------------------------------------------
        complex function cratio(om,ntop,nbot,at,ab,a0,ipzco,iandi,rate)
        dimension at(*),ab(*)
        complex ctop,cbot,zm1
        include 'seedparam.h'
        data tpi/6.2831853/

        hz=om/tpi
        if(ipzco.eq.STRPZS) then
          if(iandi.eq.STRFTA) then   
            ctop=cmplx(a0,0.0)
            k=1
            do j=1,ntop
              ctop=ctop*cmplx(-at(k),om-at(k+1))
              k=k+2
            enddo
            cbot=(1.0,0.0)
            k=1
            do j=1,nbot
              cbot=cbot*cmplx(-ab(k),om-ab(k+1))
              k=k+2
            enddo
          else if(iandi.eq.STRFTB) then
            ctop=cmplx(a0,0.0)
            k=1
            do j=1,ntop
              ctop=ctop*cmplx(-at(k),hz-at(k+1))
              k=k+2
            enddo
            cbot=(1.0,0.0)
            k=1
            do j=1,nbot
              cbot=cbot*cmplx(-ab(k),hz-ab(k+1))
              k=k+2
            enddo
          else if(iandi.eq.STRFTD) then
c           zm1=cexp(cmplx(0.0,-om/rate))
            z=cexp(cmplx(0.0,om/rate))
            ctop=cmplx(a0,0.0)
            k=1
            do j=1,ntop
c              ctop=ctop*(1.0-cmplx(at(k),at(k+1))*zm1)
               ctop=ctop*(z-cmplx(at(k),at(k+1)))
              k=k+2
            enddo
            cbot=(1.0,0.0)
            k=1
            do j=1,nbot
c             cbot=cbot*(1.0-cmplx(ab(k),ab(k+1))*zm1)
              cbot=cbot*(z-cmplx(ab(k),ab(k+1)))
              k=k+2
            enddo
          endif
        else if(ipzco.eq.STRCOF) then
          if(iandi.eq.STRFTA) then
            if(ntop.ne.0) then
              ctop=(0.0,0.0)
              k=ntop
              do j=1,ntop
                ctop=cmplx(0.0,om)*ctop+cmplx(at(k),0.0)
                k=k-1
              enddo
            else
              ctop=(1.0,0.0)
            endif
            if(nbot.ne.0) then
              cbot=(0.0,0.0)
              k=nbot
              do j=1,nbot
                cbot=cmplx(0.,om)*cbot+cmplx(ab(k),0.)
                k=k-1
              enddo
            else
              cbot=(1.0,0.0)
            endif
          else if(iandi.eq.STRFTB) then   
            if(ntop.ne.0) then
              ctop=(0.,0.)
              k=ntop
              do j=1,ntop
                ctop=cmplx(0.,hz)*ctop+cmplx(at(k),0.)
                k=k-1
              enddo
            else
              ctop=(1.0,0.0)
            endif
            if(nbot.ne.0) then
              cbot=(0.,0.)
              k=nbot
              do j=1,nbot
                cbot=cmplx(0.,hz)*cbot+cmplx(ab(k),0.)
                k=k-1
              enddo
            else
              cbot=(1.0,0.0)
            endif
          else if(iandi.eq.STRFTD) then  
            zm1=cexp(cmplx(0.,-om/rate))

            if(ntop.ne.0) then
              ctop=(0.0,0.0)
              k=ntop
              do j=1,ntop
                ctop=zm1*ctop+cmplx(at(k),0.)
                k=k-1
              enddo
            else 
              ctop=(1.0,0.0)
            endif
            if(nbot.ne.0) then
              cbot=(0.0,0.0)
              k=nbot
              do j=1,nbot
                cbot=zm1*cbot+cmplx(ab(k),0.)
                k=k-1
              enddo
              cbot=(1.0,0.0)-zm1*cbot
            else
              cbot=(1.0,0.0)
            endif
          endif
        endif
        cratio=ctop/cbot
        return
        end
