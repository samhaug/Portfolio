c-------------------------------------------------------------------
c-------- Programmed by J. H. Woodhouse ----------------------------
c-------------------------------------------------------------------
      subroutine ffstat(lufl,lent,iftyp,isize)
      include 'openfile.h'
        call cfstat(jchn(lufl),isize,iftyp,ierrno)
c        if(ierrno.ne.0) call check('cfstat on ffstat')
        lent=jrecl(lufl)
        return
      end
