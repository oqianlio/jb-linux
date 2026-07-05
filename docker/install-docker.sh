#!/bin/bash
# Docker 一键安装 + 公共镜像加速 (无需登录) + 可用性验证
# 适用系统: Ubuntu/Debian, CentOS/RHEL 7/8/9, Fedora
# 所有镜像加速均为公共免费服务，无需登录或注册
# 脚本会自动测试 hello-world 拉取，确保加速生效

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}>>> Docker 一键安装脚本开始 (仅使用公共镜像加速，无需登录)${NC}"

# 1. 检查是否已安装 Docker
if command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker 已安装，版本：${NC}"
    docker --version
    echo -e "${YELLOW}如需重新安装请先手动卸载。退出脚本。${NC}"
    exit 0
fi

# 2. 清理旧版本
echo -e "${YELLOW}>>> 清理可能存在的旧版本 Docker...${NC}"
if command -v apt &> /dev/null; then
    sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
elif command -v dnf &> /dev/null; then
    sudo dnf remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
elif command -v yum &> /dev/null; then
    sudo yum remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
fi

# 3. 安装 Docker (根据包管理器选择)
if command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

elif command -v dnf &> /dev/null; then
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

elif command -v yum &> /dev/null; then
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

else
    echo -e "${RED}错误：未检测到 apt/dnf/yum，无法自动安装。${NC}"
    exit 1
fi

# 4. 启动并设置开机自启
sudo systemctl start docker
sudo systemctl enable docker

# 5. 配置公共镜像加速器 (全部无需登录)
echo -e "${GREEN}>>> 写入公共镜像加速配置 (无需登录)...${NC}"
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://dockerhub.timeweb.cloud",
    "https://huecker.io",
    "https://dockerhub1.com",
    "https://noohub.ru"
  ]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

# 6. 询问是否将当前用户加入 docker 组
read -p ">>> 是否将当前用户 ($USER) 加入 docker 组以免 sudo 运行？(y/N): " add_to_group
case "$add_to_group" in
    [yY]|[yY][eE][sS])
        sudo usermod -aG docker $USER
        echo -e "${GREEN}✓ 用户 $USER 已加入 docker 组。${NC}"
        echo -e "${YELLOW}  请执行 'newgrp docker' 或重新登录以使权限生效。${NC}"
        ;;
    *)
        echo -e "${YELLOW}  已跳过。后续请使用 'sudo docker' 运行命令。${NC}"
        ;;
esac

# 7. 镜像加速可用性测试
echo -e "${GREEN}>>> 测试镜像加速 (拉取 hello-world)...${NC}"
if sudo docker pull hello-world &> /dev/null; then
    echo -e "${GREEN}✓ 镜像加速生效，成功拉取 hello-world。${NC}"
else
    echo -e "${RED}✗ 拉取失败，当前公共镜像可能均已失效。${NC}"
    echo -e "${YELLOW}  请尝试手动修改 /etc/docker/daemon.json 中的 registry-mirrors 地址，"
    echo "  更换为其他可用公共镜像，然后执行：sudo systemctl restart docker"
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Docker 安装成功，公共镜像加速已配置并验证通过${NC}"
echo -e "${GREEN}  所有加速服务无需登录，开箱即用${NC}"
echo -e "${GREEN}========================================${NC}"
