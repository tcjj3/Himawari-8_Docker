#!/bin/bash



# Vars
DATE="$(date +%Y%m%d)"
Pic_Dir="/usr/local/bin/himawari-rx/src/received/$DATE"
Gif_Dir="$Pic_Dir/Merged"




# Resize
mkdir -p /tmp/resize_$DATE
cd $Pic_Dir
for IMG in $(ls *.png); do
  convert -resize "1080x1080" -strip -quality 100% $IMG /tmp/resize_$DATE/$IMG;
done




# Merged
mkdir -p $Gif_Dir
convert -delay 24 -loop 0 /tmp/resize_$DATE/*.png $Gif_Dir/0000-2400_$DATE.gif
rm -rf /tmp/resize_$DATE






