---
title: Ubuntu_enable_desktop_amd_disenable_desktop
abbrlink: 4f07aa34
categories : Linux 命令
date: 2023-12-13 15:49:51
tags:
---

## Ubuntu 桌面版禁用桌面和启用桌面

```bash

# 关闭图形界面
systemctl set-default multi-user.target
# 禁用后需要重启才能生效

# 打开图形界面
systemctl set-default graphical.target
```