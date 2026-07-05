# Linux 服务器脚本工具集

一套用于 Ubuntu/Debian 服务器的实用脚本，主要包括：
- **proxy-global**：系统级全局代理开关（支持交互式菜单，代理地址可自定义）。
- **docker-proxy**：Docker 守护进程代理管理（独立配置，不影响系统代理）。
- **docker-mirror**：Docker 镜像源切换（预设多个公共镜像源，无需登录）。

## 使用方法

1. 下载脚本并赋予执行权限：
   ```bash
   git clone https://github.com/你的用户名/你的仓库名.git
   cd 你的仓库名
   sudo chmod +x network/* docker/*

sudo ./network/proxy-global
sudo ./network/docker-proxy
sudo ./docker/docker-mirror
