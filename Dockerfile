FROM php:8.1.11-cli
RUN apt-get update && apt-get install -y \
        libfreetype6-dev libjpeg62-turbo-dev libpng-dev libicu-dev libmemcached-dev libbz2-dev \
        libssl-dev librabbitmq-dev libxml2-dev libxslt1.1 libxslt1-dev libzip-dev libpq-dev \
        unzip libc-client-dev libkrb5-dev libtidy-dev git subversion mc nano iputils-ping \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN printf "\n" | pecl install redis \
    && printf "\n" | pecl install memcached \
    && printf "\n" | pecl install mongodb \
    && printf "\n" | pecl install xdebug \
    && printf "\n" | pecl install amqp \
    && docker-php-ext-enable redis memcached mongodb xdebug amqp \
    && docker-php-ext-install bcmath bz2 calendar exif opcache mysqli pdo_mysql pgsql pdo_pgsql intl zip soap gd xsl pcntl sockets imap tidy
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir /opt/php-rar \
    && cd /opt/php-rar \
    && git clone https://github.com/cataphract/php-rar.git . \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && cd ../ \
    && rm -rf /opt/php-rar \
    && docker-php-ext-enable rar \
    && pecl clear-cache