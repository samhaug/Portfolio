      subroutine complnam(namei,nameo,lnameo)
      character*(*) namei,nameo
      character*80 fgetenv,temp
      lnamei=istlen(namei)
      if(namei(1:2).ne.'~/') then
        nameo=namei
        lnameo=lnamei
      else
        temp=fgetenv('HOME',nbyts)
        nameo=temp(1:nbyts)//namei(2:lnamei)
        lnameo=nbyts+lnamei-1
      endif
      return
      end
