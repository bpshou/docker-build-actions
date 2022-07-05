FROM debian:buster-slim

ADD 
ADD smartdns.conf /etc/smartdns/
ADD entrypoint.sh /

RUN apt-get update && \
    apt-get -y install curl && \
    curl -L https://github.com/pymumu/smartdns/releases/download/Release36.1/smartdns-$(uname -m) -o /usr/bin/smartdns && \
    chmod +x /entrypoint.sh && \
    chmod +x /usr/bin/smartdns

WORKDIR /root

EXPOSE 53

ENTRYPOINT ["/entrypoint.sh"]
