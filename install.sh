#!/bin/bash
UNAME=`whoami` #获得用户名
[ $UNAME != "root" ] && echo "The script only root can run " && echo  "Please switch user to root ! " && exit 1


##获取系统信息
echo "**System Information**"
echo "release : $(cat /etc/redhat-release)"
echo "hostname : $HOSTNAME"
echo "operating system : $(uname -o)"
echo "kernel version : $(uname -v)"
echo "hardware platform : $(uname -i)"
echo 

##环境变量
IPADDR=$(ifconfig eth0 | awk -F"[: ]+" 'NR==2 {print $4}')  #awk 以:或空格符(出现一次或多次,取最多次数)分隔的位于第二行的第4个元素
CENTOS_VER=$(cat /etc/redhat-release |awk -F"[ .]+" '{print $3}')   #awk 以.分隔的(出现一次或多次，取最多次数)第3个元素
SYSTEM_BIT=$(getconf LONG_BIT)   #获取系统位数
INSTALL_PATH="/usr/local"        #安装路径
SOURCEPKG_PATH="$PWD/Centos.pkg"
RPM_PATH="$PWD/rpm" 

[ ! -d $SOURCEPKG_PATH ] && mkdir -m 755 $SOURCEPKG_PATH
[ ! -d $RPM_PATH ] && mkdir -m 755 $RPM_PATH

RPM=$(ls -r $RPM_PATH)    #反序输出目录中的文件
PACKAGE=$(ls -1 $SOURCEPKG_PATH | awk -F"-" '{print $1}')

[ ! -d extract.pkg ] && mkdir -m 755 extract.pkg

EXTRACT_PATH="$PWD/extract.pkg"  #提取路径

##下载lamp资源
#cd $SOURCEPKG_PATH

#wget http://ftp.gnu.org/gnu/ncurses/ncurses-5.5.tar.gz
#wget http://apache.dataguru.cn//apr/apr-1.5.2.tar.gz
#wget http://apache.dataguru.cn//apr/apr-util-1.5.4.tar.gz
#wget http://exim.mirror.fr/pcre/pcre-8.32.tar.gz
#wget http://down1.chinaunix.net/distfiles/libxml2-2.7.2.tar.gz
#wget http://down1.chinaunix.net/distfiles/libmcrypt-2.5.7.tar.gz
#wget http://down1.chinaunix.net/distfiles/gd-2.0.33.tar.gz
#wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
#wget http://ftp.twaren.net/Unix/NonGNU//freetype/freetype-2.4.9.tar.gz
#wget ftp://ftp.simplesystems.org/pub/png/src/libpng15/libpng-1.5.23.tar.gz
#wget http://ijg.org/files/jpegsrc.v8b.tar.gz
#wget http://curl.haxx.se/download/curl-7.20.1.tar.gz
#wget http://ftp.jaist.ac.jp/pub/mysql/Downloads/MySQL-5.5/mysql-5.5.45.tar.gz
#wget http://www.apache.org/dist/httpd/httpd-2.4.17.tar.gz
#wget wget http://cn2.php.net/distributions/php-5.5.30.tar.gz


##导出资源包
echo "Start Extract Package ,Please wait for several minutes ..."

cd $SOURCEPKG_PATH 
for i in `ls -1` ;do
     tar xf $i -C $EXTRACT_PATH;
     [ $(echo $?) -ne 0 ] && exit 1;    #如果上一个命令执行错误则退出 状态码 异常1
done

echo "Complete Extract Package !"
echo 

##安装资源包

echo "Apache_Version=$(ls $SOURCEPKG_PATH/httpd* |awk -F"[-t]+" '{print $5}')"
echo "Mysql_Version=$(ls $SOURCEPKG_PATH/mysql* |awk -F"[-t]+" '{print $4}')"
echo "Php_Version=$(ls $SOURCEPKG_PATH/mysql* |awk -F"[-t]+" '{print $4}')"

echo "Start Install All Source Code , The process will take a long time , When complete will print:"
echo "Please Wait ... !!!"
echo

##省略安装gcc

##Install libxml2 
echo "Install libxml2 ..."
cd $EXTRACT_PATH/libxml2*
./configure --prefix=$INSTALL_PATH/libxml2 >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Libxml2 Install Completed ."
echo


