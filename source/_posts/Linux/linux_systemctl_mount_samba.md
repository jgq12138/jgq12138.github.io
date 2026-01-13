---
title: linux systemctl mount samba
date: 2026-01-13 10:07:45
tags: Linux
---

- 请确保你的系统已经安装了cifs-utils包，因为systemd需要它来挂载CIFS/SMB共享

```bash
# Debian/Ubuntu
sudo apt install cifs-utils
# CentOS/RHEL
sudo yum install cifs-utils
```

使用 systemd mount 单元 

## 创建挂载点目录

```bash
sudo mkdir -p /mnt/sms
```

## 创建凭据文件（安全存储密码）

```bash
sudo vim /etc/samba/credentials
```

```credentials
username=your_username
password=your_password
# 可选
domain=your_domain
```

设置权限

```bash
sudo chmod 600 /etc/samba/credentials
```

## 创建 systemd mount 单元文件

```bash
sudo vim /etc/systemd/system/mnt-sms.mount
```

```service
[Unit]
Description=Mount SMB Share
Requires=network-online.target
After=network-online.target

[Mount]
What=//server_ip/share_name
Where=/mnt/sms
Type=cifs
Options=credentials=/etc/samba/credentials,uid=1000,gid=1000,dir_mode=0755,file_mode=0644,nofail,vers=3.0
TimeoutSec=30
ForceUnmount=true

[Install]
WantedBy=multi-user.target
```

## 启用并启动挂载

```bash
# 重新加载 systemd 配置
sudo systemctl daemon-reload

# 启用开机自动挂载
sudo systemctl enable mnt-sms.mount

# 立即挂载
sudo systemctl start mnt-sms.mount

# 检查状态
sudo systemctl status mnt-sms.mount
```