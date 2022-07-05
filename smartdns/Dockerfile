FROM debian:buster-slim

ADD https://github.com/pymumu/smartdns/releases/download/Release36.1/smartdns-$(uname -m) /usr/bin/smartdns
ADD smartdns.conf /etc/smartdns/
ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    chmod +x /usr/bin/smartdns

WORKDIR /root

EXPOSE 53

ENTRYPOINT ["/entrypoint.sh"]
