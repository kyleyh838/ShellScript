#!/bin/bash

clear
echo "欢迎使用NPM一键安装脚本"
echo "请确认已切换root用户执行脚本"
echo "一键脚本合集GitHub开源地址：https://github.com/kyleyh838/ShellScript"
echo "NPM安装依赖Docker & Docker-compose，请确认是否已安装"

if [ $(id -u) -eq 0 ]; then
    if command -v docker &> /dev/null; then
        docker_installed="Docker 已安装。"
    else
        docker_installed="Docker 未安装。"
    fi
    if command -v docker-compose &> /dev/null; then
        docker_compose_installed="Docker-Compose 已安装。"
    else
        docker_compose_installed="Docker-Compose 未安装。"
    fi
    if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
    echo "正在安装NginxProxyManager，请稍等。。。"
    mkdir -p /root/data/docker_data/npm
    cd /root/data/docker_data/npm
    file_to_edit="docker-compose.yml"
    echo "version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'  #冒号左边外部端口可以改成自己服务器未被占用的端口
      - '81:81'  #冒号左边外部端口可以改成自己服务器未被占用的端口
      - '443:443'  #冒号左边外部端口可以改成自己服务器未被占用的端口
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt" > "$file_to_edit"
    docker-compose up -d
    clear
    echo "恭喜安装成功，访问地址http://ip:81，默认用户名密码:admin@example.com changeme"
    else
        echo "Error:$docker_installed，$docker_compose_installed"
        echo "是否运行Docker&Docker-compose安装脚本？(y/n):"

        read choice

        case $choice in
          y)
            bash <(curl -s https://raw.githubusercontent.com/kyleyh838/ShellScript/main/Docker/start.sh)
          ;;
          *)
            exit 1
          ;;
    fi
else
    echo 
    echo "Error:当前不是root用户，无法执行脚本，请切换root用户后重新执行。"
    exit 1
fi
