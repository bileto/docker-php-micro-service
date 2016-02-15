FROM debian:wheezy

# Prepare basic deps   
RUN apt-get update && apt-get install -y wget \
  && echo "deb http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list \
  && echo "deb-src http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list \
  && wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg && apt-get update \
  && apt-get install -y libicu48 libicu-dev php5-cli=5.6\* php5-dev=5.6\* php5-curl=5.6\* php5-pgsql=5.6\* php5-gd=5.6\* php-pear libpcre3-dev \
  && apt-get clean purge autoremove -y && rm -rf /var/lib/apt/lists/* \
  && pecl install msgpack-0.5.7 redis intl \
  && echo "extension=msgpack.so" > /etc/php5/mods-available/msgpack.ini \
  && echo "extension=redis.so" > /etc/php5/mods-available/redis.ini \
  && echo "extension=intl.so" > /etc/php5/mods-available/intl.ini \
  && php5enmod msgpack redis intl \
  && sed -i 's/variables_order = .*/variables_order = "EGPCS"/' /etc/php5/cli/php.ini \
  && sed -i 's/safe_mode_allowed_env_vars = .*/safe_mode_allowed_env_vars = ""/' /etc/php5/cli/php.ini \
  && sed -i 's/;date\.timezone =.*/date.timezone = "UTC"/' /etc/php5/cli/php.ini \
  && cd /usr/local/src/ && wget https://github.com/phalcon/cphalcon/archive/phalcon-v1.3.4.tar.gz -O -| tar zx \
  && cd cphalcon-phalcon-v1.3.4/build && ./install && cd / && rm -rf /usr/local/src/cphalcon-phalcon-v1.3.4 \
  && echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini && php5enmod phalcon \
  && rm -rf /tmp/* \
  && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/bin --filename=composer
