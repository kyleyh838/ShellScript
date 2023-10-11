#!/bin/bash

clear
echo "欢迎使用NPM一键安装脚本"
echo "请确认已切换root用户执行脚本"
echo "一键脚本合集GitHub开源地址：https://github.com/kyleyh838/ShellScript"
echo "NPM安装依赖Docker & Docker-compose，请确认是否已安装"

if [ $(id -u) -eq 0 ]; then
    echo "请选择需要执行的操作"
	echo "1.安装NPM"
	echo "2.更新NPM"
	echo "3.卸载NPM"
	echo "退出脚本请输入任意字符"
	
	read choice

    case $choice in
      1)
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
			if ss -tln | grep -q ':80 '; then
			    echo "Error:80端口已被占用"
			    echo "请输入未被占用的端口号"
				read port1
			else
			    port1=80
			fi
			if ss -tln | grep -q ':81 '; then
			    echo "Error:81端口已被占用"
				echo "请输入未被占用的端口号"
				read port2
			else
			    port2=81
			fi
			if ss -tln | grep -q ':443 '; then
			    echo "Error:443端口已被占用"
				echo "请输入未被占用的端口号"
				read port3
			else
			    port3=443
			fi
            file_to_edit="docker-compose.yml"
            echo "version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '$port1:80'  #冒号左边外部端口可以改成自己服务器未被占用的端口
      - '$port2:81'  #冒号左边外部端口可以改成自己服务器未被占用的端口
      - '$port3:443'  #冒号左边外部端口可以改成自己服务器未被占用的端口
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt" > "$file_to_edit"
            docker-compose up -d
            clear
            echo "恭喜安装成功"
			echo "访问地址:http://ip:$port2"
			echo "默认用户名密码:admin@example.com changeme"
			exit 0
        else
            echo "Error:$docker_installed，$docker_compose_installed"
            echo "是否运行Docker&Docker-compose安装脚本？(y/n):"

            read choice1

            case $choice1 in
              y)
                bash <(curl -s https://raw.githubusercontent.com/kyleyh838/ShellScript/main/Docker/start.sh)
              ;;
              *)
                exit 0
              ;;
			esac
        fi
      ;;
	  2)
        directory="/root/data/docker_data/npm"
        if [ -d "$directory" ]; then
            echo "正在更新NginxProxyManager，请稍等。。。"
		    cd /root/data/docker_data/npm
		    docker-compose down
		    cp -r /root/data/docker_data/npm /root/data/docker_data/npm.archive  # 万事先备份，以防万一
		    docker-compose pull
		    docker-compose up -d
		    docker image prune
		    echo "完成，NPM已成功更新"
			exit 0
		else
    		echo "$directory目录不存在，更新个毛啊！？"
			exit 1
		fi
      ;;
	  3)
        directory="/root/data/docker_data/npm"
        if [ -d "$directory" ]; then
        	echo "正在卸载NginxProxyManager，请稍等。。。"
			cd /root/data/docker_data/npm
			docker-compose down
			rm -rf /root/data/docker_data/npm
			docker image prune
			echo "完成，NPM已成功卸载"
			exit 0
		else
    		echo "$directory目录不存在，卸载个毛啊！？"
			exit 1
		fi
      ;;
	  *)
		exit 0
      ;;
    esac
else
    echo 
    echo "Error:当前不是root用户，无法执行脚本，请切换root用户后重新执行。"
    exit 1
fi
