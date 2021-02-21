#!/bin/sh





/etc/init.d/cron restart







cat << EOF > /etc/caddy/Caddyfile
0.0.0.0:5006 {
    root /usr/local/bin/himawari-rx/src/received
    tls off
    gzip
    browse
}
EOF










cd /usr/local/bin/himawari-rx/src




/usr/local/bin/caddy --conf=/etc/caddy/Caddyfile &
/usr/local/bin/filebrowser -r /usr/local/bin/himawari-rx/src/received -p 9999 -a 0.0.0.0 &




rm /tmp/time_monitor_to_terminate_TSDuck.lock
rm /tmp/exit_himawari_rx.txt
rm /tmp/udp.dump
rm /tmp/udp_fordecode.dump
rm -r /tmp/resize_*




#./start.sh
./himawari-rx__auto.sh &
./time_monitor_to_terminate_TSDuck.sh








