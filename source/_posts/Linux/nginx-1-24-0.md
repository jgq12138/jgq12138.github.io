---
title: nginx-1.24.0
categories : tool install
abbrlink: 4e9c5cbc
date: 2023-11-04 15:40:30
tags: Linux
---

## 安装开发工具包

```bash
Ubuntu : sudo apt install build-essential
Centos : sudo dnf group install "Development Tools"
```

## 下载安装包

```bash
wget https://nginx.org/download/nginx-1.24.0.tar.gz -P ~/nginx
```

## 下载第三方依赖

```bash
wget https://www.openssl.org/source/openssl-1.1.1f.tar.gz -P ~/nginx
wget https://www.zlib.net/zlib-1.3.tar.gz -P ~/nginx
wget https://nchc.dl.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.gz -P ~/nginx
```

## 解压

```bash
cd ~/nginx
tar -zxvf nginx-1.24.0.tar.gz
tar -zxvf openssl-1.1.1f.tar.gz
tar -zxvf zlib-1.3.tar.gz
tar -zxvf pcre-8.45.tar.gz
```

## 编译安装

```bash
cd ~/nginx/nginx-1.24.0/
./configure --prefix=/usr \
            --sbin-path=/usr/sbin/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --pid-path=/var/log/nginx/nginx.pid \
            --lock-path=/var/lock/nginx.lock \
            --user=nginx \
            --group=nginx \
            --http-client-body-temp-path=/var/tmp/nginx/client/ \
            --http-proxy-temp-path=/var/tmp/nginx/proxy/ \
            --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ \
            --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi/ \
            --http-scgi-temp-path=/var/tmp/nginx/scgi/ \
            --with-select_module \
            --with-poll_module \
            --with-threads \
            --with-file-aio \
            --with-http_ssl_module \
            --with-http_v2_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_sub_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_mp4_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_auth_request_module \
            --with-http_random_index_module \
            --with-http_secure_link_module \
            --with-http_degradation_module \
            --with-http_slice_module \
            --with-http_stub_status_module \
            --with-mail=dynamic \
            --with-mail_ssl_module \
            --with-stream \
            --with-stream_ssl_module \
            --with-stream_realip_module \
            --with-stream_ssl_preread_module \
            --with-compat \
            --with-pcre=../pcre-8.45 \
            --with-pcre-jit \
            --with-zlib=../zlib-1.3 \
            --with-openssl=../openssl-1.1.1f \
            --with-openssl-opt=no-nextprotoneg \
            --with-debug 
make -j8
sudo make install
```

## 创建用户赋权

```bash
sudo useradd nginx -s /sbin/nologin
sudo chown nginx:nginx -R /var/log/nginx/
sudo chown nginx:nginx -R /var/run/nginx/
sudo mkdir -p /var/lock/nginx/
sudo mkdir -p /var/tmp/nginx/
sudo chown nginx:nginx -R /var/lock/nginx/
sudo chown nginx:nginx -R /var/tmp/nginx/
```

## 创建服务

```bash
sudo vim /etc/systemd/system/nginx.service
```

```bash
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target

[Service]
Type=forking
PIDFile=/var/log/nginx/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /var/log/nginx/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target
```

## 启动，停止，重启，加入开机自启动

### 启动

```bash
sudo systemctl start nginx.service
```

### 停止

```bash
sudo systemctl stop nginx.service
```

### 重启

```bash
sudo systemctl restart nginx.service
```

### 加入开机自启动

```bash
sudo systemctl enable nginx.service
```
