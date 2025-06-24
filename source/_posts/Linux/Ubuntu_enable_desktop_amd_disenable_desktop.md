---
title: Ubuntu 启动和禁用图像界面
abbrlink: 4f07aa34
categories : Linux commond
date: 2023-12-13 15:49:51
tags: Linux
---

## Ubuntu 桌面版禁用桌面和启用桌面

```bash

# 关闭图形界面
systemctl set-default multi-user.target
# 禁用后需要重启才能生效

# 打开图形界面
systemctl set-default graphical.target
```