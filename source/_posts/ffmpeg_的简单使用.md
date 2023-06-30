---
title: ffmpeg 的简单使用
date: 2023-06-19 18:05:00
tags: Linux
---

## 1、保存视频

```bash
ffmpeg -i input -vcodec copy -acodec copy output
```

## 2、转码

```bash
ffmpeg -i input -vcodec h264 -an -y output
```

## 推流

```bash
ffmpeg -re -stream_loop -1 -i imput -r 25 -an -vcodec copy -f rtsp 视频流地址
```

## 截图

```bash
ffmpeg -rtsp_transport tcp -i rtsp://192.168.99.148/jtwf/1102E/000000_001 -vf scale=1920:1080 -r 1 -vframes 1 -an -vcodec mjpeg 000000_001.jpg
```

[ffmpeg常用参数一览表](https://www.cnblogs.com/mwl523/p/10856633.html)
ffmpeg 常用参数总结：

|功能|参数|
|----|---|
|tcp协议拉流|-rtsp_transport tcp|
|循环读取文件|-stream_loop -1|
|修改分辨率|-vf scale=1280:720|
|不重新编解码|-vcodec copy -acodec copy|
|重新编解码|-vcodec h254|
|分割视频|-ss 指定开始时间 -t 需要多长时间|

## 特殊字符处理

- 转义

如：ffplay -i rtsp://root:Hik@2021!@15.144.124.204/Streaming/Channels/101
转义后：ffplay -i rtsp://root:Hik\@2021\!@15.144.124.204/Streaming/Channels/101
