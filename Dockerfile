FROM php:7.2-apache-buster

LABEL mantainer="diego2k@gmail.com"

ARG MANTIS_VER=2.24.1
ARG MANTIS_TIMEZONE=America/Chicago
ARG MANTIS_UPLOAD_MAX_FILESIZE=50M
ARG MANTIS_POST_MAX_FILESIZE=100M

EXPOSE 80

VOLUME /config

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y libpng-dev libonig-dev git sendmail && \
	cd /tmp && \
	docker-php-ext-install mysqli && \
	docker-php-ext-install gd && \
	docker-php-ext-install mbstring && \
	docker-php-ext-install fileinfo && \
	apt-get -y autoremove && \
	rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN set -xe \
    && ln -sf /usr/share/zoneinfo/${MANTIS_TIMEZONE} /etc/localtime \
    && echo 'date.timezone = "${MANTIS_TIMEZONE}"'                  > /usr/local/etc/php/conf.d/mantis.ini \
    && echo 'upload_max_filesize = "${MANTIS_UPLOAD_MAX_FILESIZE}"' > /usr/local/etc/php/conf.d/mantis.ini \
    && echo 'post_max_size = "${MANTIS_POST_MAX_FILESIZE}"'         > /usr/local/etc/php/conf.d/mantis.ini \
	&& echo 'sendmail_path = "/usr/sbin/sendmail -t -i"'            > /usr/local/etc/php/conf.d/mantis.ini

WORKDIR /var/www/html

RUN curl -sSL https://github.com/mantisbt/mantisbt/archive/release-${MANTIS_VER}.tar.gz | \
    tar xfz - --strip=1 && \
	chown -R www-data:www-data /var/www/html && \
	mkdir -p /config && \
	cp /var/www/html/config/* /config && \
    chown -R www-data:www-data /config && \
	rm -rf /var/www/html/config && \
	ln -s /config /var/www/html

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer && \
    composer install --no-dev --no-interaction -o

COPY ./entrypoint.sh /

RUN chmod +x /entrypoint.sh

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

ENTRYPOINT /entrypoint.sh
