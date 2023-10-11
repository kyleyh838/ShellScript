#!/bin/bash

clear
echo "欢迎使用Docker&Docker-compose一键安装脚本"
echo "请确认已切换root用户执行脚本"
echo "一键脚本合集GitHub开源地址：https://github.com/kyleyh838/ShellScript"

if [ $(id -u) -eq 0 ]; then
    sudo apt update -y && sudo apt install wget -y
    clear
    echo "请选择需要执行的操作"
    echo "1.安装Docker"
    echo "2.安装Docker-compose"
    echo "退出脚本请输入任意字符"

    read choice

    case $choice in
      1)
        echo "即将安装Docker，请稍等。。。"
        wget -qO- get.docker.com | bash
        systemctl enable docker
        systemctl start docker
        clear
        echo "恭喜安装成功"
        docker -v
        ;;
      2)
        echo "即将安装Docker-compose，请稍等。。。"
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        clear
        echo "恭喜安装成功"
        docker-compose --version
        ;;
      *)
        echo "已退出脚本，期待你的再次使用"
        exit 1
        ;;
    esac
else
    echo 
    echo "Error:当前不是root用户，无法执行脚本，请切换root用户后重新执行。"
    exit 1
fi
