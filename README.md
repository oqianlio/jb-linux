# jb-linux

Ubuntu/Debian 服务器脚本工具集，解决网络代理和 Docker 镜像源配置问题。
###自用

## 脚本说明

### proxy-global
系统级全局代理开关。配置 systemd 环境变量和 `/etc/environment`，支持 HTTP/HTTPS/SOCKS5。

### docker-proxy
Docker 守护进程代理管理。独立于系统代理，通过 systemd 配置文件管理，重启后持久生效。

### docker-mirror
Docker 镜像源切换工具。预设 6 个公共免费镜像源，支持自定义、备份恢复和连通性测试。

### install-docker.sh
Docker CE 自动化安装脚本。自动检测系统环境，安装 Docker CE 最新稳定版并启用服务。

### uninstall-docker.sh
Docker 完全卸载脚本。一键停止服务、删除所有容器/镜像/卷/网络，并清理残留配置和目录。

## 文件结构

```
.
├── README.md
├── network/
│   ├── proxy-global    # 系统级全局代理
│   └── docker-proxy    # Docker 守护进程代理
└── docker/
    ├── docker-mirror      # Docker 镜像源切换
    ├── install-docker.sh  # Docker 自动安装
    └── uninstall-docker.sh # Docker 完全卸载
```

## 使用方法

### 方式一：下载脚本（推荐）

```bash
git clone https://github.com/oqianlio/jb-linux.git
cd jb-linux
sudo chmod +x network/* docker/*
```

### 方式二：远程执行（无需克隆）

```bash
# proxy-global
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/network/proxy-global)"

# docker-proxy
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/network/docker-proxy)"

# docker-mirror
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/docker/docker-mirror)"

# install-docker.sh
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/docker/install-docker.sh)"

# uninstall-docker.sh
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/docker/uninstall-docker.sh)"
```

#### ⚠️ 远程执行风险提示

远程执行脚本存在安全风险，请谨慎使用：

1. **中间人攻击风险**：网络传输过程中可能被篡改，导致执行恶意代码
2. **仓库篡改风险**：如果 GitHub 仓库被入侵，脚本内容可能被替换
3. **Root 权限风险**：所有脚本以 root 权限运行，一旦脚本被篡改可能造成系统级损害
4. **建议做法**：远程执行前，先查看脚本内容确认安全性

```bash
# 先查看脚本内容确认安全
curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/network/proxy-global
# 确认无误后再执行
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/network/proxy-global)"
```

### 2. proxy-global

```bash
sudo ./network/proxy-global        # 交互式菜单
sudo ./network/proxy-global on     # 开启代理
sudo ./network/proxy-global off    # 关闭代理
```

菜单选项：
- 1 - 开启全局代理（输入地址）
- 2 - 关闭全局代理
- 3 - 查看当前代理地址
- 4 - 退出

### 3. docker-proxy

```bash
sudo ./network/docker-proxy
```

菜单选项：
- 1 - 开启 Docker 代理
- 2 - 关闭 Docker 代理
- 3 - 测试代理连通性
- 4 - 查看状态
- 5 - 退出

### 4. docker-mirror

```bash
sudo ./docker/docker-mirror
```

菜单选项：
- 1-7 - 切换镜像源（轩辕/毫秒/DaoCloud/1Panel/AtomHub/简行/官方）
- t - 测试镜像源连通性
- r - 恢复备份配置
- c - 自定义镜像源地址
- q - 退出

### 5. install-docker.sh

```bash
sudo ./docker/install-docker.sh
```

自动完成以下操作：
- 检测系统发行版和版本
- 卸载旧版本 Docker（如有）
- 安装依赖包并添加 Docker 官方 GPG 密钥和软件源
- 安装 Docker CE 最新稳定版
- 启动并启用 Docker 服务

### 6. uninstall-docker.sh

```bash
sudo ./docker/uninstall-docker.sh
```

执行前有 y/N 确认提示，确认后自动完成：
- 停止所有运行中的容器和 Docker 服务
- 删除所有容器、镜像、卷、网络
- 卸载 Docker 相关软件包
- 删除残留目录和配置文件
- 重新加载 systemd

## 注意事项

- 所有脚本必须使用 `sudo` 运行
- proxy-global 修改后需执行 `source /etc/environment` 或重新登录生效
- docker-proxy 和 docker-mirror 会自动备份原配置（`.bak` 后缀）
