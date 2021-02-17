# Himawari-8_Docker
Docker for Himawari-8 decoding, using himawari-rx and himawari-rx_auto_scripts.


## Before Start:

1. Install driver (example for TBS5520SE):
```
[tcjj3@debian]$ sudo apt-get update
[tcjj3@debian]$ sudo apt install git
[tcjj3@debian]$ sudo mkdir tbsdriver
[tcjj3@debian]$ cd tbsdriver
[tcjj3@debian]$ sudo git clone https://github.com/tbsdtv/media_build.git
[tcjj3@debian]$ sudo git clone --depth=1 https://github.com/tbsdtv/linux_media.git -b latest ./media
[tcjj3@debian]$ cd media_build
[tcjj3@debian]$ sudo ./install.sh
```

2. Install "firmware":
```
[tcjj3@debian]$ sudo wget http://www.tbsdtv.com/download/document/linux/tbs-tuner-firmwares_v1.0.tar.bz2
[tcjj3@debian]$ sudo tar jxvf tbs-tuner-firmwares_v1.0.tar.bz2 -C /lib/firmware/
[tcjj3@debian]$ sudo reboot
```

3. Create link files for DVB interfaces to "lock the S signal":
```
[tcjj3@debian]$ sudo ln -s demux0 /dev/dvb/adapter0/demux1
[tcjj3@debian]$ sudo ln -s dvr0 /dev/dvb/adapter0/dvr1
[tcjj3@debian]$ sudo ln -s net0 /dev/dvb/adapter0/net1
```


## Start:

Install docker-ce:
```
[tcjj3@debian]$ sudo dnf install curl
[tcjj3@debian]$ sudo curl -fsSL get.docker.com -o get-docker.sh
[tcjj3@debian]$ sudo sh get-docker.sh
[tcjj3@debian]$ sudo groupadd docker
[tcjj3@debian]$ sudo usermod -aG docker $USER
[tcjj3@debian]$ sudo systemctl enable docker && sudo systemctl start docker
```

Run Himawari-8_Docker:
```
[tcjj3@debian]$ docker volume create himawari-rx
[tcjj3@debian]$ docker run -d -i -t \
 --privileged \
 --restart always \
 --name=himawari-8 \
 --device /dev/bus/usb \
 -v /dev/dvb:/dev/dvb \
 -p 5006:5006 \
 -p 9999:9999 \
 -v himawari-rx:/usr/local/bin/himawari-rx/src/received \
 tcjj3/himawari-8_docker:latest
```

