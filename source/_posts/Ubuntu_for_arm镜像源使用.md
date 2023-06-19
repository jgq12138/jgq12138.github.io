---
title: Ubuntu for arm 镜像源使用
date: 2023-06-19 18:05:00
tags: Linux
---

# Ubuntu for arm 镜像源使用

## 目前下载了arm64架构的镜像源，在使用之前首先查看自己的服务器架构是不是arm64架构

## 配置方法

```shell
sudo vim /etc/apt/sources.list
```

将源仓库配置文件中的内容替换为
```shell
deb http://192.168.0.199:8888/mirror/repo.huaweicloud.com/ubuntu-ports/ bionic main restricted
```
然后跟新本地仓库
```shell
sudo apt update
```