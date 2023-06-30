---
title: ubuntu server 根目录扩容
date: 2023-06-19 18:05:00
tags: Linux
---

## 如果是VMware 虚拟机，需要清理快照，整合磁盘之后，先扩容虚拟机磁盘大小

## 将硬盘中没有使用的部分添加到已使用的分区中

```bash
cfdisk /dev/sda
```

按照指示调整分区大小

## 调整之后使用lsblk查看调整情况

df -h 现在查出来的根分区还是之前的大小，但是lsblk显示分区已经扩容，需要使用 resize2fs 命令更新

```bash
resize2fs /dev/sda1
```

## 格式化硬盘

lsblk -f 查看 /dev/sda1 有没有文件系统格式

```bash
sudo mkfs -t ext4 /dev/sda1
```
