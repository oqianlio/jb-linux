# jb-linux

Ubuntu/Debian 服务器脚本工具集，解决网络代理和 Docker 镜像源配置问题。

## 脚本说明

### proxy-global
系统级全局代理开关。配置 systemd 环境变量和 `/etc/environment`，支持 HTTP/HTTPS/SOCKS5。

### docker-proxy
Docker 守护进程代理管理。独立于系统代理，通过 systemd 配置文件管理，重启后持久生效。

### docker-mirror
Docker 镜像源切换工具。预设 6 个公共免费镜像源，支持自定义、备份恢复和连通性测试。

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
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/network/proxy-global)"

# docker-mirror
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/oqianlio/jb-linux/main/docker/docker-mirror)"
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

## 注意事项

- 所有脚本必须使用 `sudo` 运行
- proxy-global 修改后需执行 `source /etc/environment` 或重新登录生效
- docker-proxy 和 docker-mirror 会自动备份原配置（`.bak` 后缀）
