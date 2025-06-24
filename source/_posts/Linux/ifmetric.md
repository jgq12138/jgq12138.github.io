---
title: ifmetric 调整网络优先级
date: 2024-06-06 10:24:02
tags: Linux
categories : Linux commond
---

## metric 简介

Linux 网络中通常用metric控制网络优先级，metric越小网络优先级越高，通常情况下系统默认双网卡metric都是0，这样我们就要人工干预，将某一个网卡的优先级metric值提高，来确保metric为0这个网卡的优先级

## Install ifmetric

```bash
sudo apt install ifmetric
```

## 使用ifmetric调整网络优先级


```bash
sudo ifmetric eth1 100
```

## 使用route也可以调整网络优先级，不过使用route设备重启之后需要再次设置

这里需要注意的是route无法直接修改你已经添加好的路由优先级，需要删除重新添加
```bash
sudo route add -host 192.168.0.111 gw 192.168.1.254 metric 0
```