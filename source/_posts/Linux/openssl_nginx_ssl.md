---
title: openssl_nginx_ssl
date: 2026-07-09 17:26:54
tags: Linux
---

## 生成自签名证书（含 SAN 扩展）

- 现代浏览器要求证书必须包含 Subject Alternative Name (SAN)，否则即使导入也会报错。

```bash
openssl req -x509 -newkey rsa:2048 -nodes \
  -keyout server.key \
  -out server.crt \
  -days 365 \
  -subj "/C=CN/ST=Shanghai/L=Shanghai/O=MyOrg/OU=IT/CN=example.com" \
  -addext "subjectAltName = DNS:example.com, DNS:www.example.com, IP:192.168.1.100"
```

参数说明：

- -x509：输出自签名证书而不是证书请求
- -newkey rsa:2048 -nodes：生成 2048 位 RSA 私钥，不加密（-nodes）
- -keyout server.key：私钥保存路径
- -out server.crt：证书保存路径
- -subj：证书主题，可根据需要修改 C/ST/L/O/OU/CN
- -addext：添加 SAN 扩展，必须包含你实际访问的域名或 IP
- DNS:example.com 和 DNS:www.example.com 是域名
- IP:192.168.1.100 是可选的内网 IP，如果通过 IP 访问需添加此项

## 配置 Nginx 使用该证书

```text
server {
    listen 443 ssl;
    server_name example.com www.example.com;   # 必须与证书中的域名匹配

    ssl_certificate     /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    # 其他 SSL 优化（可选）
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        root   /var/www/html;
        index  index.html;
    }
}

# HTTP 重定向到 HTTPS（可选）
server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://$host$request_uri;
}
```

保存后执行配置检查并重载 Nginx：

```bash
nginx -t
systemctl reload nginx   # 或 nginx -s reload
```

## 在 Windows 上导入证书（受信任的根证书颁发机构）
将生成的 server.crt 拷贝到 Windows 电脑，然后按以下步骤操作:

- 双击 server.crt 文件，打开证书对话框
- 点击 “安装证书”，启动证书导入向导
- 选择 “本地计算机”（需要管理员权限），点击下一步
- 选择 “将所有的证书放入下列存储”，点击 浏览
- 在弹出的窗口中选择 “受信任的根证书颁发机构”，确定
- 点击下一步 → 完成，导入成功后会出现“导入成功”提示
- 重启浏览器（或清除 SSL 缓存），访问 https://example.com，地址栏应显示安全锁

## 针对低版本 OpenSSL 的两步生成法

如果你的 OpenSSL 不支持 -addext，可先创建扩展配置文件 san.cnf：

```ini
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = CN
ST = Shanghai
L = Shanghai
O = MyOrg
OU = IT
CN = example.com

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = example.com
DNS.2 = www.example.com
IP.1 = 192.168.1.100
```

然后执行：

```bash
# 生成私钥
openssl genrsa -out server.key 2048

# 生成证书（使用配置文件）
openssl req -x509 -new -nodes -key server.key -out server.crt -days 365 -config san.cnf
```