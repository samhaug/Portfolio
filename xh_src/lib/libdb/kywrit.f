c-------------------------------------------------------------
      subroutine kywrit(iform,lkey,key,string,lstrng)
      include "dblib.h"
      dimension key(*)
      character*(*) string
      character*4 alph
      double precision dub
      integer*4 idub(2)
      character*40 str40
      equivalence (dub,idub)
      equivalence (sng,isng)
      integer*4 space/'    '/
      integer*2 itemp2(2)
      equivalence (itemp,itemp2)

      lstr=len(string)
      if     (iform.eq.VTRAK) then
        call byswap4(key,lkey)
        do i=1,lkey
          write(alph,"(a4)") key(i)
          k1=1+4*(i-1)
          k2=min0(k1+3,lstr)
          if(k2.ge.k1) then
            nch=k2-k1+1
            string(k1:k2)=alph(1:nch)
          else
            goto 20
          endif
        enddo
   20   continue
        call byswap4(key,lkey)
        lstrng=istlen(string)
        return
      else if(iform.eq.VTRIK) then
        k=0



        do i=1,lkey
          write(str40,*) key(i)
          k1=istlen(str40)
          k2=1


          do while(str40(k2:k2).eq.' '.and.k2.lt.k1)
            k2=k2+1
          enddo

          k=k+1

          string(k:k)=' '

          string(k+1:k+k1+1-k2)=str40(k2:k1)
          k=k+k1-k2+1
        enddo

        lstrng=k
        return 
      else if(iform.eq.VTRHK) then
        k=0



        do i=1,lkey
          itemp=key(i)
          write(str40,"(2(z4,1x))") itemp2(1),itemp2(2)

          k=k+1

          string(k:k)=' '
          string(k+1:k+9)=str40(1:9)
          k=k+9
        enddo

        lstrng=k
        return 
      else if(iform.eq.VTRFK) then
        k=0



        do i=1,lkey
          isng=key(i)
          write(str40,*) sng
          k1=istlen(str40)
          k2=1


          do while(str40(k2:k2).eq.' '.and.k2.lt.k1)
            k2=k2+1
          enddo
          k=k+1

          string(k:k)=' '
          string(k+1:k+k1+1-k2)=str40(k2:k1)
          k=k+k1-k2+1
        enddo

        lstrng=k

        return 
      else if(iform.eq.VTRDK) then
        k=0



        do i=1,lkey,2
          idub(1)=key(i)
          idub(2)=key(i+1)
          write(str40,*) dub
          k1=istlen(str40)
          k2=1


          do while(str40(k2:k2).eq.' '.and.k2.lt.k1)
            k2=k2+1
          enddo
          k=k+1

          string(k:k)=' '
          string(k+1:k+k1-k2+1)=str40(k2:k1)
          k=k+k1-k2+1
        enddo

        lstrng=k
        return 
      else




        pause 'kywrit: unknown format'

      endif

      return
      end
