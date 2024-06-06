---
title: ubuntu22.04 安装显卡驱动
date: 2024-06-05 11:10:51
tags: Linux
categories : 工具安装
---

## Download NVIDIA Driver


Download Links <https://www.nvidia.cn/Download/driverResults.aspx/222416/en-us/>

```shell
wget https://us.download.nvidia.cn/tesla/535.161.08/NVIDIA-Linux-x86_64-535.161.08.run
```

**安装的时候注意需要在关闭图像界面的情况下安装**
```bash
sudo systemctl set-default multi-user.target
```

### disenable nouveau

```shell
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
sudo update-initramfs -u
sudo init 6
```

### 验证nouveau

```shell
lsmod | grep nouveau
```

## Install NVIDIA Driver

```bash
chmod 755 NVIDIA-Linux-x86_64-535.161.08.run
sudo ./NVIDIA-Linux-x86_64-535.161.08.run --no-cc-version-check
```

## 遇到的问题及解决方案

问题描述

```text
An error occurred while performing the step: "Building kernel modules".
执行“构建内核模块”步骤时发生错误。
```

解决方案

```bash
sudo apt install gcc-12 g++-12
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 40
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 50

sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 40
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-2 50
```

大致原因就是Ubuntu 22.04 的内核是使用gcc12编译的，而Ubuntu 22.04 默认安装的gcc的gcc11，只要将gcc升级至gcc12就不会有报错

参考链接 <https://forums.developer.nvidia.com/t/driver-install-fails-with-the-error-an-error-occurred-while-performing-the-step-building-kernel-modules-see-var-log-nvidia-installer-log/280385>