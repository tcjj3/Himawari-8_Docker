#!/bin/bash








stringLength() {
len=`echo "$1" | awk '{printf("%d", length($0))}'`
echo "$len"
}




getFileTime(){
Time="$1"

Hours="$(expr $Time / 100)"
Minutes="$(expr $Time % 100)"

if [ "$Minutes" -gt "59" ]; then
Hours=`expr $Hours + 1`
Minutes="00"
fi
if [ "$Hours" -gt "24" ]; then
Hours="24"
Minutes="00"
fi
len_Hours=`stringLength "$Hours"`
[ "$len_Hours" -lt 2 ] && Hours="0$Hours"
len_Minutes=`stringLength "$Minutes"`
[ "$len_Minutes" -lt 2 ] && Minutes="0$Minutes"
Time="${Hours}${Minutes}"

Minutes_0="$(expr $Minutes % 10)"

Minutes_5="$(expr $Minutes / 10 % 10)"

if [ "$Minutes_5" -ge "5" ]; then
result="$(expr $(expr $Hours + 1) \* 100)"
else
if [ "$Minutes_0" -eq "00" ] || [ "$Minutes_0" -eq "0" ]; then
result="$(expr $Time / 10 \* 10)"
else
result="$(expr $Time / 10 \* 10 + 10)"
fi
fi

[ "$result" -gt "2400" ] && result="2400"

len=`stringLength "$result"`
[ "$len" == "3" ] && result="0$result"
[ "$len" == "2" ] && result="00$result"
[ "$len" == "1" ] && result="000$result"
[ "$len" == "0" ] && result="0000$result"

echo "$result"
}










# Vars
DATE="$1"
[ -z "$DATE" ] && DATE="$(date +%Y%m%d)"

Time="$2"
[ -z "$Time" ] && Time="$(date +%H%M)"
FileTime=`getFileTime "$Time"`

Pic_Dir="/usr/local/bin/himawari-rx/src/received/${DATE}"
Gif_Dir="${Pic_Dir}/IMG_Merged"








# Resize
mkdir -p /tmp/resize_${DATE}_${FileTime}
cd ${Pic_Dir}
for IMG in $(ls *.png);
 do
  #convert -resize "800x800" -strip -quality 75% ${IMG} /tmp/resize_${DATE}_${FileTime}/${IMG};
  convert -resize "1080x1080" -strip -quality 100% ${IMG} /tmp/resize_${DATE}_${FileTime}/${IMG};
 done








# Merged
mkdir -p ${Gif_Dir}

#convert -delay 24 -loop 0 /tmp/resize_${DATE}_${FileTime}/*.png ${Gif_Dir}/0000-${FileTime}_${DATE}.gif
cd /tmp/resize_${DATE}_${FileTime}
python3 /opt/gif.py
mv created_gif.gif $Gif_Dir/0000-${FileTime}_${DATE}.gif
cd ${Pic_Dir}

rm -rf /tmp/resize_${DATE}_${FileTime}










