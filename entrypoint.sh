#!/bin/sh


cat << EOF > /etc/caddy/Caddyfile
0.0.0.0:5006 {
    root /usr/local/bin/himawari-rx/src/received
    tls off
    gzip
    browse
}
EOF


/usr/local/bin/caddy --conf=/etc/caddy/Caddyfile &
/usr/local/bin/filebrowser -r /usr/local/bin/himawari-rx/src/received -p 9999 -a 0.0.0.0 &

cd /usr/local/bin/himawari-rx/src
#./start.sh
./himawari-rx__auto.sh &
./time_monitor_to_terminate_TSDuck.sh





