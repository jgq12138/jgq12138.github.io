---
title: Linux 安装mqtt
tags: Linux
categories : tool install
abbrlink: f2b0c00e
date: 2023-06-19 18:05:00
---

[下载地址](https://github.com/emqx/emqx/releases)

## ubuntu install

```bash
wget https://github.com/emqx/emqx/releases/download/v5.0.3/emqx-5.0.3-ubuntu18.04-amd64.deb
sudo apt install ./emqx-5.0.3-ubuntu18.04-amd64.deb
```

## 启动

```bash
sudo systemctl start emqx.service
```

## 查看状态

```bash
sudo systemctl status emqx.service
```

## 加入开机自启动

```bash
sudo systemctl enable emqx.service
```
