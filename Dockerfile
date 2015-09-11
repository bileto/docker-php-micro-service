FROM phusion/baseimage

# Prepare basic deps   
RUN apt-get update && apt-get install -y wget curl build-essential

# Prepare repositories
RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list
RUN wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg
RUN apt-get update

# Install GIT
RUN apt-get install -y git

# Install PHP5.6
RUN apt-get install -y php5-cli php5-dev

# allow manipulation with ENV variables
RUN sed -i 's/variables_order = .*/variables_order = "EGPCS"/' /etc/php5/cli/php.ini
RUN sed -i 's/safe_mode_allowed_env_vars = .*/safe_mode_allowed_env_vars = ""/' /etc/php5/cli/php.ini

# Install locale
RUN apt-get install -y libicu-dev
RUN pear channel-update pear.php.net
RUN pear upgrade PEAR
RUN pecl channel-update pecl.php.net
RUN pecl install intl

# Install PHP Curl
RUN apt-get install -y php5-curl

# Install Postgres Client
RUN apt-get install -y php5-pgsql

# Install Redis Client
RUN apt-get install -y php5-redis

# Install Phalcon
RUN apt-get install -y php5-dev libpcre3-dev gcc make git
WORKDIR /tmp
RUN git clone --depth=1 -b 1.3.4 git://github.com/phalcon/cphalcon.git /usr/local/src/cphalcon
WORKDIR /usr/local/src/cphalcon/build
RUN ./install
RUN echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini
RUN php5enmod phalcon

# Install MsgPack
WORKDIR /tmp
RUN wget -O msgpack.tar.gz https://github.com/msgpack/msgpack-php/archive/master.tar.gz
RUN tar xfvz msgpack.tar.gz
WORKDIR /tmp/msgpack-php-master
RUN phpize && ./configure
RUN make && make install
RUN echo "extension=msgpack.so" > /etc/php5/mods-available/msgpack.ini
RUN php5enmod msgpack

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Instal MongoDB driver
RUN pecl install mongo
RUN echo "\nextension=mongo.so" > /etc/php5/cli/php.ini

RUN apt-get clean
