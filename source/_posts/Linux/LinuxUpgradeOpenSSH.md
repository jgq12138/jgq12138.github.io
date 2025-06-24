---
title: Linux Upgrade OpenSSH
date: 2025-06-24 15:35:40
tags: Linux
---

# download source

```bash
wget https://mirrors.aliyun.com/pub/OpenBSD/OpenSSH/portable/openssh-10.0p2.tar.gz
wget https://github.com/openssl/openssl/releases/download/openssl-3.5.0/openssl-3.5.0.tar.gz

tar -xf openssh-10.0p2.tar.gz
tar -xf openssl-3.5.0.tar.gz
```

# build and install openssl 

```bash
cd openssl-3.5.0
./config shared --prefix=/usr/local/openssl --openssldir=/usr/local/openssl
make && sudo make install
sudo cp /usr/local/openssl/bin/openssl /usr/local/openssl
openssl version
```

# build and install openssh

First, uninstall the remaining openssh
```bash
sudo apt remove --purge ssh openssh-client openssh-server openssh-sftp-server
```

install openssh dependency for ubuntu 

```bash
sudo apt install  zlib1g-dev libpam0g-dev libkrb5-dev libedit-dev -y
```

```bash
cd openssh-10.0p2
./configure --prefix=/usr/local/openssh --sysconfdir=/etc/ssh --with-kerberos5 --with-libedit --with-pam --with-gssapi --with-zlib --with-ssl-dir=/usr/local/openssl --with-privsep-path=/var/lib/sshd
make && sudo make install
sudo ln -s /usr/local/openssh/sbin/sshd /usr/sbin/sshd
sudo ln -s /usr/local/openssh/bin/scp /usr/bin/
sudo ln -s /usr/local/openssh/bin/sftp /usr/bin/
sudo ln -s /usr/local/openssh/bin/ssh /usr/bin/
sudo ln -s /usr/local/openssh/bin/ssh-add /usr/bin/
sudo ln -s /usr/local/openssh/bin/ssh-agent /usr/bin/
sudo ln -s /usr/local/openssh/bin/ssh-keygen /usr/bin/
sudo ln -s /usr/local/openssh/bin/ssh-keyscan /usr/bin/ 
```

# openssh service

```text
[Unit]
Description=OpenBSD Secure Shell server
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target auditd.service
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

[Service]
EnvironmentFile=-/etc/default/ssh
ExecStartPre=/usr/sbin/sshd -t
ExecStart=/usr/sbin/sshd -D $SSHD_OPTS
ExecReload=/usr/sbin/sshd -t
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartPreventExitStatus=255
Type=notify
RuntimeDirectory=sshd
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
Alias=sshd.service
```