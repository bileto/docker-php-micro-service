FROM php:7.0

# Insert full Git revision from the https://github.com/phpredis/phpredis repository.
# Commit taken from php7 branch
ENV PHPREDIS_REVISION adbd246aa62f10211a86c98f805a72a7026dbf98

# Howto from https://hub.docker.com/_/php/

RUN echo "[*] Image uses PHP version ${PHP_VERSION}"

RUN set -x \
	&& echo "[*] Prerequisities..." \
	&& cd /tmp \
	&& apt-get update \
	&& echo "[*] Installing dependencies for PHP extensions..." \
	&& apt-get install -y \
		unzip \
		libpq-dev \
		libicu52 libicu-dev \
		libpng12-dev libjpeg62-turbo-dev libfreetype6-dev \
	&& echo "[*] Installing PHP extensions..." \
		&& docker-php-ext-install -j$(nproc) opcache pdo_pgsql gd intl zip bcmath pcntl \
	&& echo "[*] Installing phpredis extension..." \
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
		&& docker-php-ext-enable redis \
    && echo "[*] Installing Composer..." \
        && curl -fsSL https://getcomposer.org/installer -o composer-setup.php \
        && php -r "if (hash_file('SHA384', 'composer-setup.php') === 'bf16ac69bd8b807bc6e4499b28968ee87456e29a3894767b60c2d4dafa3d10d045ffef2aeb2e78827fa5f024fbe93ca2') { echo 'Installer verified.'.PHP_EOL; exit(0); } else { echo 'Installer corrupt.'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" \
        && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
        && rm -r composer-setup.php \
	&& echo "[*] Cleaning up..." \
	    && apt-get clean purge autoremove -y && rm -rf /var/lib/apt/lists/* \
		&& rm -rf /tmp/* \
	&& echo "[*] Done."

COPY php.ini /usr/local/etc/php/conf.d/zzz-php.ini
