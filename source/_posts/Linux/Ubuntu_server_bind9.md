---
title: Ubuntu Server 使用 BIND9 搭建 DNS 服务器
tags: Linux
categories: Network tool
date: 2023-10-27 18:38:42
updated: 2026-06-01 10:00:00
---

BIND9（Berkeley Internet Name Domain version 9）是互联网上部署最广泛的 DNS 服务器软件，功能强大、稳定可靠、配置灵活。本文详细介绍在 Ubuntu Server 上安装、配置、安全加固 BIND9 的方法，涵盖缓存递归解析器、权威正向/反向区域、ACL 访问控制、日志、防火墙等完整生产实践。

<!-- more -->

# 1. 安装 BIND9

```bash
sudo apt update
sudo apt install -y bind9 bind9utils bind9-doc dnsutils
```

- `bind9`：DNS 服务器守护进程 `named`
- `bind9utils`：管理工具（`rndc`、`named-checkconf`、`named-checkzone` 等）
- `bind9-doc`：参考文档
- `dnsutils`：诊断工具（`dig`、`nslookup`、`host`）

安装后 BIND9 会自动启动。验证状态与版本：

```bash
sudo systemctl status bind9
named -v
```

# 2. 配置文件结构

所有配置文件位于 `/etc/bind/`：

| 文件 | 作用 |
|------|------|
| `named.conf` | 主配置文件，`include` 引入其余文件 |
| `named.conf.options` | 全局选项（监听、转发、ACL、DNSSEC 等） |
| `named.conf.local` | 自定义区域定义 |
| `named.conf.default-zones` | 默认区域（localhost、127.in-addr.arpa 等） |
| `/var/cache/bind/` | 工作目录（缓存、从区域文件） |

`named.conf` 默认内容：

```c
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
```

# 3. 配置缓存递归解析器（Caching Resolver）

编辑 `/etc/bind/named.conf.options`，配置转发器、访问控制等：

```c
acl "trusted" {
    127.0.0.1;
    192.168.99.0/24;   // 内网段，按实际修改
};

options {
    directory "/var/cache/bind";

    // 监听地址
    listen-on port 53 { 127.0.0.1; 192.168.99.162; };
    listen-on-v6 { none; };   // 如不用 IPv6 可关闭

    // 允许查询和递归的客户端
    allow-query     { trusted; };
    allow-recursion { trusted; };

    // 禁止外部区域传送（安全）
    allow-transfer { none; };

    // 递归行为
    recursion yes;

    // 转发器：当本地无法解析时转发到上游 DNS
    forwarders {
        1.1.1.1;      // Cloudflare
        8.8.8.8;      // Google
    };
    forward first;    // 先尝试转发器，失败再递归

    // DNSSEC 验证
    dnssec-validation auto;

    // 隐藏版本号
    version "DNS Server";
    server-id none;

    // 安全加固
    minimal-responses yes;
    qname-minimization relaxed;

    // 缓存大小限制
    max-cache-size 256M;
    max-cache-ttl 604800;     // 7 天
    max-ncache-ttl 3600;      // 1 小时
};
```

> **注意**：修改后务必检查语法：`sudo named-checkconf`

# 4. 配置权威正向区域（Forward Zone）

添加区域定义到 `/etc/bind/named.conf.local`：

```c
zone "git.monitor.com" {
    type master;
    file "/etc/bind/zones/db.git.monitor.com";
    allow-query { any; };       // 允许所有客户端查询此区域
    allow-transfer { none; };   // 禁止区域传送
};
```

创建区域目录与区域文件：

```bash
sudo mkdir -p /etc/bind/zones
```

编辑 `/etc/bind/zones/db.git.monitor.com`：

```dns
$TTL    86400

@       IN      SOA     ns.git.monitor.com. admin.git.monitor.com. (
                        2026060101      ; Serial (YYYYMMDDNN)
                        3600            ; Refresh (1 小时)
                        1800            ; Retry (30 分钟)
                        604800          ; Expire (1 周)
                        86400 )         ; Negative Cache TTL (1 天)

; 权威名称服务器
@       IN      NS      ns.git.monitor.com.

; 名称服务器 A 记录
ns      IN      A       192.168.99.162

; 主机 A 记录
@       IN      A       192.168.99.162
www     IN      A       192.168.99.162
git     IN      A       192.168.99.162
```

> **Serial 规范**：每次修改区域文件都必须递增 Serial，格式建议 `YYYYMMDDNN`（年月日+序号，如 `2026060101`）。

验证区域文件：

```bash
sudo named-checkzone git.monitor.com /etc/bind/zones/db.git.monitor.com
```

# 5. 配置反向区域（Reverse Zone）

反向区域将 IP 地址映射回主机名（PTR 记录），对日志审计、邮件反垃圾等场景很重要。

在 `/etc/bind/named.conf.local` 中添加：

```c
zone "99.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.99";
    allow-query { any; };
    allow-transfer { none; };
};
```

> 区域名称格式：IP 段反写 + `.in-addr.arpa`。例如 `192.168.99.0/24` → `99.168.192.in-addr.arpa`。

编辑 `/etc/bind/zones/db.192.168.99`：

```dns
$TTL    86400

@       IN      SOA     ns.git.monitor.com. admin.git.monitor.com. (
                        2026060101      ; Serial
                        3600            ; Refresh
                        1800            ; Retry
                        604800          ; Expire
                        86400 )         ; Negative Cache TTL

@       IN      NS      ns.git.monitor.com.

162     IN      PTR     ns.git.monitor.com.
162     IN      PTR     git.monitor.com.
```

验证反向区域：

```bash
sudo named-checkzone 99.168.192.in-addr.arpa /etc/bind/zones/db.192.168.99
```

# 6. 设置文件权限与生效配置

BIND9 以 `bind` 用户运行，需确保区域文件可读：

```bash
sudo chown -R root:bind /etc/bind/zones/
sudo chmod 640 /etc/bind/zones/*
```

检查所有配置语法：

```bash
sudo named-checkconf        # 检查 named.conf
sudo named-checkzone git.monitor.com /etc/bind/zones/db.git.monitor.com
sudo named-checkzone 99.168.192.in-addr.arpa /etc/bind/zones/db.192.168.99
```

重新加载配置（无需重启服务）：

```bash
sudo rndc reload
# 或重启服务
sudo systemctl restart bind9
```

验证服务运行状态：

```bash
sudo systemctl status bind9
sudo journalctl -u bind9 -n 30 --no-pager
```

# 7. 防火墙配置

```bash
# UFW
sudo ufw allow 53/tcp comment 'BIND9 DNS TCP'
sudo ufw allow 53/udp comment 'BIND9 DNS UDP'
sudo ufw reload
```

如只需特定网段访问：

```bash
sudo ufw allow from 192.168.99.0/24 to any port 53 proto udp
```

# 8. 测试 DNS 解析

使用 `dig` 从本机或客户端测试：

```bash
# 正向解析
dig @192.168.99.162 git.monitor.com +short
dig @192.168.99.162 www.git.monitor.com +short

# 反向解析
dig @192.168.99.162 -x 192.168.99.162 +short

# 名称服务器查询
dig @192.168.99.162 ns.git.monitor.com +short

# SOA 记录
dig @192.168.99.162 git.monitor.com SOA

# 验证递归转发是否正常（应能解析外部域名）
dig @192.168.99.162 google.com +short
```

从非信任网段测试递归查询应被拒绝（返回 `refused`）：

```bash
dig @192.168.99.162 google.com     # 应显示 status: REFUSED
```

# 9. 配置日志（可选）

在 `/etc/bind/named.conf.local` 末尾添加日志配置：

```c
logging {
    channel default_log {
        file "/var/log/named/default.log" versions 3 size 10m;
        severity dynamic;
        print-time yes;
        print-severity yes;
        print-category yes;
    };

    channel query_log {
        file "/var/log/named/query.log" versions 3 size 20m;
        severity info;
        print-time yes;
    };

    category default  { default_log; };
    category queries  { query_log; };
    category security { default_log; };
};
```

创建日志目录并设置权限：

```bash
sudo mkdir -p /var/log/named
sudo chown bind:bind /var/log/named
sudo chmod 750 /var/log/named
sudo rndc reload
```

# 10. 客户端配置

## Linux 客户端

编辑 `/etc/netplan/` 下的配置文件或直接修改 `/etc/resolv.conf`：

```yaml
# /etc/netplan/60-dns.yaml 示例
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: true
      dhcp4-overrides:
        use-dns: false
      nameservers:
        search: [git.monitor.com]
        addresses: [192.168.99.162, 1.1.1.1]
```

```bash
sudo netplan apply
```

或使用 `nmcli`：

```bash
sudo nmcli con mod 'Wired connection 1' ipv4.dns 192.168.99.162
sudo nmcli con down 'Wired connection 1' && sudo nmcli con up 'Wired connection 1'
```

## Windows 客户端

网络设置 → 更改适配器选项 → IPv4 属性 → 首选 DNS 服务器设为 `192.168.99.162`。

# 11. 常见问题排查

| 问题 | 原因 | 解决 |
|------|------|------|
| `named-checkconf` 报错 | 语法错误 | 检查缺少 `;` 或括号不匹配 |
| `named-checkzone` 报 `NS 'ns...' has no address records` | NS 记录没有对应的 A 记录 | 在区域文件中添加 `ns IN A x.x.x.x` |
| 服务启动失败/循环重启 | 区域文件语法错误 | 查看日志 `journalctl -u bind9 -n 50` |
| `dig` 返回 `REFUSED` | 客户端不在 `allow-query` / `allow-recursion` 中 | 检查 ACL 配置 |
| `dig` 返回 `SERVFAIL` | DNSSEC 验证失败或权限问题 | 检查文件权限、系统时钟（NTP） |
| `rndc: connect failed: 127.0.0.1#953: connection refused` | rndc 配置问题 | 检查 `/etc/bind/rndc.key` 是否存在 |
| 修改区域文件后不生效 | 未增加 Serial 或未 reload | 递增 Serial → `sudo rndc reload` |

# 12. 安全最佳实践

1. **分离权威与递归**：生产环境应将权威 DNS 和递归解析器部署在不同服务器上
2. **关闭开放式解析**：务必使用 ACL 限制递归查询范围，防止被用于 DDoS 放大攻击
3. **禁止区域传送**：`allow-transfer { none; }`，除非有从服务器
4. **隐藏版本信息**：`version "DNS Server";`
5. **DNSSEC 验证**：保持 `dnssec-validation auto;`
6. **使用非特权用户运行**：Ubuntu 默认以 `bind` 用户运行
7. **防火墙限制**：仅允许必要网段访问 UDP/TCP 53 端口
8. **定期更新**：保持 BIND9 和系统包为最新版本

# 总结

本文从安装、缓存解析器配置、正向/反向区域、安全加固、防火墙、客户端配置到故障排查，完整覆盖了在 Ubuntu Server 上部署 BIND9 DNS 服务器的全部流程。按此文档操作后，即可搭建一台可用于内网域名解析的 BIND9 服务。
