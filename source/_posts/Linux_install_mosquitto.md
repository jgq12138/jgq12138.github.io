---
title: mosquitto编译安装使用
tags: Linux
categories : 工具安装
abbrlink: bf3d053b
date: 2023-06-19 18:05:00
---

## 编译

```bash
# Ubuntu
sudo apt install libssl-dev libwebsockets-dev uuid-dev libcjson-dev libc-ares-dev xsltproc docbook-xsl docbook-xml

git clone https://github.com/DaveGamble/cJSON.git
cd cjson
make && sudo make install

git clone https://github.com/eclipse/mosquitto.git
cd mosquitto
mkdir build && cd build
cmake -DWITH_SRV=yes -DWITH_CJSON=yes -DWITH_WEBSOCKETS=yes -DWITH_TLS=yes -DWITH_BUNDLED_DEPS=yes -DWITH_DOCS=yes ..
make && sudo make install
sudo cp ../service/systemd/mosquitto.service.simple /etc/systemd/system/mosquitto.service
sudo useradd -r -m -s /bin/bash mosquitto
sudo mv /usr/local/etc/mosquitto /etc/mosquitto
sudo ln -s /usr/local/sbin/mosquitto /usr/sbin/mosquitto
```

## 配置

```bash
sudo mosquitto_passwd -c /etc/mosquitto/pwfile admin
```


基本ALC配置
创建好了认证之后，我们可能还需要对每个账户的权限进行控制，毕竟有的时候为了数据安全，不能允许所有的设备能完全订阅整个broker上的所有topic。

创建一个新的文件，比如起名叫aclfile，上述两个账户的权限举例如下：

```bash
# admin用户可以发布和订阅broker上面的所有主题
user admin
topic readwrite #

# user用户 只有/iot/user/改主题的权限
user user
topic /iot/user/+
```

这样就给admin赋予了所有topic的订阅及发布权限，而user只能在/iot/user/+这个通配符权限下面进行订阅及发布。

***配置文件***

```bash
# 可以参照mosquitto.conf中的注释配置以下是常用配置
# 关闭匿名登录
allow_anonymous false
# 密码文件
password_file /usr/local/mosquitto/etc/mosquitto/pwfile.example
# 日志可以使用文件记录
log_dest file /usr/local/mosquitto/logs/mosquitto.log
# 启动用户
user mosquitto
# 监听端口
# mqtt
listener 1883 0.0.0.0
protocol mqtt
# websocket
listener 8083 0.0.0.0
protocol websockets
# 最大连接数
max_connections -1
```

## 创建服务文件

```bash
sudo vim /etc/systemd/system/mosquitto.service

[Unit]
Description=Mosquitto MQTT Broker
Documentation=man:mosquitto.conf(5) man:mosquitto(8)
After=network.target
Wants=network.target

[Service]
Type=simple
NotifyAccess=main
ExecStart=/usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
ExecStartPre=/bin/mkdir -m 740 -p /var/log/mosquitto
ExecStartPre=/bin/chown mosquitto:mosquitto /var/log/mosquitto
ExecStartPre=/bin/mkdir -m 740 -p /run/mosquitto
ExecStartPre=/bin/chown mosquitto:mosquitto /run/mosquitto

[Install]
WantedBy=multi-user.target
```
