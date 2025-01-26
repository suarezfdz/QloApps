FROM php:7.4-apache

# Install required PHP extensions
RUN set -e; \\
    apt-get update
    if ! dpkg -s libpng-dev libzip-dev >/dev/null 2>&1; then \\
        apt-get install -y libpng-dev libzip-dev; \\
    fi; \\
    docker-php-ext-install gd mysqli pdo pdo_mysql soap zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy QloApps source code to Apache root directory
COPY ./ /var/www/html/

# Set permissions for Apache
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Environment variables for MySQL connection
ENV MYSQL_HOST=db
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=myrootpassword
ENV MYSQL_DATABASE=qlo161

# Expose ports
EXPOSE 80

# Use Apache to serve the application
CMD ["apache2-foreground"]

# Set PHP configuration

RUN echo "upload_max_filesize=16M" > /usr/local/etc/php/conf.d/uploads.ini
