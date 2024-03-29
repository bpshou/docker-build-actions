FROM nginx:1.18 AS NGINX

FROM composer:2.5 AS COMPOSER

FROM php:7.4-fpm-buster

LABEL maintainer="php:7.4-fpm-buster<decezz@qq.com>"

# 安装nginx
COPY --from=NGINX /usr/sbin/nginx /usr/sbin/nginx
COPY --from=NGINX /etc/nginx /etc/nginx
COPY --from=NGINX /usr/share/nginx/html /usr/share/nginx/html
COPY --from=NGINX /var/log/nginx /var/log/nginx
COPY --from=NGINX /var/cache/nginx /var/cache/nginx
# 切换用户 & 增加nginx启动
RUN sed -i 's/user  nginx;/user www-data;/g' /etc/nginx/nginx.conf && \
    sed -i "7i nginx" /usr/local/bin/docker-php-entrypoint


# 安装composer
COPY --from=COMPOSER /usr/bin/composer /usr/local/bin/composer


# config
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com && \
    cp -r /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    sed -i '$a error_log = /usr/share/nginx/logs/php_errors.log' /usr/local/etc/php/php.ini && \
    sed -i '$a slowlog = /usr/share/nginx/logs/php-fpm-slow.log' /usr/local/etc/php-fpm.d/www.conf

# install extensions
RUN sed 's/\(deb\|security\|snapshot\).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list -i && \
    apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo_mysql mysqli bcmath -j$(nproc) gd pcntl

# install install-php-extensions
RUN curl -fsSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions > /usr/local/bin/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions redis


WORKDIR /usr/share/nginx/html

CMD ["-y", "/usr/local/etc/php-fpm.conf"]
