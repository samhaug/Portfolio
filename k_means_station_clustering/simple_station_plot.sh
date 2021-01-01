#!/bin/bash

if [ $# != 1 ]; then
   echo "USAGE: ./simple_station_plot.sh region_number"
   echo "region_number: integer determining the region:"
   echo " 1: Conterminous US"
   echo " 2: Alaska"
   exit
fi

file=station_map

if [ $1 == 1 ]; then
   scale=L-100/35/33/45/7i
   region=-130/-70/24/52
elif [ $1 == 2 ]; then
   scale=A-150/65/7i
   region=-180/-130/55/75
else
   echo "region number must be 1 or 2"
   exit
fi
   
colors=(red blue green orange yellow pink purple red blue green)

gmt pscoast -R$region -J$scale -B10 -Dc -Glightgrey -A10000 -W0.25p -K > $file.ps

j=0
for i in station_subarray*txt; do 
   echo ${colors[j]}
   awk '{print $2,$1}' $i | gmt psxy -R$region -J$scale \
             -Si0.2c -G${colors[j]} -K -O >> $file.ps
   j=$((j+1))
done

evince $file.ps
rm stations
rm gmt.history

