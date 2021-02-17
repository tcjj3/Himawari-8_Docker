FROM debian:buster-slim

LABEL maintainer "Chaojun Tan <https://github.com/tcjj3>"

ADD convert.sh /opt/convert.sh
ADD entrypoint.sh /opt/entrypoint.sh

RUN export DIR_TMP="$(mktemp -d)" \
  && cd $DIR_TMP \
  && chmod +x /opt/*.sh \
  && sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  && sed -i "s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  && apt-get update \
  || echo continue... \
  && apt-get install --no-install-recommends -y curl \
                                                unzip \
                                                cron \
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
  && curl -L https://github.com/Haivision/srt/archive/v1.4.2.tar.gz -o srt.tar.gz \
  && tar zxvf srt.tar.gz \
  && cd srt-1.4.2 \
  && ./configure \
  && make \
  && make install \
  && ldconfig \
  && cd .. \
  && rm -r srt-1.4.2 \
  && rm srt.tar.gz \
  && if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
        TSDuck_URL="https://github.com/tsduck/tsduck/releases/download/v3.25-2237/tsduck_3.25-2237.debian10_amd64.deb"; \
   elif [ "$(dpkg --print-architecture)" = "armhf" ]; then \
        TSDuck_URL="https://github.com/tsduck/tsduck/releases/download/v3.25-2237/tsduck_3.25-2237.raspbian10_armhf.deb"; \
     fi \
  && mkdir tsduck \
  && cd tsduck \
  && curl -L "$TSDuck_URL" -o tsduck.deb \
  && ar -x tsduck.deb \
  && tar Jxvf data.tar.xz \
  && cp usr/lib/libtsduck.so /usr/lib/ \
  && cp -r usr/lib/tsduck /usr/lib/ \
  && cp usr/bin/ts* /usr/bin/ \
  && cp -r etc/security/console.perms.d /etc/security/ \
  && cp lib/udev/rules.d/*.rules /lib/udev/rules.d/ \
  && cp -r usr/share/tsduck /usr/share/ \
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
  && curl -fsSL https://filebrowser.org/get.sh | bash \
  && git clone https://github.com/sam210723/himawari-rx /usr/local/bin/himawari-rx \
  && mkdir -p /usr/local/bin/himawari-rx/src/received \
  && pip3 install --no-cache-dir -r /usr/local/bin/himawari-rx/requirements.txt \
  && curl -L https://github.com/tcjj3/himawari-rx_auto_scripts/releases/latest/download/himawari-rx_auto_scripts-Linux.zip -o himawari-rx_auto_scripts-Linux.zip \
  && unzip -o himawari-rx_auto_scripts-Linux.zip -d /usr/local/bin/himawari-rx/src \
  && chmod +x /usr/local/bin/himawari-rx/src/*.sh \
  && chmod +x /usr/local/bin/himawari-rx/src/*.py \
  && chmod +x /usr/local/bin/himawari-rx/src/tools/*.py \
  && echo "55 23 * * * /opt/convert.sh" > ${DIR_TMP}/crontab \
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
  && echo "wine32 is installed."





ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]





