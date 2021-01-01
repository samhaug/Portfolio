#!/home/samhaug/src/anaconda3/bin/python
from sys import argv,exit

if len(argv) != 6:
   print("Usage: python cluster_stations info_file n_clusers stat_min rad_bin corr_coef")
   print("   info_file: 4 column ascii file of format: stla stlo stnm netwk")
   print("              whitespace delimited")
   print("   n_clusters: number of subarrays")
   print("   stat_min: minimum number of stations per subarray")
   print("   rad_bin: radius of subarray bin (degrees)")
   print("   corr_coef (0-1): do not write arrays with lat/lon correleation coefficient above")
   print("                    this number. ")
   exit()

from sklearn.cluster import KMeans
import numpy as np
#import obspy
from obspy.geodetics import gps2dist_azimuth

print(argv[1])
coords = np.genfromtxt(argv[1])[:,0:2]
names = open(argv[1],'r').readlines()
kmeans = KMeans(n_clusters=int(argv[2]))
kmeans.fit(coords)
centers = kmeans.cluster_centers_

freq = argv[1].split('_')[0]

subcount=0
for idx,ii in enumerate(centers):
   x = []
   y = []
   count=0
   for jdx,jj in enumerate(coords):
      dist = gps2dist_azimuth(ii[0],ii[1],jj[0],jj[1])[0]/111195.
      if dist < float(argv[4]):
         x.append(jj[0])
         y.append(jj[1])
         count += 1

   x = np.array(x)
   y = np.array(y)
   corr = np.abs(np.corrcoef(x,y)[0][1])
   if corr >= float(argv[5]):
      continue
   if count > int(argv[3]): 
      subcount += 1
      f = open("{}_subarray_{}.txt".format(freq,str(subcount)),"w")
      print(" {} {}_subarray_{}.txt".format(str(corr),freq,str(subcount)))
      for jdx,jj in enumerate(coords):
         dist = gps2dist_azimuth(ii[0],ii[1],jj[0],jj[1])[0]/111195.
         if dist < float(argv[4]):
            f.write("%8.4f %8.4f %4s %4s\n"%(jj[0],jj[1],names[jdx].split()[2],
                                             names[jdx].split()[3]))
      f.close()

