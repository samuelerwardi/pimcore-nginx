FROM ubuntu:18.04

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y lsb-release vim \
    && apt-get update && apt-get install -y --no-install-recommends \
      autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ ca-certificates \
      zlib1g-dev libicu-dev libbz2-dev libmagickwand-dev libjpeg-dev libvpx-dev libxpm-dev libpng-dev libfreetype6-dev libc-client-dev \
      libkrb5-dev libxml2-dev libxslt1.1 libxslt1-dev locales locales-all \
      ffmpeg html2text ghostscript pngcrush jpegoptim exiftool poppler-utils git wget nginx curl supervisor \
      php-intl php-mbstring php-dom php-opcache php-mysqli php-bcmath php-bz2 php-gd php-curl php-soap php-xmlrpc php-pdo php-fileinfo php-exif php-zip php-xdebug php-redis php-imagick php-imap php-fpm \
    \
    && cd ~ \
    \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get autoremove -y \ 
      && apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ \
      && apt-get clean; rm -rf /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer \
    && apt-get autoremove -y

# Supervisor Config
ADD conf/supervisord.conf /supervisord.conf
RUN cat /supervisord.conf >> /etc/supervisord.conf

# Start Supervisord
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

RUN mkdir /run/php

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

ENV APACHE_DOCUMENT_ROOT /var/www/html
ENV PHP_DEBUG 1

EXPOSE 80 443 9000
CMD ["/bin/bash","/start.sh"]
