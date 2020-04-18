#! /bin/bash

read -p "please input your domain: " domain

sed "s/yourdomain/$domain/" client.yaml > client_release.yaml
sed "s/yourdomain/$domain/" template.nginx.conf > nginx.conf

yaml2json client_release.yaml > client.json
yaml2json server.yaml > server.json
