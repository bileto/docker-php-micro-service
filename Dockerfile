FROM gliderlabs/alpine:3.2

RUN apk --update add wget

# Prepare repositories
#RUN apk search 

RUN apk add php-cli php-pgsql php-curl php-phalcon php-pear

RUN pecl install phpredis

RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apk/repositories \
  && echo "deb-src http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apk/repositories

RUN apk add libicu52 libicu-dev php5-cli php5-dev php5-curl php5-pgsql php5-redis php5-phalcon-1.3.4 php5-msgpack php-pear libpcre3-dev 


# todo: starsi phalcon


RUN wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg \ 
  && sudo add-apt-repository ppa:sidroberts/phalcon \
  && apt-get update \
  && apt-get install -y libicu52 libicu-dev php5-cli php5-dev php5-curl php5-pgsql php5-redis php5-phalcon-1.3.4 php5-msgpack php-pear libpcre3-dev \
  && apt-get clean purge

# allow manipulation with ENV variables
RUN sed -i 's/variables_order = .*/variables_order = "EGPCS"/' /etc/php5/cli/php.ini \
	&& sed -i 's/safe_mode_allowed_env_vars = .*/safe_mode_allowed_env_vars = ""/' /etc/php5/cli/php.ini


# Install Composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/bin --filename=composer

# Instal MongoDB driver
RUN pecl install mongo \ 
  && echo "\nextension=mongo.so" >> /etc/php5/cli/php.ini

# Install locale
RUN pecl install intl \
  && echo "\nextension=intl.so" >> /etc/php5/cli/php.ini


