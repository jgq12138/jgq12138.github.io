---
title: ubuntu 18.04 server 配置IP地址
tags: Linux
abbrlink: a13aa77d
date: 2023-06-19 18:05:00
---

## 编译Netplan 配置文件

```bash
sudo vim /etc/netplan/50-cloud-init.yaml
```

## 配置网络IP和路由

```bash
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: false
      optional: false
      addresses: [<IP地址>/<子网掩码>]
      gateway4: <网关地址>
      routes:
        - to: 192.168.1.0/24
          via: <网关地址>
```

## 在上述配置中

- ens33：是网络接口的名称，具体名称会因系统而异，可以使用ifconfig或ip addr命令查看
- dhcp4: no：表示不使用DHCP自动获取IP地址配置信息，而是配手动置IP地址
- addresses: [<IP地址>/<子网掩码>]：用于配置静态IP地址和子网掩码，例如192.168.1.100/24
- gateway4: <网关地址>：表示默认的网关地址
- routes：用于添加静态路由，可以配置多个静态路由

## 应用Netplan配置，可以使用以下命令

```bash
sudo netplan apply
```
