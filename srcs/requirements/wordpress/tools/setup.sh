#!/bin/bash

# Wait for MariaDB
echo "Waiting for MariaDB..."
until nc -z mariadb 3306; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

echo "MariaDB is ready!"

# Install WordPress if not already installed
if [ ! -f "/var/www/html/wordpress/.installed" ]; then
    echo "Setting up WordPress..."
    # Make sure WordPress has right permissions
    chown -R www-data:www-data /var/www/html/wordpress
    touch /var/www/html/wordpress/.installed
fi

echo "Starting PHP-FPM..."
# Start PHP-FPM
exec php-fpm8.2 -F