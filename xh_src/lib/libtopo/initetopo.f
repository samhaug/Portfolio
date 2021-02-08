      subroutine initetopo(itop,dg)

      parameter(NLA=2160)
      parameter(NLO=4320)
      integer*2 itop(NLO,NLA)

c     read etopo5
      write(6,*) 'initialising etopo5 ......'

      open(12,file='/home/hendrik1/etopo5/data/etopo5.earth.bin',
     1     form='unformatted',status='old')
      do j=1,NLA
       read(12) (itop(i,j),i=1,NLO)
      enddo
      close(12)

      dg=1./12.

      write(6,*) 'done!'

      end


