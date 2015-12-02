FROM phusion/baseimage

# Prepare basic deps   
RUN apt-get install -y wget curl build-essential

# Prepare repositories
RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list \
  && echo "deb-src http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list \
  && wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg \ 
  && apt-get update \
  && apt-get install -y git php5-cli php5-dev

# allow manipulation with ENV variables
RUN sed -i 's/variables_order = .*/variables_order = "EGPCS"/' /etc/php5/cli/php.ini \
	&& sed -i 's/safe_mode_allowed_env_vars = .*/safe_mode_allowed_env_vars = ""/' /etc/php5/cli/php.ini

# Install ICU for localem PHP Curl, Postgress Client, Redis client
RUN apt-get install -y libicu52 libicu-dev php5-curl php5-pgsql php5-redis libpcre3-dev \
  && apt-get clean purge

# Install Phalcon
RUN git clone --depth=1 -b 1.3.4 git://github.com/phalcon/cphalcon.git /usr/local/src/cphalcon
WORKDIR /usr/local/src/cphalcon/build
RUN ./install \
  && echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini \
  && php5enmod phalcon

# Install MsgPack
RUN apt-get install -y php5-msgpack

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

# Instal MongoDB driver
RUN pecl install mongo \ 
  && echo "\nextension=mongo.so" >> /etc/php5/cli/php.ini

# Install locale
RUN pecl install intl \
  && echo "\nextension=intl.so" >> /etc/php5/cli/php.ini


