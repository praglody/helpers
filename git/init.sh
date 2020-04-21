#! /bin/bash

if [ "x$1" = "x--local"]; then
    param=""
else
    param="--global"
fi

if [ ! -e ~/.ssh/id_rsa ]; then
    read -p "please input your ssh key's comment: " comment
    ssh-keygen -t rsa -b 2048 -C "$comment"
fi

read -p "please input your git user name: " username
git config $param user.name "$username"

read -p "please input your git email: " email
git config $param user.email "$email"

# 禁止自动转换换行符
git config $param core.autocrlf false

# 禁止检测文件权限变化
git config $param core.filemode false

#拒绝提交包换混合换行符的文件
git config $param core.safecrlf true

