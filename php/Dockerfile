FROM php:7.4-fpm-alpine

LABEL maintainer="php7.4-fpm-alpine<decezz@qq.com>"

ADD nginx.alpine.tar.gz     /usr/share/
ADD redis-5.3.1.tgz         /usr/src/php/ext/
ADD mongodb-1.8.0.tgz       /usr/src/php/ext/
COPY docker-php-entrypoint  /usr/local/bin/docker-php-entrypoint
COPY composer.phar          /usr/local/bin/composer

# install nginx
RUN mv /usr/share/nginx/nginx /usr/local/bin/ && \
    chown -R www-data:www-data /usr/share/nginx/html

# install extensions
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    mv /usr/src/php/ext/redis-5.3.1 /usr/src/php/ext/redis && \
    mv /usr/src/php/ext/mongodb-1.8.0 /usr/src/php/ext/mongodb && \
    apk add --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo_mysql mysqli bcmath gd pcntl redis mongodb && \
    rm -rf /usr/src/php/ext/redis /usr/src/php/ext/mongodb

# config
RUN cp -r /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN sed -i '$a error_log = /usr/share/nginx/logs/php_errors.log' /usr/local/etc/php/php.ini
RUN sed -i '$a slowlog = /usr/share/nginx/logs/php-fpm-slow.log' /usr/local/etc/php-fpm.d/www.conf

WORKDIR /usr/share/nginx/html

CMD ["-y", "/usr/local/etc/php-fpm.conf"]
