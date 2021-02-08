      function splhdint(i,j)
c
c   caclulates \int_{-1}^{1} d(splh(i,x))/dx d(splh(j,x))/dx dx
c
c
      parameter (MXKNT=21)
      common/splhprm/spknt(MXKNT),qq0(MXKNT,MXKNT),qq(3,MXKNT,MXKNT)
      ans=0.
      do ii=1,MXKNT-1
c in this interval the i'th  spline is 
c qq0(ii,MXKNT-i) + t qq(1,ii,MXKNT-i) + 
c          + t**2 qq(2,ii,MXKNT-i) + 
c          + t**3 qq(3,ii,MXKNT-i)

        ans=ans+dcubint(spknt(ii+1)-spknt(ii),
     1     qq0(ii,MXKNT-i),qq(1,ii,MXKNT-i),qq(2,ii,MXKNT-i),qq(3,ii,MXKNT-i),
     1     qq0(ii,MXKNT-j),qq(1,ii,MXKNT-j),qq(2,ii,MXKNT-j),qq(3,ii,MXKNT-j))

      enddo
      splhdint=ans
      return
      end


      function dcubint(b,a0,a1,a2,a3,b0,b1,b2,b3)
      dcubint=a3*b**3*b1 + 
     -  (3*a3*b**4*b2)/2. + 
     -  (9*a3*b**5*b3)/5. + 
     -  (a2*b**2*
     -     (6*b1 + 8*b*b2 + 
     -       9*b**2*b3))/6. + 
     -  a1*b*
     -   (b1 + b*(b2 + b*b3))
      end
