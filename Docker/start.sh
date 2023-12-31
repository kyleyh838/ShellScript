#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

clear
echo "欢迎使用Docker&Docker-Compose一键安装脚本"
echo "请确认已切换root用户执行脚本"
echo "一键脚本合集GitHub开源地址：https://github.com/kyleyh838/ShellScript"

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Error：当前不是root用户，无法执行脚本，请切换root用户后重新执行！${plain}\n" && exit 1

clear
echo "请选择需要执行的操作："
echo -e "${green}1.安装Docker${plain}"
echo -e "${green}2.安装Docker-Compose${plain}"
echo -e "${green}0.退出脚本${plain}"

read choice

case $choice in
  1)
    echo -e "${yellow}正在安装Docker，请稍等。。。${plain}"
    apt update -y && apt install wget -y
    wget -qO- get.docker.com | bash
    systemctl enable docker
    systemctl start docker
    clear
    echo "恭喜安装成功"
    docker -v
    exit 0
  ;;
  2)
    echo -e "${yellow}正在安装Docker-Compose，请稍等。。。${plain}"
    apt update -y
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    clear
    echo "恭喜安装成功"
    docker-compose --version
    exit 0
  ;;
  *)
    echo "已退出脚本，期待你的再次使用！"
    exit 0
  ;;
esac
