FROM alpine:latest

COPY v2ray.sh /root/v2ray.sh

RUN apk add --no-cache --virtual .build-deps ca-certificates && \
    chmod +x /root/v2ray.sh && \
    /root/v2ray.sh

EXPOSE 10808 10809 10810

VOLUME /etc/v2ray

ENTRYPOINT ["v2ray"]

CMD ["run", "-c", "/etc/v2ray/config.json"]
