#!/bin/sh






stringLength() {
len=`echo "$1" | awk '{printf("%d", length($0))}'`
echo "$len"
}








if [ ! -z "$CONVERT_TIMES" ]; then
/opt/set_convert_times.sh "$CONVERT_TIMES" > /dev/null 2>&1
fi


/etc/init.d/cron restart > /dev/null 2>&1











cat << EOF > /etc/caddy/Caddyfile
0.0.0.0:5006 {
    root /usr/local/bin/himawari-rx/src/received
    tls off
    gzip
    browse
}
EOF












# Path to save "filebrowser.db"
#cd /usr/local/bin/himawari-rx/src > /dev/null 2>&1
cd /opt/himawari-rx_config > /dev/null 2>&1






/usr/local/bin/caddy --conf=/etc/caddy/Caddyfile > /dev/null 2>&1 &
/usr/local/bin/filebrowser -r /usr/local/bin/himawari-rx/src/received -p 9999 -a 0.0.0.0 > /dev/null 2>&1 &






rm /tmp/time_monitor_to_terminate_TSDuck.lock > /dev/null 2>&1
rm /tmp/exit_himawari_rx.txt > /dev/null 2>&1
rm /tmp/udp.dump > /dev/null 2>&1
rm /tmp/udp_fordecode.dump > /dev/null 2>&1
rm -r /tmp/resize_* > /dev/null 2>&1







#[ -z "$DEVICE" ] && DEVICE="/dev/dvb/adapter0" > /dev/null 2>&1


cd /usr/local/bin/himawari-rx/src > /dev/null 2>&1

#./start.sh "$DEVICE" > /dev/null 2>&1
./himawari-rx__auto.sh "$DEVICE" > /dev/null 2>&1 &
./time_monitor_to_terminate_TSDuck.sh > /dev/null 2>&1












