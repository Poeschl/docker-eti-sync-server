FROM docker.io/debian:bookworm-slim as resources
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget tar ca-certificates sed

RUN wget https://www.eti-lan.xyz/sync_server.tar \
    && mkdir /sync_server \
    && tar xvf sync_server.tar -C /sync_server

# Patch a permission change for /lan
RUN sed -i '/start() {/a chmod -R 0777 /lan; ls -al /lan' /sync_server/etc/init.d/eti


FROM docker.io/debian:bookworm-slim as running
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y wget gnupg ca-certificates systemd systemd-sysv iproute2 procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" > /etc/apt/sources.list.d/resilio-sync.list \
    && wget -qO - http://linux-packages.resilio.com/resilio-sync/key.asc | apt-key add - \
    && apt-get update \
    && apt-get install --no-install-recommends -y net-tools resilio-sync curl sqlite3 iptables iptables-persistent \
    && apt-mark hold resilio-sync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=resources /sync_server /

RUN echo "alias eti='/etc/init.d/eti'" >> /root/.bashrc \
    && update-rc.d eti defaults \
    && update-rc.d -f resilio-sync remove \
    && chmod +x /etc/rc.local \
    && echo 'root:lan' | chpasswd

RUN mkdir /lan && chmod 0777 /lan
VOLUME /lan
VOLUME /etc/iptables

STOPSIGNAL SIGRTMIN+3
EXPOSE 8888
ENTRYPOINT ["/usr/sbin/init"]
