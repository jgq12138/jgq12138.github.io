---
title: Linux 创建系统用户
tags: Linux
abbrlink: c2da4266
date: 2023-06-19 18:05:00
---

## 以root 用户登陆

```bash
useradd -r -m -s /bin/bash username
```

* 参数说明：
* -r：建立系统账号
* -m：自动建立用户的登入目录
* -s：指定用户登入后所使用的shell

***-s 参数/sbin/nologin 这是一个不允许用户登录的shell***

## 修改新建用户的登陆密码

```bash
passwd username
```

## 将新建用户添加

```bash
usermod -aG sudo username
```
