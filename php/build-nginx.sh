#!/bin/bash

# 获取linux发行版本
lsb_dist=$( grep -Eio "Ubuntu|Debian|Alpine|Kernel" /etc/issue | head -n1 )
# 包管理器
if [ "$lsb_dist" = "Kernel" ]; then
    # 安装依赖
    yum -y update
    yum -y groupinstall "Development Tools"
elif [ "$lsb_dist" = "Ubuntu" ]; then
    # 安装依赖
    sed 's/\(deb\|security\|snapshot\).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list -i
    apt-get update
    apt-get -y install curl build-essential autoconf
elif [ "$lsb_dist" = "Debian" ]; then
    # 安装依赖
    sed 's/\(deb\|security\|snapshot\).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list -i
    apt-get update
    apt-get -y install curl build-essential autoconf
elif [ "$lsb_dist" = "Alpine" ]; then
    # 更换源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
    # 安装依赖
    apk add --no-cache --virtual .build curl gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers libxslt-dev gd-dev geoip-dev perl-dev libedit-dev mercurial bash alpine-sdk findutils
else
    echo 'error: unknow system'
    exit 1
fi

# Download package
sudo mkdir -p /home/src /home/nginx/temp
curl -L http://nginx.org/download/nginx-1.18.0.tar.gz -o /home/src/nginx-1.18.0.tar.gz
curl -L https://www.openssl.org/source/openssl-1.1.1g.tar.gz -o /home/src/openssl-1.1.1g.tar.gz
curl -L http://www.zlib.net/zlib-1.2.11.tar.gz -o /home/src/zlib-1.2.11.tar.gz
curl -L https://sourceforge.net/projects/pcre/files/pcre/8.44/pcre-8.44.tar.gz/download -o /home/src/pcre-8.44.tar.gz
git clone https://github.com/arut/nginx-rtmp-module.git /home/src/nginx-rtmp-module
tar -zxvf /home/src/nginx-1.18.0.tar.gz -C /home/nginx
tar -zxvf /home/src/openssl-1.1.1g.tar.gz -C /home/src
tar -zxvf /home/src/zlib-1.2.11.tar.gz -C /home/src
tar -zxvf /home/src/pcre-8.44.tar.gz -C /home/src

# Compile Build
mv /home/src /home/nginx/
cd /home/nginx/src/pcre-8.44 && autoreconf -vfi
cd /home/nginx/nginx-1.18.0

# nginx configure
./configure \
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
--with-zlib=../src/zlib-1.2.11
# --with-zlib=../src/zlib-1.2.11 \
# --add-module=../src/nginx-rtmp-module


# 变更参数
# --with-cc-opt='-Os -fomit-frame-pointer' \
# --with-ld-opt=-Wl,--as-needed
# --add-module=../nginx-rtmp-module

make -j && make install

if [ $? = 0 ]; then
    echo 'nginx build success'
else
    echo 'nginx build error'
    exit 1
fi

# 后置操作
tee /home/nginx/nginx <<-'EOF'
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

EOF

chmod -R 755 /home/nginx/nginx
mkdir -p /usr/share

# clean cache
rm -rf /home/src /home/nginx/nginx-1.18.0
mv /home/nginx /usr/share
