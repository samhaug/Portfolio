c--------------------------------------------------------
      subroutine bffibs4(lu,ifbin,ibuf,nbyts,j,m,irec)
      dimension ibuf(*)
      write(6,*) 'in bffibs: ifbin= ', ifbin
      write(6,*) 'in bffibs: ibuf= ', ibuf(1)
      write(6,*) 'in bffibs: nbyts= ', nbuyts
      write(6,*) 'in bffibs: j= ', j
      write(6,*) 'in bffibs: m= ', m
      write(6,*) 'in bffibs: irec= ', irec
      call bffi(lu,ifbin,ibuf,nbyts,j,m,irec)
      write(6,*) 'in bffibs: ifbin= ', ifbin
      write(6,*) 'in bffibs: ibuf= ', ibuf(1)
      write(6,*) 'in bffibs: nbyts= ', nbuyts
      write(6,*) 'in bffibs: j= ', j
      write(6,*) 'in bffibs: m= ', m
      write(6,*) 'in bffibs: irec= ', irec
      if(j.ne.2) return
      call byswap4(ibuf,(m+3)/4)
      write(6,*) 'in bffibs: ifbin= ', ifbin
      write(6,*) 'in bffibs: ibuf= ', ibuf(1)
      write(6,*) 'in bffibs: nbyts= ', nbuyts
      write(6,*) 'in bffibs: j= ', j
      write(6,*) 'in bffibs: m= ', m
      write(6,*) 'in bffibs: irec= ', irec
      return
      end

