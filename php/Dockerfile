FROM php:7.4-fpm-alpine

LABEL maintainer="php7.4-fpm-alpine<decezz@qq.com>"

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions      /usr/local/bin/
COPY docker-php-entrypoint  /usr/local/bin/docker-php-entrypoint
COPY build-nginx.sh         /usr/local/bin/build-nginx.sh
COPY --from=composer:1      /usr/bin/composer /usr/local/bin/composer


# install extensions
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk add --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo_mysql mysqli bcmath gd pcntl && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions redis mongodb

# config
RUN cp -r /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    sed -i '$a error_log = /usr/share/nginx/logs/php_errors.log' /usr/local/etc/php/php.ini && \
    sed -i '$a slowlog = /usr/share/nginx/logs/php-fpm-slow.log' /usr/local/etc/php-fpm.d/www.conf

# install nginx
RUN apk add --no-cache --virtual bash && \
    chmod +x /usr/local/bin/build-nginx.sh && \
    bash /usr/local/bin/build-nginx.sh && \
    mv /usr/share/nginx/nginx /usr/local/bin/ && \
    chown -R www-data:www-data /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

CMD ["-y", "/usr/local/etc/php-fpm.conf"]
