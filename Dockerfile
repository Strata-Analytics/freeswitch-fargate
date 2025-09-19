FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias runtime básicas (sumá otras si tu build las requiere)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tzdata iproute2 iputils-ping \
    libsndfile1 libspandsp2 liblua5.2-0 libssl3 ffmpeg \
    libsqlite3-0 libcurl4 libjpeg-turbo8 libpng16-16 libtiff5 libedit2 \
    libogg0 libopus0 libspeex1 libspeexdsp1 libsrtp2-1 \
    && rm -rf /var/lib/apt/lists/*

# Usuario
RUN useradd -r -s /usr/sbin/nologin freeswitch || true
RUN mkdir -p /usr/local/freeswitch

COPY build/freeswitch/ /usr/local/freeswitch/

RUN echo "/usr/local/freeswitch/lib" > /etc/ld.so.conf.d/freeswitch.conf \
 && echo "/usr/local/lib"          > /etc/ld.so.conf.d/local.conf \
 && ldconfig \
 && chown -R freeswitch:freeswitch /usr/local/freeswitch \
 && find /usr/local/freeswitch -type d -exec chmod 755 {} \; \
 && chmod 755 /usr/local/freeswitch/bin/freeswitch \
 && chmod 755 /usr/local/freeswitch/bin/fs_cli || true

# EntryPoint
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER freeswitch
EXPOSE 5060/tcp 5060/udp 5061/tcp
ENTRYPOINT ["/entrypoint.sh"]
