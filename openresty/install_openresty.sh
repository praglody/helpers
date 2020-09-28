#! /bin/bash

set -e
set -x

urls=(
    "https://openresty.org/download/openresty-1.17.8.2.tar.gz"
    "http://zlib.net/zlib-1.2.11.tar.gz"
    "http://mirror.wibliss.com/pcre-8.44.tar.gz"
    "http://mirror.wibliss.com/openssl-1.1.1f.tar.gz"
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
elif which yum > /dev/null; then
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

if [ -d /usr/local/openresty ]; then
   echo "openresty already installed!"
   #exit 1
fi

work_dir="/usr/local/src/install_openresty"
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

cd openresty
./configure --user=www --group=www \
    --prefix=/usr/local/openresty \
    --with-http_iconv_module \
    --with-http_realip_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_gzip_static_module \
    --with-http_sub_module \
    --with-stream --with-stream_ssl_module \
    --with-stream_realip_module \
    --with-pcre=../pcre --with-pcre-jit \
    --with-zlib=../zlib \
    --with-openssl=../openssl
make && make install

ln -sf /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/openresty
