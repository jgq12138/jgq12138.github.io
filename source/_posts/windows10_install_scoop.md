---
title: windows10安装scoop作为包管理器
tags: 包管理器
categories : Windows
abbrlink: 8c46519c
date: 2023-07-16 18:31:51
---

[scoop 官网](https://scoop.sh/)

scoop 官网安装会提示无法访问<https://raw.githubusercontent.com>，要么自己搭梯子访问，要么使用国内源安装(一下命令全在powershell中执行)

- 修改策略（需要管理员权限）

```bash
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- 安装前准备

通过改变Scoop安装到自定义目录

```powershell
$env:SCOOP='D:\Applications\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
# run the installer
```

通过更改`SCOOP_GLOBAL`来配置Scoop以将全局程序安装到自定义目录中

```powershell
$env:SCOOP_GLOBAL='F:\GlobalScoopApps'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')
# run the installer
```

配置Scoop以通过更改将下载存储到自定义目录`SCOOP_CACHE`

```powershell
$env:SCOOP_CACHE='F:\ScoopCache'
[Environment]::SetEnvironmentVariable('SCOOP_CACHE', $env:SCOOP_CACHE, 'Machine')
# run the installer
```

- 安装(不需要管理权限)

```bash
iwr -useb https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1 | iex
```

- 切换国内Gitee仓库

```bash
scoop config SCOOP_REPO https://github.com/ScoopInstaller/Scoop
```

- 添加软件仓库

```bash
scoop update
scoop bucket add main
```

- 推荐仓库

|仓库名称|地址|
|:---|:---|
|dorado      |<https://github.com/chawyehsu/dorado>            |
|extras      |<https://github.com/ScoopInstaller/Extras>       |
|java        |<https://github.com/ScoopInstaller/Java>         |
|lemon       |<https://github.com/hoilc/scoop-lemon>           |
|main        |<https://github.com/ScoopInstaller/Main>         |
|MorFans-apt |<https://github.com/Paxxs/Cluttered-bucket.git>  |
|nirsoft     |<https://github.com/kodybrown/scoop-nirsoft>     |
|nonportable |<https://github.com/ScoopInstaller/Nonportable>  |
|scoopcn     |<https://github.com/scoopcn/scoopcn.git>         |
|sysinternals|<https://github.com/niheaven/scoop-sysinternals> |
|versions    |<https://github.com/ScoopInstaller/Versions>     |
|zapps       |<https://github.com/kkzzhizhou/scoop-zapps.git>  |

```bash
# 添加仓库示例
scoop bucket add dorado https://github.com/chawyehsu/dorado
```

- 使用

```txt
alias      Manage scoop aliases
cache      Show or clear the download cache
cat        Show content of specified manifest.
cleanup    Cleanup apps by removing old versions
config     Get or set configuration values
create     Create a custom app manifest
depends    List dependencies for an app, in the order they'll be installed
download   Download apps in the cache folder and verify hashes
export     Exports installed apps, buckets (and optionally configs) in JSON format
help       Show help for a command
hold       Hold an app to disable updates
home       Opens the app homepage
import     Imports apps, buckets and configs from a Scoopfile in JSON format
info       Display information about an app
install    Install apps
list       List installed apps
prefix     Returns the path to the specified app
reset      Reset an app to resolve conflicts
search     Search available apps
shim       Manipulate Scoop shims
status     Show status and check for new app versions
unhold     Unhold an app to enable updates
uninstall  Uninstall an app
update     Update apps, or Scoop itself
virustotal Look for app's hash or url on virustotal.com
which      Locate a shim/executable (similar to 'which' on Linux)
```

1、更新: `scoop update`
2、搜索: `scoop search xxx`
3、安装: `scoop install xxx`,指定版本: `scoop install xxx@1.0`
4、卸载: `scoop uninstall xxx`
