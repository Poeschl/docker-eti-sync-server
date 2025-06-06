FROM docker.io/debian:bookworm-slim as resources
ENV DEBIAN_FRONTEND=noninteractive TERM=xterm-256color

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget tar ca-certificates sed

RUN wget https://www.eti-lan.xyz/sync_server.tar \
    && mkdir /sync_server \
    && tar xvf sync_server.tar -C /sync_server

# Fix sync folder path
RUN sed -i 's|/lan/|/$sync_dir/|' /sync_server/etc/init.d/eti

# Patch resilio sync out of the init script
RUN sed -i '/resilio-sync/s/^/#/' /sync_server/etc/init.d/eti

# Patch iptables sync out of the init script
# Firewalling should be handled by the host
RUN sed -i '/iptables/s/^/#/' /sync_server/etc/init.d/eti \
  && sed -i '/ip6tables/s/^/#/' /sync_server/etc/init.d/eti

# Set the terminal width to a fixed value to avoid issues with the init script
RUN sed -i 's/terminal_width=$(tput cols)/terminal_width=100/' /sync_server/etc/init.d/eti \
 && sed -i '/clear/s/^/#/' /sync_server/etc/init.d/eti

FROM docker.io/debian:bookworm-slim as running
ENV DEBIAN_FRONTEND=noninteractive TERM=xterm-256color

RUN apt-get update && apt-get install --no-install-recommends -y curl sqlite3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=resources /sync_server /

ENTRYPOINT ["/etc/init.d/eti"]
CMD ["start"]
