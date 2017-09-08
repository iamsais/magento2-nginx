FROM ubuntu:16.10

MAINTAINER sathish26

RUN apt-get update && \
    apt-get install -y \
        nginx \
        wget \
        nano \
        composer \
        php7.0-fpm \
        php7.0-mcrypt \
        php7.0-curl \
        php7.0-cli \
        php7.0-mysql \
        php7.0-gd \
        php7.0-xsl \
        php7.0-json \
        php7.0-intl \
        php-pear \
        php7.0-dev \
        php7.0-common \
        php7.0-mbstring \
        php7.0-zip \
        php-soap \
        libcurl3 \
        curl \
        php7.0-bcmath \
        supervisor

RUN git clone https://github.com/edenhill/librdkafka.git && \
	cd librdkafka && \
	./configure && make && make install && \
	ls -l /usr/local/lib/ && \
	pecl install rdkafka

# clear apt cache and remove unnecessary packages
RUN apt-get autoclean && apt-get -y autoremove

COPY php-fpm/php.ini /etc/php/7.0/fpm/
COPY php-cli/php.ini /etc/php/7.0/cli/
COPY rdkafka.ini /etc/php/7.0/mods-available/

RUN rm /etc/nginx/sites-enabled/default

COPY magento2 /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/magento2 /etc/nginx/sites-enabled/

COPY supervisor-app.conf /etc/supervisor/conf.d/

CMD ["supervisord", "-n"]
