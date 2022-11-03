FROM httpd:2.4.23

# curl - useful tool for debugging in the container
# mysql-client - because we're using MySQL 5.7 on a different container
# libmysqlclient-dev - needed for mysql_config, option needed to get MYSQLI driver in compile
# gcc, make - need a C compiler to build PHP
# libxml2-dev - dependency for compiling PHP
RUN apt-get update && apt-get install -y \
    mysql-client \
    libmysqlclient-dev \
    gcc \
    libxml2-dev \
    make \
    curl \
    vim \
    sqlite3 \
    libsqlite3-dev \
    libonig-dev

RUN apt-get update && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EF0F382A1A7B6500 && \
    apt-get install -y pkg-config

RUN curl https://www.php.net/distributions/php-7.4.32.tar.gz > /tmp/php-7.4.32.tar.gz

RUN cd /tmp && tar -zxvf php-7.4.32.tar.gz
RUN cd /tmp/php-7.4.32 && \
    ./configure --with-apxs2=/usr/local/apache2/bin/apxs --with-mysql --with-mysqli=/usr/bin/mysql_config \
    && \
    make && make install
RUN rm -rf /tmp/php-7.4.32

WORKDIR /var/www/lamp-demo
RUN mkdir -p /var/log/apache2

COPY ./lamp-demo-httpd.conf /usr/local/apache2/conf/httpd.conf

EXPOSE 80

CMD ["httpd-foreground"]