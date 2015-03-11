FROM phusion/baseimage

# Prepare basic deps
RUN apt-get update && apt-get install -y wget build-essential

# Prepare repositories
RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list
RUN wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg
RUN apt-get update

# Install GIT
RUN apt-get install -y git

# Install PHP5.6
RUN apt-get install -y php5-cli php5-dev

# Install Postgres Client
RUN apt-get install -y php5-pgsql

# Install Redis Client
RUN apt-get install -y php5-redis

# Install ZeroMQ Client
RUN apt-get install -y libtool autoconf automake uuid-dev build-essential
WORKDIR /tmp
RUN wget http://download.zeromq.org/zeromq-4.0.5.tar.gz
RUN tar zxvf zeromq-4.0.5.tar.gz
WORKDIR /tmp/zeromq-4.0.5
RUN ./configure
RUN make && make install

RUN apt-get install -y pkg-config
WORKDIR /tmp
RUN wget -O zmq.tar.gz https://github.com/mkoppanen/php-zmq/archive/master.tar.gz
RUN tar xfvz zmq.tar.gz
WORKDIR /tmp/php-zmq-master
RUN phpize && ./configure
RUN make && make install
RUN echo "extension=zmq.so" > /etc/php5/mods-available/zmq.ini
RUN php5enmod zmq

# Install Phalcon
RUN apt-get install -y php5-dev libpcre3-dev gcc make git
WORKDIR /tmp
RUN git clone --depth=1 git://github.com/phalcon/cphalcon.git /usr/local/src/cphalcon
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

RUN apt-get clean