#! /bin/bash
clear

HOST=$1
USER_NAME=$2
USER_PASS=$3

curl  https://get.acme.sh | sh
alias acme.sh=~/.acme.sh/acme.sh
yum install socat


# 打开80和443端口
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
systemctl restart firewalld.service

# 生成证书
acme.sh  --issue -d $HOST --standalone

# 下载VPN部署脚本
wget --no-check-certificate https://raw.githubusercontent.com/ParallelWorld/one-key-ikev2-vpn/master/one-key-ikev2.sh
chmod +x one-key-ikev2.sh
bash one-key-ikev2.sh $HOST $USER_NAME $USER_PASS