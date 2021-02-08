#!/bin/bash
region=g
scale=Kf180/4.5i
file=station_map

# make map to test gc_spread and az_spread

gmt pscoast -R$region -J$scale -Ba10 -Swhite -G#CC9933 -A10000 -K > $file.ps

gc_spread 30 30 30 90 190 1 | awk '{print $2,$1}' |\
     gmt psxy  -R$region -J$scale -Si0.08c -Gblack -K  -O >> $file.ps
az_spread -10 130 30 90 190 1 | awk '{print $2,$1}' |\
     gmt psxy  -R$region -J$scale -Si0.08c -Gred -K  -O >> $file.ps

evince $file.ps &> /dev/null



