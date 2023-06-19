---
title: 挂载网络位置
date: 2023-06-19 18:05:00
tags: Linux
---

# 挂载网络位置

## 安装

```bash
sudo apt install -y cifs-utils
```

## 挂载

```bash
sudo mount -o username=allclient,password=Huawei12#$,gid="1001",uid="1001",vers=1.0 //monitor.com/WFTP /minio/
```

