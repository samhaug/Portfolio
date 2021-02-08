      character*(*) function cat3s(s1,s2,s3,lcat3s)
      character*(*) s1,s2,s3
      if(len(s1)+len(s2)+len(s3).gt.len(cat3s) )
     1     stop 'cat3s: buffer would overflow'
      k=0
      do i=1,len(s1)
        k=k+1
        cat3s(k:k)=s1(i:i)
      enddo
      do i=1,len(s2)
        k=k+1
        cat3s(k:k)=s2(i:i)
      enddo
      do i=1,len(s3)
        k=k+1
        cat3s(k:k)=s3(i:i)
      enddo
      lcat3s=k
      do i=k+1,len(cat3s)
        cat3s(i:i)=' '
      enddo
      return
      end

