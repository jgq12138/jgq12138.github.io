---
title: linux upgrade openssh
date: 2026-03-13 17:46:54
tags: Linux
---

## 从openssh官网下载最新的源码

https://www.openssh.org/portable.html

## 编译安装

```bash
tar -xf openssh-10.2p1.tar.gz
cd openssh-10.2p1
./configure --prefix=/opt/openssh
make
sudo make install
sudo useradd sshd -s /sbin/nologin
```

缺少依赖的安装

* zlib
* openssl 1.1.1

## 创建openssh服务

```bash
sudo vim /etc/systemd/system/openssh.service
```

```service
[Unit]
Description=OpenBSD Secure Shell server
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target auditd.service

[Service]
ExecStartPre=/opt/openssh/sbin/sshd -t
ExecStart=/opt/openssh/sbin/sshd -D $SSHD_OPTS
ExecReload=/opt/openssh/sbin/sshd -t
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartPreventExitStatus=255
Type=notify
RuntimeDirectory=sshd
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
Alias=sshd.service
```

## 编译安装后向其他服务器拷贝使用

需要注意的是直接拷贝后需要重新生成密钥文件，负责会造成多个服务器使用相同的密钥文件

```bash
sudo rm -rf /opt/openssh/etc/ssh_host_*
sudo /opt/openssh/bin/ssh-keygen -A
sudo chmod 600 /opt/openssh/etc/ssh_host_*
sudo chmod 644 /opt/openssh/etc/*.pub
```