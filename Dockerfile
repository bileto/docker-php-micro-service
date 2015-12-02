FROM phusion/baseimage

# Prepare basic deps   
RUN apt-get update && apt-get install -y curl wget build-essential

# Prepare repositories
RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list \
  && echo "deb-src http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list \
  && wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg \ 
  && sudo add-apt-repository ppa:sidroberts/phalcon \
  && apt-get update \
  && apt-get install -y libicu52 libicu-dev php5-cli php5-dev php5-curl php5-pgsql php5-redis php5-phalcon-1.3.4 php5-msgpack php-pear libpcre3-dev \
  && apt-get clean purge

# allow manipulation with ENV variables
RUN sed -i 's/variables_order = .*/variables_order = "EGPCS"/' /etc/php5/cli/php.ini \
	&& sed -i 's/safe_mode_allowed_env_vars = .*/safe_mode_allowed_env_vars = ""/' /etc/php5/cli/php.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

# Instal MongoDB driver
RUN pecl install mongo \ 
  && echo "\nextension=mongo.so" >> /etc/php5/cli/php.ini

# Install locale
RUN pecl install intl \
  && echo "\nextension=intl.so" >> /etc/php5/cli/php.ini


