---
title: fastgithub+git访问github
abbrlink: '33031923'
date: 2023-07-04 17:08:39
tags:
---

访问github经常性访问不到，或者想clone代码的时候老是超时，记一下解决方案
git设置代理参考<https://zhuanlan.zhihu.com/p/481574024>
github访问不到大概率就是你的DNS找不到github的IP地址<https://github.com/dotnetcore/FastGithub>这个项目可以提供域名的纯净IP解析，提供IP测速并选择最快的IP

## 首先安装fastgithub <https://github.com/dotnetcore/FastGithub>

- 访问github仓库，在releases中选择你需要的架构并下载
- 安装仓库中部署方式在自己的电脑上面部署一下
- 现在浏览器访问github应该会好一些，但是clone代码还是会超时

## git 设置代理

```bash
git config --global http.https://github.com.proxy http://127.0.0.1:38457
```

## 取消代理

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## 设置完代理访问github会好很多，建议将fastgithub作为服务运行
