---
title: Linux 安装redis
tags: Linux
abbrlink: 22c55d3b
date: 2023-06-19 18:05:00
---

[redis官方网站](https://redis.io)

## 安装开发工具包

```bash
sudo apt install build-essential
yum groupinstall -y "Development Tools"
```

```bash
wget https://download.redis.io/releases/redis-6.2.7.tar.gz
tar -zxvf redis-6.2.7.tar.gz
cd redis-6.2.7/
make
sudo make install
sudo vim /etc/sysctl.conf
net.core.somaxconn = 1024
vm.overcommit_memory = 1
```

## 例如创建redis的服务

```bash
sudo vim /etc/systemd/system/redis.service

[Unit]
Description=Advanced key-value store
After=network.target
Documentation=http://redis.io/documentation, man:redis-server(1)

[Service]
User=redis
WorkingDirectory=/usr/local/redis/
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/bin/kill -s TERM $MAINPID
PIDFile=/var/run/redis/redis-server.pid
#Restart=always
User=root
Group=root
PrivateTmp=true

[Install]
WantedBy=multi-user.target
Alias=redis.service

```

***刷新服务列表***

```bash
sudo systemctl daemon-reload
```

***启动，停止，重启***

```bash
sudo systemctl start:stop:restart:status redis.service
```

***按照自己的需要修改redis配置文件***
