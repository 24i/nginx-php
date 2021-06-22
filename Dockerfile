# 24i default application webserver with PHP 5.6 and nginx
# Version 0.0.14

# Start with Ubuntu 16.04 LTS
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# Install software
RUN apt-get -qq update && \
    apt-get install -qq software-properties-common && \
    apt-get install -y language-pack-en-base && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update -qq && \
    apt-get install -qq wget nginx nginx-extras php7.4 php7.4-fpm php7.4-cli php7.4-mysql php7.4-curl php7.4-intl php7.4-mbstring php7.4-xml git nodejs npm unzip && \
    usermod -u 1000 www-data && \
    locale-gen nl_NL.UTF-8 && \
    npm install --global n && \
    n 14.17.1 && \
    npm install --global gulp-cli && \
    npm install --global grunt-cli && \
    mkdir -p /var/www/

# Update configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.4/cli/php.ini && \
    sed -i "s/pm.max_children = 5/pm.max_children = 50/" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i "s/pm.start_servers = 2/pm.start_servers = 10/" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = 5/" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = 20/" /etc/php/7.4/fpm/pool.d/www.conf

# Install assets
COPY assets/start.sh /start.sh
COPY assets/vhost-default /etc/nginx/sites-available/default

# execute permission to start.sh
RUN ["chmod", "+x", "/start.sh"]

# Defaults
WORKDIR /src
EXPOSE 80
CMD "/start.sh"
