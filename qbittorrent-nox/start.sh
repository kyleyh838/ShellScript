#!/bin/bash

clear
echo "欢迎使用qbittorrent-nox 4.3.9一键安装脚本"
echo "脚本GitHub开源地址：https://github.com/kyleyh838/ShellScript"

sudo apt update -y && sudo apt upgrade -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
sudo apt update -y
sudo apt install qbittorrent-nox=1:4.3.9.99~202110311443-7435-01519b5e7~ubuntu20.04.1 -y
file_to_edit="/etc/systemd/system/qbittorrent-nox.service"
echo "[Unit]
Description=qBittorrent Command Line Client
After=network.target

[Service]
Type=forking
User=root
Group=root
UMask=007
ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=8088
Restart=on-failure

[Install]
WantedBy=multi-user.target" > "$file_to_edit"
systemctl daemon-reload
systemctl enable qbittorrent-nox
systemctl start qbittorrent-nox

clear
echo "恭喜，qbittorrent-nox 4.3.9安装成功！"
