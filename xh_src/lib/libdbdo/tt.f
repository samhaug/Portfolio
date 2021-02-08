      subroutine tt(slat,slon,delta,t,d,p)
      common/phase/evlat,evlon,evdep,itimev(2),evtorg,evdur
     1     ,deltas(400),ttims(400),pvals(400),dddp(400),lphase
      call delaz(evlat,evlon,slat,slon,delta,azep,azst)
      if((delta-deltas(1))*(delta-deltas(lphase)).gt.0.) then
        t=-1.
        d=0.
        p=0.
        return
      endif
      do i=1,lphase-1
        if( (delta-deltas(i))*(delta-deltas(i+1)).le.0.) then
          a1=(delta-deltas(i+1))/(deltas(i)-deltas(i+1))
          a2=(deltas(i)-delta)/(deltas(i)-deltas(i+1))
          t=a1*ttims(i)+a2*ttims(i+1)
          d=a1*dddp(i)+a2*dddp(i+1)
          p=a1*pvals(i)+a2*pvals(i+1)
          goto 10
        endif
      enddo
      t=-1.
      d=0.
      p=0.
   10 continue
      return
      end


