#!/bin/bash

# nginx sbin (必须指定该目录)
cd /usr/share/nginx/sbin

if [ ! -n "$(grep -w nginx /etc/passwd)" ]; then
    # alpine
    if [ -r /etc/alpine-release ]; then
        addgroup -g 202 -S nginx
        adduser -S -D -H -u 202 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx
    # Debian & Ubuntu
    elif [ -n "$(grep -Eio "Ubuntu|Debian" /etc/issue)" ]; then
        addgroup --system --gid 202 nginx
        adduser --system --disabled-login --ingroup nginx --no-create-home --gecos "nginx user" --shell /bin/false --uid 202 nginx
    # centos
    elif [ -r /etc/redhat-release ]; then
        groupadd --system --gid 202 nginx
        useradd --system -g nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 202 nginx
    else
        echo 'error: Unknow system, Cannot create nginx user'
        exit 1;
    fi
fi

exec ./nginx "$@"
