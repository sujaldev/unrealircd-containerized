FROM debian:latest

WORKDIR /tmp

# Install dependencies & setup non-root user
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y build-essential pkg-config gdb libssl-dev \
    libpcre2-dev libargon2-0-dev libsodium-dev libc-ares-dev libcurl4-openssl-dev wget \
    && useradd unrealircd \
    && mkdir /app \
    && chown -R unrealircd:unrealircd /app
USER unrealircd

# Fetch Source Tarball
RUN wget -O /tmp/unrealircd-latest.tar.gz https://www.unrealircd.org/downloads/unrealircd-latest.tar.gz

# Copy default build config
COPY ./config.settings /tmp/config.settings

# Build
RUN tar xvzf /tmp/unrealircd-latest.tar.gz \
    && export VER=$(find . -maxdepth 1 -type d -name "unrealircd-*" | awk -F- '{print $2}') \
    && cd ./unrealircd-${VER}/ \
    && cp /tmp/config.settings /tmp/unrealircd-${VER}/config.settings \
    && ./Config -quick \
    && make \
    && make install \
    && rm -rf /tmp/unrealircd* \
    && cp /app/conf/examples/example.conf /app/conf/unrealircd.conf

# Start Server
WORKDIR /app
ENTRYPOINT ["/app/unrealircd", "start"]