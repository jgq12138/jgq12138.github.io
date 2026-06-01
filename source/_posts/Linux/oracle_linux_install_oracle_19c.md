---
title: Oracle linux install oracle 19c databases
tags: Linux
date: 2026-06-01 09:42:13
---

# Oracle linux install oracle 19c databases



## Oracle Database 19c Installation On Oracle Linux 8 (OL8)

vim /etc/hosts

192.168.56.107  ol8-19.localdomain  ol8-19

Oracle 安装前置条件
执行自动设置或手动设置以完成基本前提。所有安装均需额外设置。

自动设置
如果你打算使用“oracle-database-preinstall-19c”包来完成所有前置设置，请执行以下命令。

```bash
dnf install -y oracle-database-preinstall-19c
```

```bash
vim /etc/sysctl.d/98-oracle.conf

## 
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
kernel.panic_on_oops = 1
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500

/sbin/sysctl -p /etc/sysctl.d/98-oracle.conf
```

```bash
vim /etc/security/limits.d/oracle-database-preinstall-19c.conf

## 
oracle   soft   nofile    1024
oracle   hard   nofile    65536
oracle   soft   nproc    16384
oracle   hard   nproc    16384
oracle   soft   stack    10240
oracle   hard   stack    32768
oracle   hard   memlock    134217728
oracle   soft   memlock    134217728
```

```bash
vim /etc/oracle-release

Oracle Linux Server release 8.10
```

以下套餐列为必需品。不用担心有些没安装。这不会阻止安装。

```bash
dnf install -y bc    
dnf install -y binutils
#dnf install -y compat-libcap1
dnf install -y compat-libstdc++-33
#dnf install -y dtrace-modules
#dnf install -y dtrace-modules-headers
#dnf install -y dtrace-modules-provider-headers
#dnf install -y dtrace-utils
dnf install -y elfutils-libelf
dnf install -y elfutils-libelf-devel
dnf install -y fontconfig-devel
dnf install -y glibc
dnf install -y glibc-devel
dnf install -y ksh
dnf install -y libaio
dnf install -y libaio-devel
#dnf install -y libdtrace-ctf-devel
dnf install -y libXrender
dnf install -y libXrender-devel
dnf install -y libX11
dnf install -y libXau
dnf install -y libXi
dnf install -y libXtst
dnf install -y libgcc
dnf install -y librdmacm-devel
dnf install -y libstdc++
dnf install -y libstdc++-devel
dnf install -y libxcb
dnf install -y make
dnf install -y net-tools # Clusterware
dnf install -y nfs-utils # ACFS
dnf install -y python # ACFS
dnf install -y python-configshell # ACFS
dnf install -y python-rtslib # ACFS
dnf install -y python-six # ACFS
dnf install -y targetcli # ACFS
dnf install -y smartmontools
dnf install -y sysstat

# Added by me.
dnf install -y gcc
dnf install -y unixODBC

# New for OL8
dnf install -y libnsl
dnf install -y libnsl.i686
dnf install -y libnsl2
dnf install -y libnsl2.i686
```

Set secure Linux to permissive by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
```text
SELINUX=permissive
```
Once the change is complete, restart the server or run the following command.
```bash
setenforce Permissive
```
If you have the Linux firewall enabled, you will need to disable or configure it, as shown here. To disable it, do the following.
```bash
systemctl stop firewalld
systemctl disable firewalld
```
If you are not using Oracle Linux and UEK, you will need to manually disable transparent huge pages.

Create the directories in which the Oracle software will be installed.

```bash
mkdir -p /u01/app/oracle/product/19.0.0/dbhome
mkdir -p /u02/oradata
chown -R oracle:oracle /u01 /u02
chmod -R 775 /u01 /u02
```

环境变量设置

```export
export TMP=/tmp
export TMPDIR=${TMP}

export ORACLE_HOSTNAME=ol8-19.localdomain
export ORACLE_UNQNAME=cdb1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/19.0.0/dbhome
export ORA_INVENTORY=/u01/app/oraInventory
export ORACLE_SID=cdb1
export PDB_NAME=pdb1
export DATA_DIR=/u02/oradata

export PATH=/usr/sbin:/usr/local/bin:${PATH}
export PATH=${ORACLE_HOME}/bin:${PATH}

export LD_LIBRARY_PATH=${ORACLE_HOME}/lib:/lib:/usr/lib
export CLASSPATH=${ORACLE_HOME}/jlib:${ORACLE_HOME}/rdbms/jlib
```

```bash
cat > /home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=${TMP}

export ORACLE_HOSTNAME=ol8-19.localdomain
export ORACLE_UNQNAME=cdb1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/19.0.0/dbhome
export ORA_INVENTORY=/u01/app/oraInventory
export ORACLE_SID=cdb1
export PDB_NAME=pdb1
export DATA_DIR=/u02/oradata

export PATH=/usr/sbin:/usr/local/bin:${PATH}
export PATH=${ORACLE_HOME}/bin:${PATH}

export LD_LIBRARY_PATH=${ORACLE_HOME}/lib:/lib:/usr/lib
export CLASSPATH=${ORACLE_HOME}/jlib:${ORACLE_HOME}/rdbms/jlib
EOF
```

Create a "start_all.sh" and "stop_all.sh" script that can be called from a startup/shutdown service. Make sure the ownership and permissions are correct.

```bash
cat > /home/oracle/scripts/start_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart ${ORACLE_HOME}
EOF


cat > /home/oracle/scripts/stop_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut ${ORACLE_HOME}
EOF

chown -R oracle:oinstall /home/oracle/scripts
chmod u+x /home/oracle/scripts/*.sh
```
安装

这里需要在oracle的用户下,推荐是先logout,后重新登录,这样可以加载之前配置的环境变量,顺便可以检查一下环境变量是否正常加载了
```bash

groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper 

useradd -u 54321 -g oinstall -G dba,oper oracle
cd ${ORACLE_HOME}
unzip -oq /path/to/software/LINUX.X64_193000_db_home.zip

# 将oracle用户添加到oper组
usermod -aG oper oracle

# Fake Oracle Linux 7.
export CV_ASSUME_DISTID=OEL7.6

# 利用X服务器把可视化界面传输到自己的笔记本，也就是远程可视化界面，本机安装时不用
export DISPLAY=10.99.98.4:0.0

## centos 8 等没有/opt/rh/devtoolset-8 目录的补充
mkdir -p /opt/rh/devtoolset-8/root/usr/bin
ln -s /usr/bin/ar /opt/rh/devtoolset-8/root/usr/bin/
ln -s /usr/bin/as /opt/rh/devtoolset-8/root/usr/bin/

# Interactive mode.
./runInstaller

# 可以避免中文乱码，，Linux是中文的情况下推荐使用英文安装
LANG=en_US.UTF-8 ./runInstaller

# Silent mode.
./runInstaller -ignorePrereq -waitforcompletion -silent                        \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp               \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME}                                         \
    UNIX_GROUP_NAME=oinstall                                                   \
    INVENTORY_LOCATION=${ORA_INVENTORY}                                        \
    SELECTED_LANGUAGES=en,en_GB                                                \
    ORACLE_HOME=${ORACLE_HOME}                                                 \
    ORACLE_BASE=${ORACLE_BASE}                                                 \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.OSDBA_GROUP=dba                                          \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                                    \
    oracle.install.db.OSDGDBA_GROUP=dba                                        \
    oracle.install.db.OSKMDBA_GROUP=dba                                        \
    oracle.install.db.OSRACDBA_GROUP=dba                                       \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true
```

sqlplus / as sysdba

Admin1@3qazWSX

## 参考链接

https://oracle-base.com/articles/19c/oracle-db-19c-installation-on-oracle-linux-8

https://yum.oracle.com/index.html

Huawei network driver https://support.huawei.com/enterprisesearch/#/index?keyword=TM210&lang=zh&searchType=SUPE_SW&sortType=Relevance