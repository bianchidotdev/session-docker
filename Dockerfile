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

# Create directories for Oxen data and config
RUN mkdir -p /etc/oxen /var/lib/lokinet

COPY oxen.conf.example /etc/oxen/oxen.conf

# install session-service-node
RUN curl -so /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg && \
    echo "deb https://deb.oxen.io $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/oxen.list && \
    apt-get update && \
    apt-get install -q -o Dpkg::Options::="--force-confold" -y session-service-node && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/init.sh /usr/local/bin/init.sh
COPY scripts/run.sh /usr/local/bin/run.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/init.sh /usr/local/bin/run.sh

# Create volume for persistent storage
VOLUME ["/var/lib/oxen", "/etc/oxen"]

# Set the working directory
WORKDIR /var/lib/oxen

EXPOSE 11022/tcp
EXPOSE 11025/tcp

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["/usr/local/bin/run.sh"]
