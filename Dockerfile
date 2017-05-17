# 24i default application webserver with PHP 5.6 and nginx

# Start with Ubuntu 14.04 LTS
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# Install Nginx and php 5.6
RUN apt-get -qq update && \
    apt-get install -qq software-properties-common && \
    apt-get install -y language-pack-en-base && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update -qq && \
    apt-get install -qq wget nginx nginx-extras php5.6 php5.6-fpm php5.6-cli php5.6-curl php5.6-intl php5.6-mbstring php5.6-xml git nodejs npm unzip && \
    usermod -u 1000 www-data && \
    locale-gen nl_NL.UTF-8 && \
    npm install --global n && \
    n 6.2.1 && \
    npm install --global grunt-cli

# Update configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/5.6/fpm/php.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/5.6/cli/php.ini && \
    sed -i "s/pm.max_children = 5/pm.max_children = 50/" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i "s/pm.start_servers = 2/pm.start_servers = 10/" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = 5/" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = 20/" /etc/php/5.6/fpm/pool.d/www.conf

# Install assets
COPY assets/start.sh /start.sh
COPY assets/nginx.conf /etc/nginx/sites-available/default

# make www folder with correct permissions
RUN mkdir /var/www/
RUN chown root /var/www/ && \
    chgrp www-data /var/www/

# Defaults
WORKDIR /src
EXPOSE 80
CMD "/start.sh"