#!/bin/sh







if [ ! -z "$CONVERT_TIMES" ]; then
rm -rf /tmp/crontab
touch /tmp/crontab
rm -rf /tmp/crontab_
touch /tmp/crontab_
echo "$CONVERT_TIMES" | sed "s/,/\n/gi" | while read LINE; do
if [ ! -z "$LINE" ]; then
len=`stringLength "$LINE"`
index=`expr $len - 2`
Hours="${LINE:0:$index}"
Minutes="${LINE:$index:2}"

[ -z "$Hours" ] && Hours="23"
[ -z "$Minutes" ] && Minutes="59"

if [ "$Minutes" -eq "00" ] || [ "$Minutes" -eq "0" ]; then
Hours=`expr $Hours - 1`
len_Hours=`stringLength "$Hours"`
[ "$len_Hours" -lt 2 ] && Hours="0$Hours"
Minutes="59"
else
Minutes="${Minutes:0:1}9"
fi
len_Minutes=`stringLength "$Minutes"`
[ "$len_Minutes" -lt 2 ] && Minutes="0$Minutes"

echo "$Minutes $Hours * * * /opt/convert.sh &" >> /tmp/crontab_
fi
done
cat /tmp/crontab_ | sort -u >> /tmp/crontab
crontab /tmp/crontab
rm -rf /tmp/crontab
rm -rf /tmp/crontab_
fi


/etc/init.d/cron restart











cat << EOF > /etc/caddy/Caddyfile
0.0.0.0:5006 {
    root /usr/local/bin/himawari-rx/src/received
    tls off
    gzip
    browse
}
EOF












# Path to save "filebrowser.db"
#cd /usr/local/bin/himawari-rx/src
cd /opt/himawari-rx_config






/usr/local/bin/caddy --conf=/etc/caddy/Caddyfile &
/usr/local/bin/filebrowser -r /usr/local/bin/himawari-rx/src/received -p 9999 -a 0.0.0.0 &






rm /tmp/time_monitor_to_terminate_TSDuck.lock
rm /tmp/exit_himawari_rx.txt
rm /tmp/udp.dump
rm /tmp/udp_fordecode.dump
rm -r /tmp/resize_*







#[ -z "$DEVICE" ] && DEVICE="/dev/dvb/adapter0"


cd /usr/local/bin/himawari-rx/src

#./start.sh "$DEVICE"
./himawari-rx__auto.sh "$DEVICE" &
./time_monitor_to_terminate_TSDuck.sh












