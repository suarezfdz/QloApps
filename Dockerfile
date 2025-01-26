FROM php:7.4-apache

# Install MySQL client and required PHP extensions
RUN apt-get update && \
    apt-get install -y libfreetype6-dev libjpeg-dev libjpeg62-turbo-dev libpng-dev libzip-dev libxml2-dev default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Install and configure PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd mysqli pdo pdo_mysql soap zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy QloApps source code to Apache root directory
COPY ./ /var/www/html/

# Set permissions for Apache
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Set PHP configuration for upload_max_filesize
RUN echo "upload_max_filesize=16M" >> /usr/local/etc/php/conf.d/uploads.ini

# Environment variables for MySQL connection
ENV MYSQL_HOST=db
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=myrootpassword
ENV MYSQL_DATABASE=qlo161

# Expose ports
EXPOSE 80

# Copy docker-entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/

# Ensure docker-entrypoint.sh is executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Use Apache to serve the application
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
