FROM php:7.4-fpm-buster

LABEL maintainer="php:7.4-fpm-buster<decezz@qq.com>"

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions      /usr/local/bin/
COPY docker-php-entrypoint  /usr/local/bin/docker-php-entrypoint
COPY --from=composer:1      /usr/bin/composer /usr/local/bin/composer
COPY --from=nginx:1.18      /usr/sbin/nginx /usr/sbin/nginx
COPY --from=nginx:1.18      /usr/lib/nginx/modules/ /usr/lib/nginx/modules/
COPY --from=nginx:1.18      /etc/nginx/ /etc/nginx/


# install extensions
RUN sed 's/\(deb\|security\|snapshot\).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list -i && \
    mv /usr/src/php/ext/redis-5.3.1 /usr/src/php/ext/redis && \
    apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo_mysql mysqli bcmath -j$(nproc) gd pcntl && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions redis mongodb

# config
RUN cp -r /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    sed -i '$a error_log = /usr/share/nginx/logs/php_errors.log' /usr/local/etc/php/php.ini && \
    sed -i '$a slowlog = /usr/share/nginx/logs/php-fpm-slow.log' /usr/local/etc/php-fpm.d/www.conf

# install nginx
RUN mkdir -p /var/log/nginx/ && \
    mkdir -p /var/run/ && \
    mkdir -p /var/cache/nginx/client_temp && \
    mkdir -p /var/cache/nginx/proxy_temp && \
    mkdir -p /var/cache/nginx/fastcgi_temp && \
    mkdir -p /var/cache/nginx/uwsgi_temp && \
    mkdir -p /var/cache/nginx/scgi_temp

WORKDIR /usr/share/nginx/html

CMD ["-y", "/usr/local/etc/php-fpm.conf"]
