---
title: linux install jdk 8
date: 2023-06-19 18:05:00
tags: Linux
---

## download jdk 8

[下载地址](https://www.oracle.com/cn/java/technologies/javase/javase8-archive-downloads.html)

  ***下载： jdk-8u144-linux-x64.tar.gz***

## 配置环境

* 将下载的包解压到/usr/local/java
  
```bash
sudo tar -xf jdk-8u144-linux-x64.tar.gz -C /usr/local/java
sudo vim /etc/profile.d/java.sh

export JAVA_HOME=/usr/local/java
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
```

## 验证环境

```bash
java -version
```
