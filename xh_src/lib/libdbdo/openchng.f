
c----------------------------------------------------------------

      subroutine openchng(iadgtr,station,netukey
     1     ,locidr,chnr,isubr,khertz,locid,chn,isub,lfmt,iflap)
      character*5 station
      character*2 locidr,locid
      character*3 chn,chnr
      character*28 ckey
      integer*4 key(7)
      equivalence (key,ckey)

c      write(6,*) 'openchng:',station//locid//chn//'->'//chnr,' isubr=',isubr,' isub=',isub


      key(2)=0
      ckey(1:5)=station
      call byswap4(key(2),1)
      key(2)=or(key(2),and(z'00ffffff',netukey))
      call byswap4(key(2),1)
      key(4)=0
      ckey(9:14)=locidr//chnr//char(isubr)
      key(5)=khertz
      call byswap4(key(5),1)
      key(7)=0
      ckey(21:25)=locid//chn
      call byswap4(key(7),1)
      key(7)=or(key(7),and('00ffffff'x,or(ishft(isub,16),lfmt)))
      call byswap4(key(7),1)

      call openchngk(iadgtr,ckey,iflap,ierr)

      return 
      end
