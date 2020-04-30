#!/bin/bash

export PATH=/bin:/usr/bin:/sbin/usr/sbin:/usr/local/bin:/usr/local/sbin:~/.bin
read -p "please input your domain: " domain
sed "s/yourdomain/${domain}/" client.yaml > client_release.yaml
sed "s/yourdomain/${domain}/" proxy.yaml > proxy_release.yaml
sed "s/yourdomain/${domain}/" template.nginx.conf > nginx.conf
yaml2json client_release.yaml > client.json
yaml2json proxy_release.yaml > proxy.json
yaml2json server.yaml > server.json
echo "pelase move the v2ray.service to /etc/init.d/v2ray and grant execution authority for it"
