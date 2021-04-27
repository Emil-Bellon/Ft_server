FROM debian:buster

COPY ./srcs ./srcs
COPY setup.sh setup.sh

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y nginx \
	mariadb-server mariadb-client \
	php-mbstring \
	php-zip \
	php-gd \
	php-xml \
	php-pear \
	php-gettext \
	php-cgi \
	php-fpm \
	php-mysql \
	openssl

# define the port number the container should expose
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["bash", "setup.sh"]