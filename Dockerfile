FROM debian:wheezy

# Prepare basic deps   
RUN apt-get update && apt-get install -y wget build-essential

# Prepare repositories
RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list \
  && echo "deb-src http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list \
  && wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg 
 
RUN apt-get install -y libicu48 libicu-dev php5-cli php5-dev php5-curl php5-pgsql php-pear libpcre3-dev \
  && apt-get clean purge autoremove -y && rm -rf /var/lib/apt/lists/*
RUN pecl install msgpack redis mongo intl \
  && php5enmod msgpack redis mongo intl

# allow manipulation with ENV variables
RUN sed -i 's/variables_order = .*/variables_order = "EGPCS"/' /etc/php5/cli/php.ini \
	&& sed -i 's/safe_mode_allowed_env_vars = .*/safe_mode_allowed_env_vars = ""/' /etc/php5/cli/php.ini


WORKDIR /usr/local/src/ 
RUN wget https://github.com/phalcon/cphalcon/archive/phalcon-v1.3.4.tar.gz -O -| tar zx \ 
  && cd cphalcon-phalcon-v1.3.4/build && ./install \ 
  && rm -rf /usr/local/src/cphalcon-phalcon-v1.3.4 \
  && echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini

# Install Composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/bin --filename=composer
