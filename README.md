# Leaf: A Simple Package Manager

## 0. 介绍

`Leaf`是一个不处理软件依赖关系, 用于定制化[Linux From Scratch](https://linuxfromscratch.org)的半自动软件构建工具。它具有发行版无关性, 在满足依赖(见第7小节)的条件下在任何发行版、任何架构下都能够运行。

---

## 1. 安装Leaf

Leaf的配置文件位于`/etc/leaf.conf`(默认)。

配置文件说明:

```
DIST_DIR               - 源码目录
BUILD_DIR              - 编译目录
PKGBUILD_DIR           - PKGBUILD目录
TRACE_DIR              - 安装文件跟踪目录
HOOK_DIR               - 钩子目录
BINARY_DIR             - 二进制包存放目录
TEMP_DIR               - 二进制包解包临时目录
INSTALLED_PACKAGES     - 已安装软件包数据库
PARALLEL_JOBS          - 构建并行数
DEFAULT_BUILD_OPTIONS  - 默认构建选项
COMPRESS_PROG          - 二进制包压缩程序
BINARY_EXT             - 二进制包文件拓展名
ENABLE_DEBUG_TREE      - 尝试使用tree命令列出编译产物
```

安装并初始化:

```sh
# root
bash INSTALL.sh
```

---

## 2. 使用Leaf

Leaf的命令格式:

```
leaf [option] [packages]
option:   prepare    准备软件但不编译或安装
          build      编译软件但不安装
          install    安装软件
          remove     删除已安装的程序
          clean      清理编译目录
          list       列出已安装的软件
          search     搜索软件, 支持模糊查询
          show       输出软件详细信息
          pack       构建并封装二进制包
          unpack     安装二进制包
```

提示: 软件升级需要先移除旧版本再安装新版本, 否则可能会造成旧版本文件残留。

---

## 3. Leaf的运行原理

读取`PKGBUILD`文件来设置变量, 进行软件构建, 通过`DESTDIR`安装方式和`find`命令记录软件包提供的文件、目录和链接。PKGBUILD的各项变量含义如下:

```
- pkgname        字符串, 软件名称
- pkgver         字符串, 软件版本号
- pkgdesc        字符串, 软件描述
- pkgurl         字符串, 软件主页/上游地址
- license        数组, 软件许可证
- sources        数组, 构建过程使用到的所有源码包和补丁
- options        数组, 构建选项, 详见第4小节
- srcdir         字符串, 构建路径(在leaf主程序中定义)
- pkgdir         字符串, 虚拟根目录(在leaf主程序中定义)
```

PKGBUILD定义的6个函数(*表示该函数必须定义, 其他函数默认为空实现):

```
- src_prepare            * 构建软件的准备阶段, 如解压源码、执行补丁
- src_build              * 构建软件的编译阶段, 并将编译产物以DESTDIR方式安装到${pkgdir}
- src_preinstall         安装软件前置操作
- src_postinstall        安装软件后置操作
- src_preremove          移除软件前置操作
- src_postremove         移除软件后置操作
```

编写PKGBUILD的一般原则: 模块见`template.PKGBUILD`, 语法必须符合`BASH`, 可以定义额外的函数(尽量不要在头部定义全局变量, 这会导致构建环境的污染, 需要手动`unset`, 推荐在函数中用`local`定义局部变量); `src_build`函数只负责编译软件, 并将其安装到`$pkgdir`, 而`src_[pre|post][install|remove]`函数只负责操作根文件系统; `Systemd`单元一般由用户手动开启或关闭。

另外, 某些软件包需要生成缓存或更改文件属性才能正常使用(见`HOOKS.md`), 需要定义特定操作的钩子文件, 模板见`template.HOOK`, 语法必须符合`BASH`。需要注意的是, `target()`中的路径需符合正则表达式。

---

## 4. 构建选项

在PKGBUILD中定义的options可以是以下字段:

- `strip`: 剥离二进制文件和库文件中的调试符号, 它可以让文件变得更小, 若您需要调试该程序, 则禁用该选项。

- `libtool`: 保留`.la`文件, 通常来说不需要这种文件, 可以设置成`!strip`来移除所有的.la文件。

- `zipman`: 对man手册进行`gzip`压缩。

---

## 5. 特性支持

- 软件包匹配。Leaf以`最短前缀匹配`查找PKGBUILD, 接受4种格式的软件包名, 一种是不带版本号的软件名(例如`gcc`), 二是带版本号的软件名(例如`gcc-<version>`), 三是加上前缀但不带版本号(如`sys-devel/gcc`), 四是完全体(如`sys-devel/gcc-<version>`)。当不能唯一确定软件包时, 将要求用户输入目标软件的前缀或版本。

- 消息记录。在软件安装完成后需要提示一段用户信息, 可在PKGBUILD调用`leaf_record_message`函数, 参数类型为字符串, 参数个数为一个或多个, 各参数将以换行形式输出到终端。

- 前后置钩子。当软件安装前后和移除前后自动完成一些操作, 如安装`desktop-file-utils`后, 后续添加或移除了`/usr/share/applications`目录中的`.desktop`文件, 则自动执行`update-desktop-database`。

---

## 6. 系统管理

请不要卸载系统的核心组件。Leaf并不负责软件的更新升级, 若您必须要这样做的话, 请先手动卸载再安装。

---

## 7. Leaf的依赖组件

强依赖:

- [Bash](https://www.gnu.org/software/bash)

- [Binutils](https://www.gnu.org/software/binutils)

- [Coreutils](https://www.gnu.org/software/coreutils)

- [File](https://www.darwinsys.com/file)

- [Findutils](https://www.gnu.org/software/findutils)

- [Gawk](https://www.gnu.org/software/gawk)

- [Grep](https://www.gnu.org/software/grep)

- [Sed](https://www.gnu.org/software/sed)

- [Gzip](http://www.gzip.org)

运行时依赖:

- [Bzip2](https://sourceware.org/bzip2)

- [Tar](https://www.gnu.org/software/tar)

- [Patch](https://savannah.gnu.org/projects/patch)

- [Xz](https://tukaani.org/xz)

- [Zstd](https://github.com/facebook/zstd)

- [UnZip](https://sourceforge.net/projects/infozip)

- [Tree](https://gitlab.com/OldManProgrammer/unix-tree)
