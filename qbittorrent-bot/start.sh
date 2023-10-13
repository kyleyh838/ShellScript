#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

clear
echo "欢迎使用qbittorrent-bot一键安装脚本"
echo "请确认已切换root用户执行脚本"
echo "一键脚本合集GitHub开源地址：https://github.com/kyleyh838/ShellScript"

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Error：当前不是root用户，无法执行脚本，请切换root用户后重新执行！${plain}\n" && exit 1

echo
echo "请选择需要执行的操作："
echo -e "${green}1.安装qbittorrent-bot${plain}"
echo -e "${green}2.卸载qbittorrent-bot${plain}"
echo -e "${green}0.退出脚本${plain}"
read choice
    if [[ x"${choice}" == x"1" ]]; then
        if command -v docker &> /dev/null; then
            docker_installed="Docker已安装"
        else
            docker_installed="Docker未安装"
        fi
        if command -v docker-compose &> /dev/null; then
            docker_compose_installed="Docker-Compose已安装"
        else
            docker_compose_installed="Docker-Compose未安装"
        fi
        if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
            echo -e "${yellow}正在安装qbittorrent-bot，请稍等。。。${plain}"
            apt install -y wget
            mkdir /root/qbot
            file_to_edit="/root/qbot/docker-compose.yml"
            echo "version: '3'
services: 
  qbittorrent-bot:
    container_name: qbittorrent-bot  
    image: 0one2/qbittorrent-bot:latest
    volumes:
      - /home/qbittorrent-bot/app:/app
      - /qbot-downloads:/downloads
    environment:
      - PUID=0
      - PGID=0
      - TZ=Asia/Shanghai   
    restart: unless-stopped  " > "$file_to_edit"
            cd /home
            wget -O qbot.tar.gz https://raw.githubusercontent.com/kyleyh838/ShellScript/main/qbittorrent-bot/qbot-zh.tar.gz
            tar -zxvf "qbot.tar.gz" --overwrite
            rm "qbot.tar.gz"
            cd /root/qbot
            docker-compose up -d
            mv /home/qbittorrent-bot/app/config.example.toml /home/qbittorrent-bot/app/config.toml
            clear
            echo -e "${yellow}请输入TG-BOT Token：${plain}"
            read bot_token
            echo -e "${green}请输入管理员TG-ID：${plain}"
            read tg_id
            echo -e "${yellow}请输入qBit-WebUI完整地址：${plain}"
            echo -e "${yellow}格式示例：http://127.0.0.1:8888/${plain}"
            read ui_addr
            echo -e "${green}请输入qBit用户名：${plain}"
            read qb_user
            echo -e "${yellow}请输入qBit密码：${plain}"
            read qb_passwd
            file_to_edit="/home/qbittorrent-bot/app/config.toml"
            echo "[telegram]
token = \"${bot_token}\"
admins = [${tg_id}]
workers = 1 # number of python-telegram-bot workers. One worker is more than enough
timeout = 120 # requests timeout in seconds
errors_log_chat = 0 # chat where to post exceptions. If disabled (0), the first user id in 'admins' will be used

[proxy]
url = \"\"        # socks5(h)://ip:port or http://user:pass@ip:port/
username = \"\"   # Socks only, Use url embeded user/pass for http(s)
password = \"\"   # Socks only

[notifications]
completed_torrents = 0 # id of a chat to notify when a torrent is completed. 0 to disable
no_notification_tag = \"\" # if a torrent has this tag, do not send the completed download notification in the notifications chat (if set). Case insensitive. \"\" (empty string) to disable
added_torrents = 0 # id of a chat to notify when a new torrent is added. 0 to disable

[qbittorrent]
url = \"${ui_addr}\"
# for docker user the url should not be 127.0.0.1 because the container is connected to docker0 network
# url = \"http://172.17.0.1:8080\" # docker0 network, the 172.0.0.1 is host ip addr
login = \"${qb_user}\"
secret = \"${qb_passwd}\"
added_torrents_tag = \"\" # a tag to add to the torrents added through the bot. \"\" (empty string) to disable
added_torrents_category = \"\" # the category to set for torrents added through the bot. \"\" (empty string) to disable
altspeed_presets = [
    # alternative speed buttons (in kb/s) to show when /overview is used. Set this to [] (empty list) to show no altspeed button
    # [upload, download],
    [5, 10],
    [5, 50],
    [5, 200],
]
" > "$file_to_edit"
            docker restart qbittorrent-bot
            echo
            echo "恭喜安装成功"
            echo "TG-Bot输入/help查看指令"
            exit 0
        else
            echo -e "${red}Error:$docker_installed，$docker_compose_installed，无法安装qbittorrent-bot。${plain}"
            read -p "是否运行Docker&Docker-Compose安装脚本？[y/n]:" choice1
                if [[ x"${choice1}" == x"y" || x"${choice1}" == x"Y" ]]; then
                    bash <(curl -s https://raw.githubusercontent.com/kyleyh838/ShellScript/main/Docker/start.sh)
                else
                    exit 0
                fi
        fi
    fi
    if [[ x"${choice}" == x"2" ]]; then
        echo -e "${red}Warning:本操作将会彻底删除qbittorrent-bot资料夹！${plain}\n是否继续卸载？[y/n]:"
		read  uninst
        if [[ x"${uninst}" == x"y" || x"${uninst}" == x"Y" ]]; then
            echo -e "${yellow}正在卸载qbittorrent-bot，请稍等。。。${plain}"
            ContainerID=`docker ps|grep 0one2/qbittorrent-bot|awk '{print $1}'`
            docker kill ${ContainerID}
            docker rm ${ContainerID}
            docker rmi `docker images|grep 0one2/qbittorrent-bot|awk '{print $3}'`
            rm -rf /root/qbot
            rm -rf /home/qbittorrent-bot
            rm -rf /qbot-downloads
            exit 0
        else
            exit 0
        fi
    fi
    if [[ x"${choice}" != x"1" && x"${choice}" != x"2" ]]; then
        echo "已退出脚本，期待你的再次使用！"
        exit 0
    fi
    