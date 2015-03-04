FROM ubuntu:14.04

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
# RUN apt-get install -y libtool autoconf automake uuid-dev build-essential
# WORKDIR /tmp
# RUN wget http://download.zeromq.org/zeromq-4.0.5.tar.gz
# RUN tar zxvf zeromq-4.0.5.tar.gz
# WORKDIR /tmp/zeromq-4.0.5
# RUN ./configure
# RUN make && make install

# RUN apt-get install -y libzmq3 libzmq3-dev pkgconfig
# WORKDIR /tmp
# RUN wget https://github.com/mkoppanen/php-zmq/archive/master.tar.gz
# RUN tar xfvz master.tar.gz
# WORKDIR /tmp/php-zmq-master
# RUN phpize && ./configure
# RUN make && make install

# Install Phalcon
RUN apt-get install -y php5-dev libpcre3-dev gcc make git
WORKDIR /tmp
RUN git clone --depth=1 git://github.com/phalcon/cphalcon.git /usr/local/src/cphalcon
WORKDIR /usr/local/src/cphalcon/build
RUN ./install
RUN echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini
RUN php5enmod phalcon

RUN apt-get clean