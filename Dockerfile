FROM centos:7
ENV PATH $PATH:/usr/local/bin
#拷贝文件
# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak && \
#curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && yum makecache && \

RUN echo 'export LC_ALL=C' >> ~/.bashrc && source ~/.bashrc && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && yum -y install epel-release && yum install -y /usr/bin/applydeltarpm  wget gcc gcc-c++ ncurses ncurses-devel bison libgcrypt perl automake autoconf libtool make  libxml2 libxml2-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel curl curl-devel php-mcrypt libmcrypt libmcrypt-devel openssl-devel gd mcrypt mhash libicu-devel && yum clean all  && \
#COPY FILES  
mkdir -p /usr/local/src && wget -O /usr/local/src/php73.tar.gz  https://github.com/mimicode/php73/raw/master/php73.tar.gz && tar zxvf  /usr/local/src/php73.tar.gz -C /usr/local/src  && \
cd /usr/local/src/php-files && ls | xargs -n1 tar xzvf  && \
# ADD USER
groupadd www && useradd -r -g www www  && \ 
# install 7.3 ===
# update libzip > 1.0 
yum remove libzip -y  && \
cd /usr/local/src/php-files/libzip-1.2.0 && ./configure && make && make install && cd && rm -rf /usr/local/src/php-files/libzip-1.2.0  && \
# cp cancel -i 
\cp -f /usr/local/lib/libzip/include/zipconf.h /usr/local/include/zipconf.h  && \
cd /usr/local/src/php-files/libmemcached-1.0.18 && ./configure && make && make install   && \
cd /usr/local/src/php-files/php-7.3.16 && ./configure  --prefix=/usr/local/php73 --enable-fpm --enable-pcntl --enable-bcmath --with-curl --with-gd --with-freetype-dir --enable-intl --with-mysql-sock=/tmp/mysqld.sock --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-libxml-dir=/usr/lib64 --with-mhash --enable-sockets --with-png-dir=/usr/lib64 --with-jpeg-dir=/usr/lib64 --with-zlib --enable-opcache --enable-zip --enable-mbstring --with-openssl --with-pcre-regex && make && make install && cd && rm -rf /usr/local/src/php-files/php-7.3.16  && \
\cp -f /usr/local/src/config/php73.ini /usr/local/php73/lib/php.ini  && \
\cp -f /usr/local/src/config/www73.conf /usr/local/php73/etc/php-fpm.d/www.conf  && \
ln -s /usr/local/php73/bin/php /usr/local/bin/php73   && \
# php7.3 redis 
cd /usr/local/src/php-files && tar zxvf /usr/local/src/php-files/redis-5.2.1.tgz && cd /usr/local/src/php-files/redis-5.2.1 && /usr/local/php73/bin/phpize && ./configure --with-php-config=/usr/local/php73/bin/php-config && make && make install && cd && rm -rf /usr/local/src/php-files/redis-5.2.1  && \
# php7.3 memcached
cd /usr/local/src/php-files && tar zxvf /usr/local/src/php-files/memcached-3.1.5.tgz && cd /usr/local/src/php-files/memcached-3.1.5  && /usr/local/php73/bin/phpize && ./configure --with-php-config=/usr/local/php73/bin/php-config --disable-memcached-sasl && make && make install && cd && rm -rf /usr/local/src/php-files/memcached-3.1.5  && \
#php7.3 apcu
cd /usr/local/src/php-files && tar zxvf /usr/local/src/php-files/apcu-5.1.11.tgz && cd /usr/local/src/php-files/apcu-5.1.11 && /usr/local/php73/bin/phpize && ./configure --with-php-config=/usr/local/php73/bin/php-config && make && make install && cd && rm -rf /usr/local/src/php-files/apcu-5.1.11  && \
# CONFIG PHP7.3  
ln -s /usr/local/php73/bin/php /usr/local/bin/php  && ln -s /usr/local/php73/sbin/php-fpm /usr/local/bin/php-fpm  && ln -s /usr/local/php73/bin/php-config /usr/bin/php-config && ln -s /usr/local/php73/bin/phpize /usr/bin/phpize  && \
# install swoole
cd /usr/local/src/php-files/swoole-src-4.4.17 &&  /usr/local/php73/bin/phpize  && ./configure --with-php-config=/usr/local/php73/bin/php-config --enable-openssl --enable-http2 &&  make && make install  && \
# INSTALL PHPINIT
mv /usr/local/src/phpunit-9.1.1.phar /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit  && \
# install composer
mv /usr/local/src/composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer  && \
#REMOVE FILES
rm -rf /usr/local/src/nginx-files/* && rm -rf /usr/local/src/php-files/* && rm -rf /usr/local/src/config/*
#CONFIG AUTO START
CMD [ "/usr/local/php73/sbin/php-fpm","--nodaemonize","-c","/usr/local/php73/lib/php.ini","-y","/usr/local/php73/etc/php-fpm.d/www.conf" ]  
EXPOSE 9000