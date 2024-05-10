---
title: ubuntu 安装MySQL8
tags: Linux
abbrlink: 373b3015
date: 2023-06-19 18:05:00
---

## 安装源

```bash
wget https://repo.mysql.com//mysql-apt-config_0.8.22-1_all.deb
sudo apt install ./mysql-apt-config_0.8.22-1_all.deb
sudo apt update
sudo apt install mysql-server
```

***安装的时候输入密码，选择身份验证方式、密码加密方式 Ubuntu 18.04 选择MySQL5.X***

## root用户开启远程连接

```bash
mysql -uroot -p

use mysql;
update user set host='%' where user='root';
FLUSH PRIVILEGES;
```
