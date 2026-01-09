---
title: linuxInstallProftpd
date: 2026-01-09 12:19:34
tags: Linux
---

# download

[github uri](https://github.com/proftpd/proftpd.git)
```bash
git clone https://github.com/proftpd/proftpd.git
```

从GitHub下载最新发布的代码

# build

./configure --prefix=/opt/proftpd --enable-openssl --enable-nls --enable-ctrls --enable-shadow
make 
make install

add virtual user

/opt/proftpd/bin/ftpasswd --file=/opt/proftpd/etc/ftpd.passwd --name=to_zw --home=/home/to_zw --passwd --uid=1000 --gid=1000 --shell=/usr/sbin/nologin


# configure

```conf
# This is a basic ProFTPD configuration file (rename it to 
# 'proftpd.conf' for actual use.  It establishes a single server
# and a single anonymous login.  It assumes that you have a user/group
# "nobody" and "ftp" for normal operation and anon.

ServerName			"ProFTPD Default Installation"
ServerType			standalone
DefaultServer	    on
DefaultRoot         ~

# Port 21 is the standard FTP port.
Port				32121

# Don't use IPv6 support by default.
UseIPv6				off

# Umask 022 is a good standard umask to prevent new dirs and files
# from being group and world writable.
Umask				022

# To prevent DoS attacks, set the maximum number of child processes
# to 30.  If you need to allow more than 30 concurrent connections
# at once, simply increase this value.  Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
# (such as xinetd).
MaxInstances        30

# Set the user and group under which the server will run.
User				nobody
Group				nogroup

# To cause every FTP user to be "jailed" (chrooted) into their home
# directory, uncomment this line.
#DefaultRoot ~

# Normally, we want files to be overwriteable.
AllowOverwrite		on
RequireValidShell   off
AuthUserFile	    /opt/proftpd/etc/ftpd.passwd

# Bar use of SITE CHMOD by default
<Limit SITE_CHMOD>
  DenyAll
</Limit>
```

# service

```bash
sudo vim /etc/systemd/system/proftpd.service
```

```service
[Unit]
Description=Proftpd server
After=network.target remote-fs.target nss-lookup.target

[Service]
User=root
Group=root
Type=forking
WorkingDirectory=/opt/proftpd
ExecStart=/opt/proftpd/sbin/proftpd -c /opt/proftpd/etc/proftpd.conf
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=2
StartLimitInterval=0
RestartPreventExitStatus=SIGKILL

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemct start proftpd.service
sudo systemct enable proftpd.service
sudo systemct restart proftpd.service
sudo systemct stop proftpd.service
```

# 注意
虚拟用户向系统文件目录(/home/to_zw )写入时需要系统向目录赋权限,为虚拟用户创建时的uid,gid
```bash
sudo chown -R 1000:1000 /home/to_zw
```