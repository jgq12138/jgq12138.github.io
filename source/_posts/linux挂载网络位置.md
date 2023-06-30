---
title: 挂载网络位置
date: 2023-06-19 18:05:00
tags: Linux
---

## 安装

```bash
sudo apt install -y cifs-utils
```

## 挂载

```bash
sudo /bin/mount -o username=allclient,password=Huawei12#$,gid="1000",uid="1000",vers=3.0 //monitor.com/QP/Minio_Data /opt/Minio_Data
```

## 卸载

```bash
sudo /bin/umount /opt/Minio_Data
```

## 自动挂载

```bash
sudo vim /etc/fstab
# NFS
//monitor.com/QP/Minio_Data /opt/Minio_Data cifs    username=allclient,password=Huawei12#$,gid=1000,uid=1000    0   0
```
