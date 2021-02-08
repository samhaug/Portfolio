
      function jsecna(iname)
      character*20 name
      character*6 date
      dimension iname(*)
      logical digits
      write(name,"(5a4)") (iname(i),i=1,5)
      if(name(1:5).eq.'DAY80') then
        i1=7
      else if(name(1:5).eq.'DAY77') then
        i1=7
      else if(name(1:4).eq.'GSNS') then
        i1=6
      else if(name(1:1).eq.'H') then
        i1=6
      endif
      date=name(i1:i1+5)
      if(digits(date)) then
        read(date,"(3i2)") imo,ida,iyr
        call datsec(imo,ida,iyr,0,0,0,jsecna)
      else
        jsecna=-2147472000
      endif
      return
      end
