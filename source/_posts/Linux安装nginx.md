---
title: 编译nginx
tags: Linux
abbrlink: 1d754660
date: 2023-06-19 18:05:00
---

## 安装开发工具包

```bash
Ubuntu : sudo apt install build-essential
Centos : sudo dnf group install "Development Tools"
```

## 下载安装包

```bash
wget https://nginx.org/download/nginx-1.22.1.tar.gz -P ~/nginx
```

## 下载第三方依赖

```bash
wget https://www.openssl.org/source/openssl-1.1.1f.tar.gz -P ~/nginx
wget https://www.zlib.net/zlib-1.2.13.tar.gz -P ~/nginx
wget https://nchc.dl.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.gz -P ~/nginx
```

## 解压

```bash
cd ~/nginx
tar -zxvf nginx-1.22.0.tar.gz
tar -zxvf openssl-1.1.1f.tar.gz
tar -zxvf zlib-1.2.12.tar.gz
tar -zxvf pcre-8.45.tar.gz
```

## 编译安装

```bash
cd ~/nginx/nginx-1.22.0/
./configure --prefix=/usr/local/nginx \
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
            --with-zlib=../zlib-1.2.13 \
            --with-openssl=../openssl-1.1.1f \
            --with-openssl-opt=no-nextprotoneg \
            --with-debug 
make -j8
sudo make install
```

## 创建服务

```bash
sudo vim /etc/systemd/system/nginx.service
```

```bash
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
WorkingDirectory=/usr/local/nginx
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

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
