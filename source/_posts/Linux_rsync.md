---
title: RSYNC 的简单使用
tags: Linux
categories : Linux 命令
abbrlink: a7f75adf
date: 2023-06-19 18:05:00
---

--progress 选项来显示进度

-z: --compress 使用压缩机制

-v: --verbose 打印详细信息

-r: --recursive 以递归模式同步子目录

-l, --links: 将符号链接当作符号链接文件拷贝, 不拷贝符合链接指向的文件内容.

-p, --perms: 保留文件权限

-t, --times: 保留修改时间戳

-g, --group: 保留用户组信息

-o, --owner: 保留用户信息(需要超级用户权限)

-D, 相当于 --devices --specials 的组合, 保留设备文件, 保留特殊文件.

rsync -avrptg --progress /home/admin123/miniodata/events/wf/ /home/admin123/huawei/

------------------------------------------------------------------------------------------------

## 下面是rsync中可用选项的简短摘要。请参阅下面的详细说明以获得完整的说明

|短参数| 长参数              | 英文解析                                           | 中文解析                                         |
|:--- |    :----            |:---                                               |:---                                             |
|-v,|--verbose              |increase verbosity                                 |增加详细信息                                        |
|   |--info=FLAGS           |fine-grained informational verbosity               |细粒度的信息冗长                                    |
|   |--debug=FLAGS          |fine-grained debug verbosity                       |细粒度的调试细节                                    |
|   |--msgs2stderr          |special output handling for debugging              |调试专用输出处理                                    |
|-q,|--quiet                |suppress non-error messages                        |抑制非错误消息                                      |
|   |--no-motd              |suppress daemon-mode MOTD (see manpage caveat)     |禁止守护模式MOTD(参见manpage警告)                   |
|-c,|--checksum             |skip based on checksum, not mod-time & size        |跳过基于校验和，而不是mod时间和大小                 |
|-a,|--archive              |archive mode; equals -rlptgoD (no -H,-A,-X)        |归档模式;= -rlptgoD(没有-H，-A，-X)                 |
|   |--no-OPTION            |turn off an implied OPTION (e.g. --no-D)           |关闭一个隐含的选项(例如——no-D)                      |
|-r,|--recursive            |recurse into directories                           |递归到目录                                          |
|-R,|--relative             |use relative path names                            |使用相对路径名                                      |
|   |--no-implied-dirs      |don't send implied dirs with --relative            |不要用-relative发送暗示的脏话                       |
|-b,|--backup               |make backups (see --suffix & --backup-dir)         |进行备份(参见——suffix &——backup-dir)                |
|   |--backup-dir=DIR       |make backups into hierarchy based in DIR           |将备份简化为基于DIR的层次结构                       |
|   |--suffix=SUFFIX        |set backup suffix (default ~ w/o --backup-dir)     |设置备份后缀(默认~ w/o——backup-dir)                 |
|-u,|--update               |skip files that are newer on the receiver          |跳过接收端上更新的文件                              |
|   |--inplace              |update destination files in-place (SEE MAN PAGE)   |就地更新目标文件(参见手册页)                        |
|   |--append               |append data onto shorter files                     |将数据追加到较短的文件中                            |
|   |--append-verify        |like --append, but with old data in file checksum  |类似于——append，但在文件校验和中使用旧数据          |
|-d,|--dirs                 |transfer directories without recursing             |不递归地传输目录                                    |
|-l,|--links                |copy symlinks as symlinks                          |将符号链接复制为符号链接                            |
|-L,|--copy-links           |transform symlink into referent file/dir           |转换符号链接到引用文件/目录                         |
|   |--copy-unsafe-links    |only "unsafe" symlinks are transformed             |只有“不安全”的符号链接被转换                        |
|   |--safe-links           |ignore symlinks that point outside the source tree |忽略指向源树外部的符号链接                          |
|   |--munge-links          |munge symlinks to make them safer (but unusable)   |芒格符号链接使它们更安全(但不能使用)                |
|-k,|--copy-dirlinks        |transform symlink to a dir into referent dir       |转换符号链接到一个目录到引用目录                    |
|-K,|--keep-dirlinks        |treat symlinked dir on receiver as dir             |将接收器上的符号链接dir处理为dir                    |
|-H,|--hard-links           |preserve hard links                                |保留硬链接                                          |
|-p,|--perms                |preserve permissions                               |保存权限                                            |
|-E,|--executability        |preserve the file's executability                  |保留文件的可执行性                                  |
|   |--chmod=CHMOD          |affect file and/or directory permissions           |影响文件和/或目录权限                               |
|-A,|--acls                 |preserve ACLs (implies --perms)                    |保存acl(暗示—perms)                                 |
|-X,|--xattrs               |preserve extended attributes                       |保留扩展属性                                        |
|-o,|--owner                |preserve owner (super-user only)                   |保留所有者(仅限超级用户)                            |
|-g,|--group                |preserve group                                     |保护组                                              |
|   |--devices              |preserve device files (super-user only)            |保存设备文件(只有超级用户)                          |
|   |--copy-devices         |copy device contents as regular file               |将设备内容复制为常规文件                            |
|   |--specials             |preserve special files                             |保存特殊文件                                        |
|-D |                       |same as --devices --specials                       |和——设备——特价一样                                  |
|-t,|--times                |preserve modification times                        |保留修改时间                                        |
|-O,|--omit-dir-times       |omit directories from --times                      |省略——times中的目录                                 |
|-J,|--omit-link-times      |omit symlinks from --times                         |省略——times中的符号链接                             |
|   |--super                |receiver attempts super-user activities            |接收者尝试超级用户活动                              |
|   |--fake-super           |store/recover privileged attrs using xattrs        |使用xattrs存储/恢复特权attrs                        |
|-S,|--sparse               |handle sparse files efficiently                    |有效处理稀疏文件                                    |
|   |--preallocate          |allocate dest files before writing them            |在写dest文件之前分配它们                            |
|-n,|--dry-run              |perform a trial run with no changes made           |执行不做任何更改的试运行                            |
|-W,|--whole-file           |copy files whole (without delta-xfer algorithm)    |完整复制文件(没有delta-xfer算法)                    |
|-x,|--one-file-system      |don't cross filesystem boundaries                  |不要跨越文件系统边界                                |
|-B,|--block-size=SIZE      |force a fixed checksum block-size                  |强制一个固定的校验和块大小                          |
|-e,|--rsh=COMMAND          |specify the remote shell to use                    |指定要使用的远程shell                               |
|   |--rsync-path=PROGRAM   |specify the rsync to run on the remote machine     |指定要在远程计算机上运行的rsync                     |
|   |--existing             |skip creating new files on receiver                |跳过在接收器上创建新文件                            |
|   |--ignore-existing      |skip updating files that already exist on receiver |跳过更新接收器上已经存在的文件                      |
|   |--remove-source-files  |sender removes synchronized files (non-dirs)       |发送方删除同步文件(非dirs)                          |
|   |--del                  |an alias for --delete-during                       |--delete-during的别名。                             |
|   |--delete               |delete extraneous files from destination dirs      |从目标dirs中删除无关文件                            |
|   |--delete-before        |receiver deletes before transfer, not during       |接收者在传输前删除，而不是在传输期间删除            |
|   |--delete-during        |receiver deletes during the transfer               |接收方在传输过程中删除                              |
|   |--delete-delay         |find deletions during, delete after                |查找删除期间，删除后                                |
|   |--delete-after         |receiver deletes after transfer, not during        |接收者在传输后删除，而不是在传输期间删除            |
|   |--delete-excluded      |also delete excluded files from destination dirs   |还可以从目标dirs中删除排除的文件                    |
|   |--ignore-missing-args  |ignore missing source args without error           |忽略缺少的源参数而不出错                            |
|   |--delete-missing-args  |delete missing source args from destination        |从目标中删除缺少的源参数                            |
|   |--ignore-errors        |delete even if there are I/O errors                |删除即使有I/O错误                                   |
|   |--force                |force deletion of directories even if not empty    |强制删除目录，即使不是空的                          |
|   |--max-delete=NUM       |don't delete more than NUM files                   |不要删除超过NUM个文件                               |
|   |--max-size=SIZE        |don't transfer any file larger than SIZE           |不要传输任何大于SIZE的文件                          |
|   |--min-size=SIZE        |don't transfer any file smaller than SIZE          |不要传输任何小于SIZE的文件                          |
|   |--partial              |keep partially transferred files                   |保留部分传输的文件                                  |
|   |--partial-dir=DIR      |put a partially transferred file into DIR          |将部分传输的文件放入DIR                             |
|   |--delay-updates        |put all updated files into place at transfer's end |在传输结束时，将所有更新的文件放到合适的位置        |
|-m,|--prune-empty-dirs     |prune empty directory chains from the file-list    |从文件列表中删除空目录链                            |
|   |--numeric-ids          |don't map uid/gid values by user/group name        |不要根据用户/组名映射uid/gid值                      |
|   |--usermap=STRING       |custom username mapping                            |自定义用户名映射                                    |
|   |--groupmap=STRING      |custom groupname mapping                           |自定义组名映射                                      |
|   |--chown=USER:GROUP     |simple username/groupname mapping                  |简单的用户名/组名映射                               |
|   |--timeout=SECONDS      |set I/O timeout in seconds                         |设置I/O超时时间，单位为秒                           |
|   |--contimeout=SECONDS   |set daemon connection timeout in seconds           |设置守护进程连接超时时间，单位为秒                  |
|-I,|--ignore-times         |don't skip files that match in size and mod-time   |不要跳过大小和mod-time匹配的文件                    |
|-M,|--remote-option=OPTION |send OPTION to the remote side only                |只发送OPTION到远端                                  |
|   |--size-only            |skip files that match in size                      |跳过大小匹配的文件                                  |
|   |--modify-window=NUM    |compare mod-times with reduced accuracy            |比较精度降低的现代时间                              |
|-T,|--temp-dir=DIR         |create temporary files in directory DIR            |在DIR目录下创建临时文件                             |
|-y,|--fuzzy                |find similar file for basis if no dest file        |如果没有dest文件，请查找相似的文件作为依据          |
|   |--compare-dest=DIR     |also compare destination files relative to DIR     |也比较目标文件相对于DIR                             |
|   |--copy-dest=DIR        |... and include copies of unchanged files          |...并包括未更改文件的副本                           |
|   |--link-dest=DIR        |hardlink to files in DIR when unchanged            |硬链接到文件在DIR未改变                             |
|-z,|--compress             |compress file data during the transfer             |在传输过程中压缩文件数据                            |
|   |--compress-level=NUM   |explicitly set compression level                   |显式设置压缩级别                                    |
|   |--skip-compress=LIST   |skip compressing files with a suffix in LIST       |跳过压缩带有LIST后缀的文件                          |
|-C,|--cvs-exclude          |auto-ignore files the same way CVS does            |自动忽略文件的方式与CVS相同                         |
|-f,|--filter=RULE          |add a file-filtering RULE                          |添加文件过滤规则                                    |
|-F |                       |same as --filter='dir-merge /.rsync-filter'        |一样 --filter='dir-merge /.rsync-filter'            |
|   |                       |repeated: --filter='- .rsync-filter'               |重复:--filter='- .rsync-filter'                     |
|   |--exclude=PATTERN      |exclude files matching PATTERN                     |排除匹配的文件                                      |
|   |--exclude-from=FILE    |read exclude patterns from FILE                    |从文件中读取排除模式                                |
|   |--include=PATTERN      |don't exclude files matching PATTERN               |不排除匹配PATTERN的文件                             |
|   |--include-from=FILE    |read include patterns from FILE                    |从FILE中读取包含模式                                |
|   |--files-from=FILE      |read list of source-file names from FILE           |从文件中读取源文件名列表                            |
|-0,|--from0                |all *-from/filter files are delimited by 0s        |所有*-from/filter文件都以0分隔                      |
|-s,|--protect-args         |no space-splitting; only wildcard special-chars    |没有空间分裂;只有通配符特殊字符                     |
|   |--address=ADDRESS      |bind address for outgoing socket to daemon         |为外出套接字绑定守护进程的地址                      |
|   |--port=PORT            |specify double-colon alternate port number         |指定双冒号替代端口号                                |
|   |--sockopts=OPTIONS     |specify custom TCP options                         |指定自定义TCP选项                                   |
|   |--blocking-io          |use blocking I/O for the remote shell              |对远程shell使用阻塞I/O                              |
|   |--stats                |give some file-transfer stats                      |给出一些文件传输数据                                |
|-8,|--8-bit-output         |leave high-bit chars unescaped in output           |在输出中不转义高位字符                              |
|-h,|--human-readable       |output numbers in a human-readable format          |以人类可读的格式输出数字                            |
|   |--progress             |show progress during transfer                      |在转移过程中显示进度                                |
|-P |                       |same as --partial --progress                       |和部分进展一样                                      |
|-i,|--itemize-changes      |output a change-summary for all updates            |为所有更新输出更改摘要                              |
|   |--out-format=FORMAT    |output updates using the specified FORMAT          |使用指定的格式输出更新                              |
|   |--log-file=FILE        |log what we're doing to the specified FILE         |记录我们对指定的FILE所做的事情                      |
|   |--log-file-format=FMT  |log updates using the specified FMT                |日志更新使用指定的FMT                               |
|   |--password-file=FILE   |read daemon-access password from FILE              |从FILE中读取daemon-access密码                       |
|   |--list-only            |list the files instead of copying them             |列出文件，而不是复制它们                            |
|   |--bwlimit=RATE         |limit socket I/O bandwidth                         |限制socket I/O带宽                                  |
|   |--stop-at=y-m-dTh:m    |Stop rsync at year-month-dayThour:minute           |在年-月-日小时:分钟停止rsync                        |
|   |--time-limit=MINS      |Stop rsync after MINS minutes have elapsed         |在经过MINS分钟后停止rsync                           |
|   |--outbuf=N|L|B         |set output buffering to None, Line, or Block       |将输出缓冲设置为None、Line或Block                   |
|   |--write-batch=FILE     |write a batched update to FILE                     |将批处理更新写入FILE                                |
|   |--only-write-batch=FILE|like --write-batch but w/o updating destination    |类似于——write-batch，但w/o更新目标                  |
|   |--read-batch=FILE      |read a batched update from FILE                    |从FILE中读取批处理更新                              |
|   |--protocol=NUM         |force an older protocol version to be used         |强制使用较旧的协议版本                              |
|   |--iconv=CONVERT_SPEC   |request charset conversion of filenames            |请求文件名的字符集转换                              |
|   |--checksum-seed=NUM    |set block/file checksum seed (advanced)            |设置块/文件校验和种子(高级)                         |
|   |--noatime              |do not alter atime when opening source files       |打开源文件时不更改时间                              |
|-4,|--ipv4                 |prefer IPv4                                        |                                                    |
|-6,|--ipv6                 |prefer IPv6                                        |                                                    |
|   |--version              |print version number                               |打印版本号                                          |
|-h,|--help                 |show this help (-h is --help only if used alone)   |显示这个帮助(-h是--help仅用于单独使用)|
