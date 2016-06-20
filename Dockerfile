FROM php:7.0

# Howto from https://hub.docker.com/_/php/

RUN apt-get update && apt-get install -y \
    unzip \
    libpq-dev \
    libicu52 libicu-dev \
    libpng12-dev libjpeg62-turbo-dev libfreetype6-dev

RUN docker-php-ext-install -j$(nproc) opcache pdo_pgsql gd intl zip bcmath pcntl

# Insert full Git revision from the https://github.com/phpredis/phpredis repository.
ENV PHPREDIS_REVISION adbd246aa62f10211a86c98f805a72a7026dbf98 # php7 branch

RUN cd /tmp \
    && curl -fsSL https://github.com/phpredis/phpredis/archive/${PHPREDIS_REVISION}.zip -o phpredis.zip \
    && unzip phpredis.zip \
    && rm -r phpredis.zip \
    && ( \
        cd phpredis-${PHPREDIS_REVISION} \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r phpredis-${PHPREDIS_REVISION} \
    && docker-php-ext-enable redis

RUN cd /tmp \
    && curl -fsSL https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

COPY php.ini /usr/local/etc/php/conf.d/zzz-php.ini
