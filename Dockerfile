ARG busybox_builder
FROM ${busybox_builder}
MAINTAINER vamshi@hasura.io
# https://blog.csdn.net/jiangjiang_jian/article/details/88822981
ENV DEBIAN_FRONTEND noninteractive

# Necessary shared libs for ghc
RUN ARCH=`uname -m` \
 && apt-get -y update \
 && apt-get -y install netbase \
 && cp -L --parents -t rootfs /lib/${ARCH}-linux-gnu/libgcc_s.so.1 \
 && cp -L --parents -t rootfs /usr/lib/${ARCH}-linux-gnu/gconv/UTF-* \
 && cp -L --parents -t rootfs /usr/lib/${ARCH}-linux-gnu/gconv/gconv-modules* \
 && cp -Lr --parents -t rootfs /usr/lib/locale/C.UTF-8 \
 && cp -L /etc/protocols rootfs/etc/ \
 && apt-get -y purge netbase \
 && apt-get -y auto-remove \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

COPY build.sh /build.sh
CMD ["/build.sh"]
