#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

clear
echo "欢迎使用qbittorrent-nox 4.3.9一键安装脚本"
echo "请确认已切换root用户执行脚本"
echo "一键脚本合集GitHub开源地址：https://github.com/kyleyh838/ShellScript"

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Error：当前不是root用户，无法执行脚本，请切换root用户后重新执行！${plain}\n" && exit 1

echo -e "${yellow}正在安装qbittorrent-nox，请稍等。。。${plain}"
apt update -y && apt upgrade -y
apt install -y net-tools
apt install -y software-properties-common
add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
apt update -y
apt install qbittorrent-nox=1:4.3.9.99~202110311443-7435-01519b5e7~ubuntu20.04.1 -y
if ss -tln | grep -q ':8088 '; then
    echo -e "${red}Error:8088端口已被占用${plain}"
    echo "请输入未被占用的端口号"
    read port
else
    port=8088
fi
file_to_edit="/etc/systemd/system/qbittorrent-nox.service"
echo "[Unit]
Description=qBittorrent Command Line Client
After=network.target

[Service]
Type=forking
User=root
Group=root
UMask=007
ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=${port}
Restart=on-failure

[Install]
WantedBy=multi-user.target" > "$file_to_edit"
systemctl daemon-reload
systemctl enable qbittorrent-nox
systemctl start qbittorrent-nox

clear
echo "恭喜，qbittorrent-nox 4.3.9安装成功！"
echo -e "Web-UI访问地址：http://ip:${port}\n默认用户名密码：admin adminadmin"
exit 0
