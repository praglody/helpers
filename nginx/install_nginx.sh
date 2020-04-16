#!bin/bash

set -e
set -x

urls=(
    "https://nginx.org/download/nginx-1.16.1.tar.gz"
    "http://zlib.net/zlib-1.2.11.tar.gz"
    "https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz"
    "https://www.openssl.org/source/openssl-1.1.1f.tar.gz"
)

logs_dir="/data/logs"

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: please use root to install"
    exit 1
fi

is_set_user=$(grep '^www:' /etc/passwd|wc -l)
if [ $is_set_user -eq 0 ]; then
    groupadd  www 
    useradd -g www -M -s /sbin/nologin www 
fi

# 建立日志文件夹
[ -d $logs_dir ] || mkdir -p $logs_dir && chown www:www $logs_dir

if [ $(cat /etc/issue|grep -i ubuntu|wc -l) -gt 0 ]; then
    os="ubuntu"
elif [ $(cat /etc/issue|grep -i debian|wc -l) -gt 0 ]; then
    os="debian"
elif [ $(cat /etc/centos-relesae|grep -i centos|wc -l) -gt 0 ]; then
    os="centos"
else
    os=""
fi

case $os in
    ubuntu | debian)
        apt -y install gcc g++ make autoconf
        ;;
    centos)
        yum -y install gcc gcc-c++ make autoconf
        ;;
    *)
        echo "unknow os type"
        exit 1
esac

if [ -d /usr/local/nginx ]; then
   echo "nginx already installed!"
   #exit 1
fi

work_dir="/usr/local/src/install_nginx"
if [ ! -d $work_dir ]; then
    mkdir -p $work_dir
fi

cd $work_dir
for url in ${urls[@]}; do
    soft_name=$(echo $url | awk -F'/' '{print $NF}')
    [ -e $soft_name ] || wget $url
done

ls | grep -v 'tar.gz' | xargs -i rm -rf {}
ls | xargs -i tar zxf {}
ls | grep -v 'tar.gz' | awk -F'-' '{print "mv "$0" "$1}' | bash

cd nginx
./configure --user=www --group=www \
    --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-pcre=../pcre \
    --with-zlib=../zlib \
    --with-openssl=../openssl \
    --with-stream \
    --with-stream_ssl_preread_module \
    --with-stream_ssl_module \
    --with-pcre-jit
make && make install

ln -sf /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx

