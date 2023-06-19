---
title: Linux 创建service
date: 2023-06-19 18:05:00
tags: Linux
---

# linux 创建service

## 说明

* Linux下面的系统自启动服务是有systemd 管理的（之前是在init文件夹中写脚本）
* linux下面有两个地方可以放service文件、一个是/lib/systemd/system，这个是系统服务的位置，一般情况下我们自己建立的服务需要放在/etc/systemd/system文件夹下面和系统服务分开

## 例如创建nginx的服务

```bash
sudo vim /etc/systemd/system/redis.service


[Unit]
Description=redis server
After=network.target remote-fs.target nss-lookup.target

[Service]
User=root
Type=forking
WorkingDirectory=/usr/local/redis
PIDFile=/usr/local/redis/redis.pid
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

***刷新服务列表***

```bash
sudo systemctl daemon-reload
```

***启动，停止，重启***

```bash
sudo systemctl start:stop:restart:status nginx.service
```
