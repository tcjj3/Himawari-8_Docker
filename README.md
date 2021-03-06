# Himawari-8_Docker
Docker for Himawari-8 decoding, using [**sam210723/himawari-rx**](https://github.com/sam210723/himawari-rx) and [**tcjj3/himawari-rx_auto_scripts**](https://github.com/tcjj3/himawari-rx_auto_scripts).


## Before Start:

Here is an example for TBS5520SE:
<br>
<br>


**1. Install:**
<br>
<br>

For the newest systems:
<br>
**Install driver and "firmware":**
```
[tcjj3@debian]$ sudo apt update
[tcjj3@debian]$ sudo apt install -y wget ca-certificates git patchutils gcc kmod make libproc-processtable-perl libelf-dev
[tcjj3@debian]$ mkdir tbsdriver
[tcjj3@debian]$ cd tbsdriver
[tcjj3@debian]$ wget http://www.tbsdtv.com/download/document/linux/media_build-2021-05-08.tar.bz2
[tcjj3@debian]$ tar jxf media_build-2021-05-08.tar.bz2
[tcjj3@debian]$ cd media_build
[tcjj3@debian]$ sudo rm -rf /lib/modules/`uname -r`/kernel/drivers/media/
[tcjj3@debian]$ sudo ./install.sh
[tcjj3@debian]$ cd ../..
[tcjj3@debian]$ sudo reboot
```
If `install.sh` has errors like "`ERROR: "__devm_regmap_init_sccb" [/home/tcjj3/tbsdriver_new/media_build/v4l/ov772x.ko] undefined`", just use the following commands instead (these commands are from this comment: [https://github.com/tbsdtv/linux_media/issues/209#issuecomment-780035850](https://github.com/tbsdtv/linux_media/issues/209#issuecomment-780035850)):
```
[tcjj3@debian]$ sudo apt update
[tcjj3@debian]$ sudo apt install -y wget ca-certificates git patchutils gcc kmod make libproc-processtable-perl libelf-dev
[tcjj3@debian]$ mkdir tbsdriver
[tcjj3@debian]$ cd tbsdriver
[tcjj3@debian]$ wget http://www.tbsdtv.com/download/document/linux/media_build-2021-05-08.tar.bz2
[tcjj3@debian]$ tar jxf media_build-2021-05-08.tar.bz2
[tcjj3@debian]$ cd media_build
[tcjj3@debian]$ sudo rm -rf /lib/modules/`uname -r`/kernel/drivers/media/
[tcjj3@debian]$ sed -i '/VIDEO_OV772X/d' ./v4l/versions.txt && sed -i '/9.255.255/a VIDEO_OV772X' ./v4l/versions.txt
[tcjj3@debian]$ sed -i -r 's/(^CONFIG.*_RC.*=)./\1n/g' v4l/.config
[tcjj3@debian]$ sudo ./install.sh
[tcjj3@debian]$ cd ../..
[tcjj3@debian]$ sudo reboot
```
<br>

For some old systems:
<br>
**(1) Install driver:**
```
[tcjj3@debian]$ sudo apt update
[tcjj3@debian]$ sudo apt install -y wget ca-certificates git patchutils gcc kmod make libproc-processtable-perl libelf-dev
[tcjj3@debian]$ mkdir tbsdriver
[tcjj3@debian]$ cd tbsdriver
[tcjj3@debian]$ git clone https://github.com/tbsdtv/media_build.git
[tcjj3@debian]$ git clone --depth=1 https://github.com/tbsdtv/linux_media.git -b latest ./media
[tcjj3@debian]$ cd media_build
[tcjj3@debian]$ make dir DIR=../media
[tcjj3@debian]$ make distclean
[tcjj3@debian]$ make -j4
[tcjj3@debian]$ sudo make install
[tcjj3@debian]$ cd ..
```
If `make -j4` has errors like "`ERROR: "__devm_regmap_init_sccb" [/home/tcjj3/tbsdriver/media_build/v4l/ov9650.ko] undefined`" and "`ERROR: "__devm_regmap_init_sccb" [/home/tcjj3/tbsdriver/media_build/v4l/ov772x.ko] undefined`", just use the following commands instead (these commands are from this comment: [https://github.com/tbsdtv/linux_media/issues/209#issuecomment-780035850](https://github.com/tbsdtv/linux_media/issues/209#issuecomment-780035850)):
```
[tcjj3@debian]$ sudo apt update
[tcjj3@debian]$ sudo apt install -y wget ca-certificates git patchutils gcc kmod make libproc-processtable-perl libelf-dev
[tcjj3@debian]$ mkdir tbsdriver
[tcjj3@debian]$ cd tbsdriver
[tcjj3@debian]$ git clone https://github.com/tbsdtv/media_build.git
[tcjj3@debian]$ git clone --depth=1 https://github.com/tbsdtv/linux_media.git -b latest ./media
[tcjj3@debian]$ cd media_build
[tcjj3@debian]$ make dir DIR=../media
[tcjj3@debian]$ sed -i '/VIDEO_OV9650/d' ./v4l/versions.txt && sed -i '/9.255.255/a VIDEO_OV9650' ./v4l/versions.txt
[tcjj3@debian]$ sed -i '/VIDEO_OV772X/d' ./v4l/versions.txt && sed -i '/9.255.255/a VIDEO_OV772X' ./v4l/versions.txt
[tcjj3@debian]$ sed -i -r 's/(^CONFIG.*_RC.*=)./\1n/g' v4l/.config
[tcjj3@debian]$ make distclean
[tcjj3@debian]$ make -j4
[tcjj3@debian]$ sudo make install
[tcjj3@debian]$ cd ..
```

**(2) Install "firmware":**
```
[tcjj3@debian]$ wget http://www.tbsdtv.com/download/document/linux/tbs-tuner-firmwares_v1.0.tar.bz2
[tcjj3@debian]$ sudo tar jxf tbs-tuner-firmwares_v1.0.tar.bz2 -C /lib/firmware/
[tcjj3@debian]$ cd ..
[tcjj3@debian]$ sudo reboot
```
<br>
<br>


**2. Create link files:**
<br>
**Create link files for DVB interfaces to "lock the S signal":**
```
[tcjj3@debian]$ sudo ln -s demux0 /dev/dvb/adapter0/demux1
[tcjj3@debian]$ sudo ln -s dvr0 /dev/dvb/adapter0/dvr1
[tcjj3@debian]$ sudo ln -s net0 /dev/dvb/adapter0/net1
```
<br>
<br>



## Start:

1. Install docker-ce:
```
[tcjj3@debian]$ sudo apt install -y curl
[tcjj3@debian]$ curl -fsSL get.docker.com -o get-docker.sh
[tcjj3@debian]$ sudo sh get-docker.sh
[tcjj3@debian]$ sudo groupadd docker
[tcjj3@debian]$ sudo usermod -aG docker $USER
[tcjj3@debian]$ sudo systemctl enable docker && sudo systemctl start docker
```

2. Run Himawari-8_Docker:
```
[tcjj3@debian]$ sudo docker volume create himawari-rx
[tcjj3@debian]$ sudo docker volume create himawari-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --privileged \
 --restart always \
 --name=himawari-8 \
 --device /dev/bus/usb \
 -v /dev/dvb:/dev/dvb \
 -p 5006:5006 \
 -p 9999:9999 \
 -v himawari-rx_config:/opt/himawari-rx_config \
 -v himawari-rx:/usr/local/bin/himawari-rx/src/received \
 tcjj3/himawari-8_docker:latest
```
   Or using other ports (The following example is forwarded local ports 5007 & 9998 to docker container's ports 5006 & 9999):
```
[tcjj3@debian]$ sudo docker volume create himawari-rx
[tcjj3@debian]$ sudo docker volume create himawari-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --privileged \
 --restart always \
 --name=himawari-8 \
 --device /dev/bus/usb \
 -v /dev/dvb:/dev/dvb \
 -p 5007:5006 \
 -p 9998:9999 \
 -v himawari-rx_config:/opt/himawari-rx_config \
 -v himawari-rx:/usr/local/bin/himawari-rx/src/received \
 tcjj3/himawari-8_docker:latest
```
<br>

   If you want to choose device or frontend, just add a "`DEVICE`" environment variable in it (if it is empty, the script will use `adapter0` and use the `frontend` automatically), it is like "`-d name`" or "`--device-name name`" for `TSDuck`. (Use `tsp -I dvb --help` command for help)
```
  -d name
  --device-name name
      Specify the DVB receiver device name, /dev/dvb/adapterA[:F[:M[:V]]] where
      A = adapter number, F = frontend number (default: 0), M = demux number
      (default: 0), V = dvr number (default: 0). By default, the first receiver
      device is used. Use the tslsdvb utility to list all DVB devices.
```
   For example (for TBS5520SE Device [ adapter 0 frontend 1, is for DVB-S2 ]):
```
[tcjj3@debian]$ sudo docker volume create himawari-rx
[tcjj3@debian]$ sudo docker volume create himawari-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --privileged \
 --restart always \
 --name=himawari-8 \
 --device /dev/bus/usb \
 -v /dev/dvb:/dev/dvb \
 -e DEVICE="/dev/dvb/adapter0:1" \
 -p 5007:5006 \
 -p 9998:9999 \
 -v himawari-rx_config:/opt/himawari-rx_config \
 -v himawari-rx:/usr/local/bin/himawari-rx/src/received \
 tcjj3/himawari-8_docker:latest
```
<br>

   If you want to customize the `times` of generate animation pictures, just add a "`CONVERT_TIMES`" environment variable in it (default `CONVERT_TIMES` value is "`0000`"). The `times` are UTC times, included `hours` and `minutes`. Each `time` connnected with "`,`", like "`2200,0000`".
   <br>
   For example:
```
[tcjj3@debian]$ sudo docker volume create himawari-rx
[tcjj3@debian]$ sudo docker volume create himawari-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --privileged \
 --restart always \
 --name=himawari-8 \
 --device /dev/bus/usb \
 -v /dev/dvb:/dev/dvb \
 -e CONVERT_TIMES=2200,0000 \
 -p 5007:5006 \
 -p 9998:9999 \
 -v himawari-rx_config:/opt/himawari-rx_config \
 -v himawari-rx:/usr/local/bin/himawari-rx/src/received \
 tcjj3/himawari-8_docker:latest
```
<br>
<br>


## Get Files

### Local Disk

```
[tcjj3@debian]$ cd /var/lib/docker/volumes/himawari-rx/_data
```

### Via HTTP

1. Website (Default port):
```
http://[Your IP]:5006
```
   Or the other port (Using in the above "Start" example):
```
http://[Your IP]:5007
```

2. Filebrowser (Default port):
```
http://[Your IP]:9999
```
   Or the other port (Using in the above "Start" example):
```
http://[Your IP]:9998
```

