#! /bin/bash
clear

HOST=$1
USER_NAME=$2
USER_PASS=$3

yum -y install socat
curl  https://get.acme.sh | sh
alias acme.sh=~/.acme.sh/acme.sh

# 打开80和443端口
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
systemctl restart firewalld.service

# 生成证书
bash ~/.acme.sh/acme.sh  --issue -d $HOST --standalone

# 证书更新时自动copy证书
bash ~/.acme.sh/acme.sh  --installcert  -d $HOST  \
        --cert-file /root/server.cert.pem \
        --key-file   /root/server.pem \
        --fullchain-file /root/ca.cert.pem

# 下载VPN部署脚本
wget --no-check-certificate https://raw.githubusercontent.com/ParallelWorld/one-key-ikev2-vpn/master/one-key-ikev2.sh
chmod +x one-key-ikev2.sh
bash one-key-ikev2.sh $HOST $USER_NAME $USER_PASS