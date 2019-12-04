FROM php:7.2-fpm
MAINTAINER ryanwu
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxml2-dev openssl libssl-dev libevent-dev vim net-tools wget unzip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install sockets bcmath pdo_mysql gd 
RUN pecl install yaf yaconf event redis mongodb && docker-php-ext-enable yaf yaconf event redis mongodb
RUN mkdir -p /data/php/log/ && chown www-data:www-data /data/php/log && mkdir -p /data/php/run && chown www-data:www-data /data/php/run 
COPY ./source/docker.conf /usr/local/etc/php-fpm.d/docker.conf
RUN wget https://github.com/tideways/php-xhprof-extension/archive/v4.1.7.zip && unzip v4.1.7.zip && cd php-xhprof-extension-4.1.7 && phpize && ./configure && make && make install && docker-php-ext-enable tideways
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && php composer-setup.php && mv composer.phar /usr/bin/composer && rm -f composer-setup.php
