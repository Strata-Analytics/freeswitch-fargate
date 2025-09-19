FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tzdata iproute2 iputils-ping \
    libsndfile1 libspandsp2 liblua5.2-0 libssl3 ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -r -s /usr/sbin/nologin freeswitch || true
RUN mkdir -p /usr/local/freeswitch && chown -R freeswitch:freeswitch /usr/local/freeswitch

COPY build/freeswitch/ /usr/local/freeswitch/
RUN chown -R freeswitch:freeswitch /usr/local/freeswitch \
 && find /usr/local/freeswitch -type d -exec chmod 755 {} \; \
 && chmod 755 /usr/local/freeswitch/bin/freeswitch \
 && chmod 755 /usr/local/freeswitch/bin/fs_cli


COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R freeswitch:freeswitch /usr/local/freeswitch

USER freeswitch
EXPOSE 5060/tcp 5060/udp 5061/tcp
ENTRYPOINT ["/entrypoint.sh"]
