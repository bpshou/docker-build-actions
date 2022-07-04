FROM debian:buster-slim

LABEL maintainer="nginx-buster<decezz@qq.com>"

# install rely
RUN apt-get update && \
    apt-get -y install curl build-essential autoconf libtool

# Download package
RUN mkdir -p /usr/share/src /usr/share/nginx/temp && \
    curl -L http://nginx.org/download/nginx-1.18.0.tar.gz -o /usr/share/src/nginx-1.18.0.tar.gz && \
    curl -L https://www.openssl.org/source/openssl-1.1.1g.tar.gz -o /usr/share/src/openssl-1.1.1g.tar.gz && \
    curl -L http://www.zlib.net/zlib-1.2.12.tar.gz -o /usr/share/src/zlib-1.2.12.tar.gz && \
    curl -L https://sourceforge.net/projects/pcre/files/pcre/8.44/pcre-8.44.tar.gz/download -o /usr/share/src/pcre-8.44.tar.gz && \
    tar -zxvf /usr/share/src/nginx-1.18.0.tar.gz -C /usr/share/nginx && \
    tar -zxvf /usr/share/src/openssl-1.1.1g.tar.gz -C /usr/share/src && \
    tar -zxvf /usr/share/src/zlib-1.2.12.tar.gz -C /usr/share/src && \
    tar -zxvf /usr/share/src/pcre-8.44.tar.gz -C /usr/share/src

RUN mv /usr/share/src /usr/share/nginx/ && \
    cd /usr/share/nginx/src/pcre-8.44 && autoreconf -vfi && \
    cd /usr/share/nginx/nginx-1.18.0

# nginx configure & install
RUN ./configure \
    --prefix=.. \
    --sbin-path=sbin/nginx \
    --modules-path=modules \
    --conf-path=conf/nginx.conf \
    --error-log-path=logs/error.log \
    --http-log-path=logs/access.log \
    --pid-path=run/nginx.pid \
    --lock-path=run/nginx.lock \
    --http-client-body-temp-path=temp/client_temp \
    --http-proxy-temp-path=temp/proxy_temp \
    --http-fastcgi-temp-path=temp/fastcgi_temp \
    --http-uwsgi-temp-path=temp/uwsgi_temp \
    --http-scgi-temp-path=temp/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-cc-opt='-Os -fomit-frame-pointer -Wno-error' \
    --with-ld-opt='-Wl,--as-needed,-rpath,../lib -L../lib -lstdc++ -ldl' \
    --with-pcre=../src/pcre-8.44 \
    --with-openssl=../src/openssl-1.1.1g \
    --with-zlib=../src/zlib-1.2.12 && \
    make -j && make install

RUN chmod -R 755 /usr/share/nginx/nginx && \
    rm -rf /usr/share/src /usr/share/nginx/nginx-1.18.0

COPY nginx.sh /usr/share/nginx/nginx.sh

WORKDIR /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
