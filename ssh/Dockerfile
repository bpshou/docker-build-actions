FROM debian:buster-slim

LABEL maintainer="SSH server <decezz@qq.com>"

COPY entrypoint.sh /

# install ssh service
RUN sed 's/\(deb\|security\|snapshot\).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list -i && \
    apt-get update && \
    apt-get -y install --no-install-recommends --no-install-suggests \
        ca-certificates openssh-server curl && \
    curl -fsSL "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.$(uname -m)" -o /usr/bin/ttyd && \
    rm -rf /var/lib/apt/lists/*

# ssh config
RUN mkdir -p /run/sshd && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    sed -i "s/#GatewayPorts no/GatewayPorts yes/g" /etc/ssh/sshd_config && \
    sed -i "s/#AddressFamily any/AddressFamily any/g" /etc/ssh/sshd_config && \
    echo "root:origin123456" | chpasswd && \
    chmod +x /usr/bin/ttyd && \
    chmod +x /entrypoint.sh

WORKDIR /root

EXPOSE 2222 8686

ENTRYPOINT ["/entrypoint.sh"] 

CMD ["/usr/sbin/sshd", "-p", "2222", "-D"]
