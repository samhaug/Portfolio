      subroutine initcrust(crthck)

      parameter(NLA=36)
      parameter(NLO=72)
      dimension crthck(NLO,NLA)

c     read crustal thickness from crust5.1

      open(12,file='/home/hendrik1/crust5.1/crust5.1_thck.bin',
     1     form='unformatted',status='old')
      do j=1,NLA
       read(12) (crthck(i,j),i=1,NLO)
      enddo
      close(12)

      end


