import numpy as np
from matplotlib import pyplot as plt
from glob import glob

'''
Simple script to plot subarrays in different colors
'''

fig,ax = plt.subplots()
for i in glob('station_subarray*.txt'):
  data = np.genfromtxt(i)[:,0:2]
  ax.scatter(data[:,1],data[:,0])
plt.show()

