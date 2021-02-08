      character*40 function gtawrd(string,k)
      character*(*) string

      lstr=len(string)

      ig=0


      do while((k.le.0.or.string(k:k).eq.' ').and.k.lt.lstr)
        k=k+1
      enddo

      k1=k


      do while(k1.lt.lstr.and.string(k1:k1).ne.' ')
        k1=k1+1
      enddo

      if(k1.eq.lstr.and.string(k1:k1).ne.' ') k1=k1+1

      if(k1.eq.k) then
        gtawrd=' '
      else




        gtawrd=string(k:k1-1)


      endif



      k=k1


      return
      end
