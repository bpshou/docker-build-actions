FROM debian:buster-slim

LABEL maintainer="SSH server <decezz@qq.com>"

COPY entrypoint.sh /

# install ssh service
RUN sed 's/\(deb\|security\|snapshot\).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list -i && \
    apt-get update && \
    apt-get -y install --no-install-recommends --no-install-suggests \
        openssh-server curl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/sshd && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    echo "root:origin123456" | chpasswd && \
    curl -sSL "https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.$(uname -m)" -o /usr/bin/ttyd && \
    chmod +x /usr/bin/ttyd && \
    chmod +x /entrypoint.sh

WORKDIR /root

EXPOSE 2222
EXPOSE 8686

ENTRYPOINT ["/entrypoint.sh"] 

CMD ["-p", "2222", "-D"]
