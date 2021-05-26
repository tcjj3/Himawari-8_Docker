FROM debian:buster-slim

LABEL maintainer "Chaojun Tan <https://github.com/tcjj3>"

ADD gif.py /opt/gif.py
ADD convert.sh /opt/convert.sh
ADD set_convert_times.sh /opt/set_convert_times.sh
ADD entrypoint.sh /opt/entrypoint.sh

RUN export DIR_TMP="$(mktemp -d)" \
  && cd $DIR_TMP \
  && chmod +x /opt/*.py \
  && chmod +x /opt/*.sh \
  && sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  && sed -i "s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  && apt-get update \
  || echo "continue..." \
  && apt-get install --no-install-recommends -y curl \
                                                unzip \
                                                procps \
                                                psmisc \
                                                cron \
                                                vim \
                                                tclsh \
                                                pkg-config \
                                                libssl-dev \
                                                build-essential \
                                                ca-certificates \
                                                curl \
                                                cmake \
                                                make \
                                                git \
                                                python3 \
                                                python3-pip \
                                                libpcsclite1 \
                                                wine \
                                                imagemagick \
  && mkdir -p /etc/caddy \
  && mkdir -p /opt/himawari-rx_config \
  && apt install -y g++ dos2unix curl tar zip doxygen graphviz pcscd libpcsclite-dev dpkg-dev python3 default-jdk gcc-multilib libcurl4 libcurl4-openssl-dev || (mkdir -p /usr/share/man/man1 && touch /usr/share/man/man1/java.1.gz.dpkg-tmp && apt install -y g++ dos2unix curl tar zip doxygen graphviz pcscd libpcsclite-dev dpkg-dev python3 default-jdk gcc-multilib libcurl4 libcurl4-openssl-dev) \
  && git clone https://github.com/Haivision/srt \
  && cd srt \
  && chmod +x configure \
  && ./configure \
  && make \
  && make install \
  && ldconfig \
  && cd .. \
  && rm -rf srt \
  && git clone https://github.com/tsduck/tsduck \
  && cd tsduck \
  && make \
  && make install \
  && cd .. \
  && rm -r tsduck \
  && mkdir caddy \
  && if [ "$(dpkg --print-architecture)" = "armhf" ]; then \
        ARCH="arm7"; \
     else \
        ARCH=$(dpkg --print-architecture); \
     fi \
  && mkdir -p ${DIR_TMP}/caddy \
  && curl -L -o ${DIR_TMP}/caddy/caddy.tar.gz https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_${ARCH}.tar.gz \
  && tar -zxf ${DIR_TMP}/caddy/caddy.tar.gz -C ${DIR_TMP}/caddy \
  && mv ${DIR_TMP}/caddy/caddy /usr/local/bin/caddy \
  && curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash \
  && git clone https://github.com/sam210723/himawari-rx /usr/local/bin/himawari-rx \
  && mkdir -p /usr/local/bin/himawari-rx/src/received \
  && pip3 install --no-cache-dir -r /usr/local/bin/himawari-rx/requirements.txt \
  && curl -L https://github.com/tcjj3/himawari-rx_auto_scripts/releases/latest/download/himawari-rx_auto_scripts-Linux.zip -o himawari-rx_auto_scripts-Linux.zip \
  && unzip -o himawari-rx_auto_scripts-Linux.zip -d /usr/local/bin/himawari-rx/src \
  && chmod +x /usr/local/bin/himawari-rx/src/*.sh \
  && chmod +x /usr/local/bin/himawari-rx/src/*.py \
  && chmod +x /usr/local/bin/himawari-rx/src/tools/*.py \
  && pip3 install --no-cache-dir imageio \
  && echo "59 23 * * * /opt/convert.sh &" > ${DIR_TMP}/crontab \
  && crontab ${DIR_TMP}/crontab \
  && rm -rf ${DIR_TMP} \
  && apt-get autoremove --purge ca-certificates make build-essential cmake git make unzip -y \
  && dpkg --add-architecture i386 \
  && apt-get update \
  || echo "continue..." \
  && apt-get install --no-install-recommends -y libgphoto2-6:i386 \
                                                libldap-2.4-2:i386 \
                                                libtiff5:i386 \
                                                libasound2-plugins:i386 \
                                                libwine:i386 \
                                                wine32 \
  || apt-get install --no-install-recommends -y libgphoto2-6:i386 \
                                                libldap-2.4-2:i386 \
                                                libtiff5:i386 \
                                                libasound2-plugins:i386 \
                                                libwine:i386 \
                                                wine32 \
  && echo "wine32 is installed."











ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]











