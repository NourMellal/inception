#!/bin/bash

# Wait for MariaDB
echo "Waiting for MariaDB..."
until nc -z mariadb 3306; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

echo "MariaDB is ready!"
cd /var/www/html/wordpress

# Wait for database to be fully ready
echo "Waiting for database to be fully ready..."
sleep 5

# Check if WordPress is already configured
if ! wp core is-installed --allow-root; then
    echo "WordPress is not installed - performing installation"
    
    # Make sure wp-config.php is properly set up
    if [ -f wp-config.php ]; then
        echo "wp-config.php already exists"
    else
        echo "Creating wp-config.php"
        wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
            --dbpass="$MYSQL_PASSWORD" --dbhost=mariadb --allow-root
    fi
    
    echo "Installing WordPress..."
    # Run installation as root since we have the --allow-root flag
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
        
    if wp core is-installed --allow-root; then
        echo "WordPress installation completed successfully!"
    else
        echo "WordPress installation failed!"
        exit 1
    fi
else
    echo "WordPress is already installed and configured."
fi

# Make sure WordPress has right permissions
chown -R www-data:www-data /var/www/html/wordpress

if ! wp user get "$WP_REGULAR_USER" --allow-root > /dev/null 2>&1; then
    echo "Creating WordPress user..."
    wp user create "$WP_REGULAR_USER" "$WP_REGULAR_EMAIL" --user_pass="$WP_REGULAR_PASSWORD" --role=author  --allow-root
else
    echo "WordPress user already exists."
fi

echo "Starting PHP-FPM..."
# Start PHP-FPM
exec php-fpm8.2 -F