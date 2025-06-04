FROM debian:bookworm-slim

LABEL description="Docker image for running a Session Node"

# Avoid prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    gnupg \
    iproute2 \
    lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/oxen /var/lib/lokinet

# uses dummy configuration to bypass interactive setup requirements
COPY oxen.conf.example /etc/oxen/oxen.conf

RUN curl -so /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg && \
    echo "deb https://deb.oxen.io $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/oxen.list && \
    apt-get update && \
    apt-get install -q -o Dpkg::Options::="--force-confold" -y session-service-node && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/* /usr/local/bin/

EXPOSE 11022/tcp
EXPOSE 11025/tcp

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["/usr/local/bin/run.sh"]
