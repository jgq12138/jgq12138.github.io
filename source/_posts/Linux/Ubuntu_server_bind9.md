---
title: Ubuntu server 使用bind9做DNS服务
tags: Linux
categories : Network tool
date: 2023-10-27 18:38:42
---
Ubuntu 使用bind9 配置一个git.monitor.com的域名指向192.168.99.162 IP要在Ubuntu上使用Bind9配置一个git.monitor.com的域名指向192.168.99.162 IP，需要进行以下步骤：1. 确保已经安装了Bind9。如果没有安装，可以使用以下命令进行安装：```shellsudo apt-get updatesudo apt-get install bind9```2. 打开Bind9的配置文件named.conf.local，可以使用任何文本编辑器打开该文件：```shellsudo nano /etc/bind/named.conf.local```3. 在配置文件中添加以下内容：```txtzone "git.monitor.com" {    type master;    file "/etc/bind/db.git.monitor.com";};```4. 保存并关闭文件。5. 创建一个新的区域文件db.git.monitor.com，可以使用以下命令创建并编辑该文件：```shellsudo nano /etc/bind/db.git.monitor.com```6. 在文件中添加以下内容：```txt$TTL 86400@   IN   SOA  ns.git.monitor.com. admin.git.monitor.com. (              2023102701     ; Serial               3600          ; Refresh               1800          ; Retry             604800          ; Expire              86400 )        ; Minimum TTL@       IN   NS    ns.git.monitor.com.@       IN   A     192.168.99.162ns      IN   A     192.168.99.162```7. 保存并关闭文件。8. 检查Bind9配置文件是否有语法错误，可以使用以下命令进行检查：```shellsudo named-checkconf```9. 如果没有错误，重新启动Bind9服务：```shellsudo service bind9 restart```现在，git.monitor.com的域名应该已经成功指向了192.168.99.162 IP。请确保你的网络配置和主机IP设置正确，并替换相关的IP和域名信息。
