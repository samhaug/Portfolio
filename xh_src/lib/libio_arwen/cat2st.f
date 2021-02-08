      character*150 cat2s
      character*70 l1,l2
      character*160 l3
      l1='1234567890123456789012345678901234567890123456789012345678901234567890'
      l2='1234567890123456789012345678901234567890123456789012345678901234567890'

       ll1=10
      l3=cat2s(l1(1:ll1),l2(1:20),ll3)
      write(6,*) l3(1:ll3)
      end



      character*(*) function cat2s0(s1,s2,lcat2s0)
      character*(*) s1,s2
      write(6,*) 'Lengths:',len(s1),len(s2),len(cat2s0)
      if(len(s1)+len(s2).gt.len(cat2s0) )
     1     stop 'cat2s0: buffer wou overflow'
      k=0
      do i=1,len(s1)
        k=k+1
        cat2s0(k:k)=s1(i:i)
      enddo
      do i=1,len(s2)
        k=k+1
        cat2s0(k:k)=s2(i:i)
      enddo
      lcat2s0=k
      if(k.gt.160) stop 'cat2s0: length exceeded'
      do i=k+1,len(cat2s0)
        write(6,'(a)') 'This should not be written'
        cat2s0(k:k)=' '
      enddo
      return
      end

