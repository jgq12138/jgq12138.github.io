---
title: Ubuntu update-alternatives
date: 2025-08-07 11:14:17
tags:
---

# Ubuntu中update-alternatives命令使用教程
update-alternatives是Ubuntu中管理软件多版本切换的强大工具，特别适用于需要同时维护多个版本的环境（如Java、Python、GCC等）。

## 一、命令概述

主要功能
- 管理系统命令的多个备选版本
- 通过符号链接实现版本切换
- 提供交互式选择界面
- 适用于需要同时安装多个版本的环境

基本语法

```bash
sudo update-alternatives [选项] --config <命令名>
```

## 二、核心概念解析

|概念|	说明|
|:---|:---|
|备选组 (Group)	|同一命令的不同版本集合（如java组包含openjdk-11和openjdk-17）|
|主链接 (Link)	|实际指向当前使用版本的符号链接（如/usr/bin/java）|
|优先级 (Priority)	|数值越大优先级越高，自动模式会选择优先级最高的版本|

## 三、常用操作指南

1. 查看所有备选组

```bash
update-alternatives --list
```

2. 添加新备选项

```bash
sudo update-alternatives --install <链接路径> <命令名> <实际路径> <优先级>
```

示例（添加Java 17）：

```bash
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-17/bin/java 1700
```

3. 切换版本（交互式）

```bash
sudo update-alternatives --config java
```

输出示例：
```text
有 3 个候选项可用于替换 java (提供 /usr/bin/java)。

  选择       路径                                          优先级  状态
------------------------------------------------------------
* 0            /usr/lib/jvm/jdk-11/bin/java                   1100      自动模式
  1            /usr/lib/jvm/jdk-8/bin/java                    1080      手动模式
  2            /usr/lib/jvm/jdk-11/bin/java                   1100      手动模式
  3            /usr/lib/jvm/jdk-17/bin/java                   1700      手动模式

按<回车键>保留当前值[*]，或键入选择编号：
```

4. 非交互式切换（脚本中使用）

```bash
sudo update-alternatives --set java /usr/lib/jvm/jdk-17/bin/java
```

5. 删除备选项

```bash
sudo update-alternatives --remove java /usr/lib/jvm/jdk-8/bin/java
```

6. 查看当前配置信息

```bash
update-alternatives --display java
```

## 四、实际应用示例：管理Java版本

安装多个Java版本

```bash
sudo apt install openjdk-8-jdk openjdk-11-jdk openjdk-17-jdk
```

配置Java环境

```bash
# 添加备选项
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/bin/java 1080
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-11-openjdk-amd64/bin/java 1100
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1700

# 切换版本
sudo update-alternatives --config java
```

验证当前版本

```bash
验证当前版本
```

## 五、高级技巧

同时切换相关命令组
对于Java开发，同时切换java、javac和jar：

```bash
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config jar
```

查看所有配置

```bash
update-alternatives --get-selections
```

重置为自动模式

```bash
sudo update-alternatives --auto java
```

## 六、注意事项

- 权限要求：修改配置需要sudo权限
- 路径验证：添加前确保二进制文件路径正确
- 依赖关系：某些工具链（如GCC）有相互依赖的组件
- 环境变量：PATH中应包含/usr/bin（默认已配置）
- 删除顺序：先删除备选项再卸载软件包更安全

## 七、常见问题解决
Q：切换后版本未生效？
A：检查PATH顺序，尝试新终端会话

Q：命令不在备选组中？
A：确认是否已正确添加到alternatives系统

Q：如何完全移除备选组？

```bash
sudo update-alternatives --remove-all java
```
提示：通过--help查看完整帮助：

```bash
update-alternatives --help
```