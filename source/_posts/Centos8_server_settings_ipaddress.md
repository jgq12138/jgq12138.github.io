---
title: Centos8服务器配置IP地址
tags: Linux
categories : Linux 命令
abbrlink: 91dffcc2
date: 2023-06-19 18:05:00
---

## 1.修改ifcfg-ens33文件

```bash
vim /etc/sysconfig/network-scripts/ifcfg-ens33
```

## 修改完的样子

```bash
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=066b4926-b40c-4c28-a5b4-2310d2b96613
DEVICE=ens33
ONBOOT=yes
#IP地址
IPADDR=192.168.195.129
#子网掩码
NETMASK=255.255.255.0
#网关
GATEWAY=192.168.195.2
#DNS
DNS1=8.8.8.8
PREFIX=24
```

## 使用nmcli重新回载网络配置

```bash
nmcli c reload
```
