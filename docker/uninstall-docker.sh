#!/bin/bash
# Docker 完全卸载脚本（一键清理所有残留）
# 适用系统: Ubuntu/Debian, CentOS/RHEL 7/8/9, Fedora
# 卸载内容包括：Docker CE / docker.io / containerd / runc / 镜像、容器、卷、网络、配置

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}  Docker 完全卸载脚本${NC}"
echo -e "${YELLOW}  将删除 Docker 引擎、所有容器、镜像、卷、网络和配置文件${NC}"
echo -e "${YELLOW}========================================${NC}"

# 确认卸载
read -p ">>> 确定要彻底卸载 Docker 吗？所有数据将不可恢复！(y/N): " confirm
case "$confirm" in
    [yY]|[yY][eE][sS])
        ;;
    *)
        echo -e "${GREEN}已取消。${NC}"
        exit 0
        ;;
esac

echo -e "${YELLOW}>>> 步骤 1/5：停止所有运行中的容器和 Docker 服务...${NC}"
sudo systemctl stop docker.socket 2>/dev/null || true
sudo systemctl stop docker 2>/dev/null || true
sudo systemctl disable docker 2>/dev/null || true
sudo systemctl disable docker.socket 2>/dev/null || true

echo -e "${YELLOW}>>> 步骤 2/5：删除所有 Docker 对象（容器、镜像、卷、网络）...${NC}"
sudo docker stop $(sudo docker ps -aq) 2>/dev/null || true
sudo docker rm -f $(sudo docker ps -aq) 2>/dev/null || true
sudo docker rmi -f $(sudo docker images -q) 2>/dev/null || true
sudo docker volume rm -f $(sudo docker volume ls -q) 2>/dev/null || true
sudo docker network prune -f 2>/dev/null || true
sudo docker system prune -a -f --volumes 2>/dev/null || true

echo -e "${YELLOW}>>> 步骤 3/5：卸载 Docker 软件包...${NC}"
if command -v apt &> /dev/null; then
    sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose docker.io docker-ce-rootless-extras 2>/dev/null || true
    sudo apt autoremove -y 2>/dev/null || true
    sudo apt autoclean 2>/dev/null || true
elif command -v dnf &> /dev/null; then
    sudo dnf remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker docker-engine docker.io 2>/dev/null || true
elif command -v yum &> /dev/null; then
    sudo yum remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker docker-engine docker.io 2>/dev/null || true
fi

echo -e "${YELLOW}>>> 步骤 4/5：删除残留目录和配置文件...${NC}"
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker
sudo rm -rf /etc/systemd/system/docker.service.d
sudo rm -rf /etc/systemd/system/docker.socket.d
sudo rm -f /etc/systemd/system/docker.service
sudo rm -f /etc/systemd/system/docker.socket
sudo rm -f /etc/apt/keyrings/docker.gpg 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/docker.list 2>/dev/null || true
sudo rm -f /etc/yum.repos.d/docker-ce.repo 2>/dev/null || true
sudo rm -rf ~/.docker

echo -e "${YELLOW}>>> 步骤 5/5：重新加载 systemd...${NC}"
sudo systemctl daemon-reload 2>/dev/null || true

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Docker 已完全卸载！${NC}"
echo -e "${GREEN}  所有容器、镜像、卷、网络和配置均已清除${NC}"
echo -e "${GREEN}========================================${NC}"
