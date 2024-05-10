---
title: mosquitto编译安装使用
tags: Linux
abbrlink: bf3d053b
date: 2023-06-19 18:05:00
---

## 编译

```bash

git clone https://github.com/DaveGamble/cJSON.git
cd cjson
make && sudo make install

wget https://mosquitto.org/files/source/mosquitto-2.0.14.tar.gz

tar -zxvf mosquitto-2.0.14.tar.gz
cd mosquitto-2.0.14
mkdir build && cd build
cmake --install-prefix=/usr/local/mosquitto ..
make && sudo make install
```

## 配置

```bash
sudo /usr/local/mosquitto/bin/mosquitto_passwd -c /usr/local/mosquitto/etc/mosquitto/pwfile.example admin
```

***输入两次密码***

基本ALC配置
创建好了认证之后，我们可能还需要对每个账户的权限进行控制，毕竟有的时候为了数据安全，不能允许所有的设备能完全订阅整个broker上的所有topic。

创建一个新的文件，比如起名叫alc，上述两个账户的权限举例如下：

```bash
user admin
topic readwrite #

user user
topic /iot/user/+
```

这样就给admin赋予了所有topic的订阅及发布权限，而user只能在/iot/user/+这个通配符权限下面进行订阅及发布。

***配置文件***

```bash
allow_anonymous false
password_file /usr/local/mosquitto/etc/mosquitto/pwfile.example
pid_file /usr/local/mosquitto/logs/mosquitto.pid
log_dest file /usr/local/mosquitto/logs/mosquitto.log
user mosquitto
listener 1883 0.0.0.0
max_connections -1
```

## 创建服务文件

```bash
sudo vim /etc/systemd/system/mosquitto.service

[Unit]
Description=mosquitto Service
After=syslog.target

[Service]
User=root
WorkingDirectory=/usr/local/mosquitto
ExecStart=/usr/local/mosquitto/sbin/mosquitto -c /usr/local/mosquitto/etc/mosquitto/mosquitto.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
