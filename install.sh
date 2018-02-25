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

##Install libmcrypt 
echo "Install libmcrypt ..."
cd $EXTRACT_PATH/libmcrypt*
./configure --with-mcrypt-dir=$INSTALL_PATH/libmcrypt > /dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Libcrypt Install Completed."
echo

##Install libltdl 
echo "Install libltdl ..."
cd $EXTRACT_PATH/libmcrypt*/libltdl*
./configure --enable-ltdl-install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Libltdl Install Completed."
echo

##Install zlib
echo "Install zlib ..."
cd $EXTRACT_PATH/zlib*
if [[ $SYSTEM_BIT -eq 32 ]]; then
    ./configure >/dev/null 2>&1
else
    CFLAGS="-O3 -fPIC" ./configure >/dev/null 2>&1
fi
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Zlib Install Complete."
echo

##Install libpng
echo "Install libpng ..."
cd $EXTRACT_PATH/libpng*
./configure --prefix=$INSTALL_PATH/libpng >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Libpng Install Complete."
echo


##Install jpeg
echo "Install jpegsrc ..."
mkdir $INSTALL_PATH/jpeg/{bin,lib,include,man/man1} -p
cd $EXTRACT_PATH/jpeg*
[ $(echo $?) -ne 0 ] && exit 1
./configure  --prefix=$INSTALL_PATH/jpeg/ --enable-shared --enable-static >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Jpegsrc Install Complete."
echo

##Install freetype
echo "Install freetype ..."
cd $EXTRACT_PATH/freetype*
./configure --prefix=$INSTALL_PATH/freetype >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Freetype Install Complete."
echo


##Install autoconf
echo "Install autoconf ..."
cd $EXTRACT_PATH/autoconf*
./configure >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Autoconf Install Complete."
echo

##Install ncurses
echo "Install ncurses ..."
cd $EXTRACT_PATH/ncurses*
./configure --prefix=$INSTALL_PATH/ncurses --with-shared >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Ncurses Install Complete."
echo

##Install gd 
echo "Install GD ..."
cd $EXTRACT_PATH/gd*
sed -i 15s#png.h#$INSTALL_PATH/libpng/include/png.h# gd_png.c #sed命令对gd_png.c第15行进行修改，将引入的png.h库文件路径修改正确,注意，若sed匹配失败，$?衡为0
[ $(echo $?) -ne 0 ] && exit 1
./configure --prefix=$INSTALL_PATH/gd --with-jpeg=$INSTALL_PATH/jpeg/ --with-png=$INSTALL_PATH/libpng/ --with-freetype=$INSTALL_PATH/freetype/ >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "GD Install Complete."
echo

##Install apr
echo "Install apr ..."
cd $EXTRACT_PATH/apr*
./configure --prefix=$INSTALL_PATH/apr >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Apr Install Complete."
echo

##Install apr-util
echo "Install apr-util ..."
cd $EXTRACT_PATH/apr-util*
./configure --prefix=$INSTALL_PATH/apr-util --with-apr=$INSTALL_PATH/apr >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Apr-util Install Complete."
echo

##Install pcre
echo "Install pcre ..."
cd $EXTRACT_PATH/pcre*
./configure --prefix=$INSTALL_PATH/pcre >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Pcre Install Complete."
echo


##Install apache
echo "Install apache ..."
cd $EXTRACT_PATH/httpd*
./configure --prefix=$INSTALL_PATH/apache \
--enable-mods-shared=all \
--enable-deflate \
--enable-speling \
--enable-cache \
--enable-file-cache \
--enable-disk-cache \
--enable-mem-cache \
--enable-so \
--enable-expires=shared \
--enable-rewrite=shared \
--enable-static-support \
--sysconfdir=/etc/httpd \
--with-apr=$INSTALL_PATH/apr \
--with-apr-util=$INSTALL_PATH/apr-util \
--with-pcre=$INSTALL_PATH/pcre \
--disable-userdir >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Apache Install Complete."
echo

##install mysql
echo "Install mysql ..."
#6.17.1 Check Mysql user
id mysql >/dev/null 2>&1
MYSQL_USER="$(echo $?)"
#创建mysql用户组,将mysql用户添加到mysql用户组
if [[ $MYSQL_USER -ne 0 ]] ;then
    groupadd mysql
    useradd -g mysql mysql
[ $(echo $?) -ne 0 ] && exit 1
fi


##Install necessary dependice rpm package
rpm -ivh $RPM_PATH/ncurses*.rpm >/dev/null 2>&1

##Install mysql server
cd $EXTRACT_PATH/mysql*
./configure --prefix=$INSTALL_PATH/mysql \
--enable-thread-safe-client \
--with-extra-charsets=all >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Mysql Install Complete."
echo

## Install php
echo "Install php"
cd $EXTRACT_PATH/php*
./configure --prefix=$INSTALL_PATH/php \
--with-config-file-path=$INSTALL_PATH/php/etc \
--with-apxs2=$INSTALL_PATH/apache/bin/apxs \
--with-mysql=$INSTALL_PATH/mysql \
--with-libxml-dir=$INSTALL_PATH/libxml2 \
--with-png-dir=$INSTALL_PATH/libpng \
--with-jpeg-dir=$INSTALL_PATH/jpeg \
--with-freetype-dir=$INSTALL_PATH/freetype \
--with-gd=$INSTALL_PATH/gd \
--with-zlib-dir=$INSTALL_PATH/zlib \
--with-mcrypt=$INSTALL_PATH/libmcrypt \
--with-mysqli=$INSTALL_PATH/mysql/bin/mysql_config \
--enable-soap \
--enable-mbstring=all \
--with-mssql=$INSTALL_PATH/freetds \
--enable-sockets >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
make install >/dev/null 2>&1
[ $(echo $?) -ne 0 ] && exit 1
echo "Php Install Complete."
echo


##  Configure LAMP Configuation Files
# Set apache configuation file
sed -i 203aServerName\ $HOSTNAME:80 /etc/httpd/httpd.conf #在第203行后追加写入配置
[ $(echo $?) -ne 0 ] && exit 1
# Make apache server can read ".php" file
sed -i 386aAddType\ application\/x-httpd-php\ \.php /etc/httpd/httpd.conf 
[ $(echo $?) -ne 0 ] && exit 1
sed -i 386aAddType\ application\/x-httpd-php-source\ \.phps /etc/httpd/httpd.conf
[ $(echo $?) -ne 0 ] && exit 1
sed -i 386aAddType\ application\/x-httpd-php\ \.php\ \.phtml\ \.php3 /etc/httpd/httpd.conf
[ $(echo $?) -ne 0 ] && exit 1

#set apache server start runing when system start-up
cp $INSTALL_PATH/apache/bin/apachectl /etc/init.d/httpd
sed -i -e 2a#\ chkconfig:\ 234\ 71\ 29 /etc/init.d/httpd -e 2a#\ description:\ Apache\ is\ a\ World\ Wide\ Web\ server. /etc/init.d/httpd
[ $(echo $?) -ne 0 ] && exit 1
chkconfig --add httpd >/dev/null 2>&1

#Set Envirment variable
sed -i "10s%$%&:$INSTALL_PATH/apache/bin%" /root/.bash_profile 
source /root/.bash_profile

##  Configure Mysql Configuation Files
cp $EXTRACT_PATH/mysql*/support-files/my-medium.cnf /etc/my.cnf
$INSTALL_PATH/mysql/bin/mysql_install_db --user=mysql >/dev/null 2>&1

chmod +x $INSTALL_PATH/mysql/bin/* >/dev/null 2>&1
chown -R root $INSTALL_PATH/mysql >/dev/null 2>&1
chown -R mysql $INSTALL_PATH/mysql/var >/dev/null 2>&1
chgrp -R mysql $INSTALL_PATH/mysql >/dev/null 2>&1
$INSTALL_PATH/mysql/bin/mysqladmin -u root password 123456 >/dev/null 2>&1
cp $EXTRACT_PATH/mysql*/support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysqld >/dev/null 2>&1
sed -i "10s%$%&:$INSTALL_PATH/mysql/bin%" /root/.bash_profile 
source /root/.bash_profile

## Start LAMP Server
service httpd start
service mysqld start

## Clean Useless File Or Directory
rm -fr $EXTRACT_PATH