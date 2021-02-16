# Himawari-8_Docker
Docker for Himawari-8 decoding, using himawari-rx and himawari-rx_auto_scripts.

## Useage:
```
docker run -d -i -t \
 --restart always \
 --name=himawari-8 \
 --device /dev/dvb \
 -p 5006:5006 \
 -p 9999:9999 \
 -v himawari-rx:/usr/local/bin/himawari-rx/src/received \
 tcjj3/himawari-8_docker:latest
```
