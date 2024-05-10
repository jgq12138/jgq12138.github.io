---
title: Ubuntu20.04_Update_gcc_g++
abbrlink: 7bb79c28
date: 2023-12-05 09:49:51
tags:
---

## 添加安装源
```bash
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
```

## 更新安装源和安装最新gcc，g++
```bash
sudo apt update
sudo apt install gcc-11 g++-11
```

## 更新环境变量
```bash
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 20
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 30
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 40
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 50

sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 30
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 40
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 50

```
