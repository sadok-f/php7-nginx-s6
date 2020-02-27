FROM php:7.3-fpm-stretch

MAINTAINER sadoknet@gmail.com
ENV DEBIAN_FRONTEND=noninteractive

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

RUN \
  	apt-get -y update && \
  	apt-get -y install --no-install-recommends \
  	nginx zip unzip\
    gcc nasm build-essential make wget vim git && \
    rm -rf /var/lib/apt/lists/*

#opcache
RUN docker-php-ext-install opcache mysqli pdo_mysql

#xdebug
RUN pecl install xdebug && \
    echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "expose_php=off" > /usr/local/etc/php/conf.d/expose_php.ini

#composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#disable output access.log to stdout
RUN sed -i -e 's#access.log = /proc/self/fd/2#access.log = /proc/self/fd/1#g'  /usr/local/etc/php-fpm.d/docker.conf

#copy etc/
COPY resources/etc/ /etc/

ENV PORT 80

COPY resources/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ADD . /var/www/html
WORKDIR /var/www/html

ENTRYPOINT ["docker-entrypoint", "/init"]
