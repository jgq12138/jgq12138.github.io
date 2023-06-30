# linux install minio

## download and install

```bash
https://dl.min.io/server/minio/release/linux-amd64/minio
```

## 创建minio用户

```bash
useradd -r -m -s /bin/bash minio
```

## 创建minio文件夹

```bash
mkdir bin
cd bin
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
cd ..
mkdir conf
mkdir data
```

## 写配置文件

```bash
vim ./conf/minio.conf

MINIO_VOLUMES=/home/minio/data
MINIO_OPTS="--console-address 0.0.0.0:9001 --address 0.0.0.0:9000"
MINIO_ROOT_USER=minio
MINIO_ROOT_PASSWORD=Minio@ZXAI.net
```

## 写服务文件

```bash
sudo vim /etc/systemd/system/minio.service

[Unit]
Description=Minio
Documentation=https://docs.minio.io
Wants=network.target remote-fs.target nss-lookup.target
After=network.target remote-fs.target nss-lookup.target
AssertFileIsExecutable=/usr/bin/minio

[Service]
WorkingDirectory=/usr/share/minio
User=minio
Group=minio
PermissionsStartOnly=true
EnvironmentFile=-/etc/minio/minio.conf
ExecStartPre=/bin/bash -c "[ -n \"${MINIO_VOLUMES}\" ] || echo \"Variable MINIO_VOLUMES not set in /etc/minio/minio.conf\""
ExecStart=/usr/bin/minio server $MINO_OPTS $MINIO_VOLUMES
StandardOutput=journal
StandardError=inherit
# Specifies the maximum file descriptor number that can be opened by this process

LimitNOFILE=65536
# Disable timeout logic and wait until process is stopped
TimeoutStopSec=0

# SIGTERM signal is used to stop Minio
KillSignal=SIGTERM
SendSIGKILL=no
SuccessExitStatus=0

[Install]
WantedBy=multi-user.target
```

## 启动，停止命令

```bash
sudo systemctl daemon-reload
sudo systemctl start minio.service
sudo systemctl stop minio.service
sudo systemctl restart minio.service
```

## 安装s3fs

```bash
sudo apt install s3fs
```

## 挂载命令

```bash
vim ~/.passwd_s3fs
minio:Minio@ZXAI.net
chmod 0600 ~/.passwd_s3f3
```

```bash
s3fs test /minio/ -o passwd_file=/home/deepstream/.passwd_s3fs -o url=http://15.112.116.115:9010/ -o use_path_request_style -o umask=0002 -o uid=1000,gid=1000
```

## 调试参数

```bash
-o dbglevel=info -f -o curldbg
```

## 取消挂载

```bash
fusermount -u /home/deepstream/ai/record
```

## 指定用户，权限

```bash
s3fs zxaidata ~/miniodata/ -o passwd_file=${HOME}/.passwd_s3fs -o url=http://15.112.116.115:9010/ -o use_path_request_style -o dbglevel=info -f -o curldbg -o umask=003 -o uid=1000,gid=1000
```
