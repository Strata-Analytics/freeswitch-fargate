FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# libs de runtime que el binario requiere (según tu ldd)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tzdata iproute2 iputils-ping \
    libsndfile1 libspandsp3 libsofia-sip-ua0 \
    liblua5.2-0 libssl3 libsqlite3-0 libcurl4 \
    libjpeg-turbo8 libpng16-16 libtiff6 libedit2 \
    libsrtp2-1 unixodbc \
    libnghttp2-14 libidn2-0 librtmp1 libssh-4 libpsl5 \
    libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcom-err2 libkrb5support0 libsasl2-2 \
    libzstd1 zlib1g libtinfo6 libunistring2 libgnutls30 libhogweed6 libnettle8 libgmp10 \
    libkeyutils1 libbrotlidec1 libbrotlicommon1 libmd0 libp11-kit0 libtasn1-6 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# usuario
RUN useradd -r -s /usr/sbin/nologin freeswitch || true
RUN mkdir -p /usr/local/freeswitch

# Copiá tu bundle completo (incluida /lib con libfreeswitch.so.1)
COPY build/freeswitch/ /usr/local/freeswitch/

# Registrar rutas de libs + permisos
RUN echo "/usr/local/freeswitch/lib" > /etc/ld.so.conf.d/freeswitch.conf \
 && echo "/usr/local/lib"          > /etc/ld.so.conf.d/local.conf \
 && ldconfig \
 && chown -R freeswitch:freeswitch /usr/local/freeswitch \
 && find /usr/local/freeswitch -type d -exec chmod 755 {} \; \
 && chmod 755 /usr/local/freeswitch/bin/freeswitch \
 && chmod 755 /usr/local/freeswitch/bin/fs_cli || true

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER freeswitch
EXPOSE 5060/tcp 5060/udp 5061/tcp
ENTRYPOINT ["/entrypoint.sh"]
