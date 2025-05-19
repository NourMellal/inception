#!/bin/bash

# Check if database directory exists and is initialized
# if [ -d "/var/lib/mysql/mysql" ]; then
#     echo "Database already initialized, starting MariaDB..."
#     exec mysqld
# fi

# Initialize the database if it doesn't exist
echo "Initializing fresh database..."
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Start temporary server for setup
echo "Starting temporary server for setup..."
mysqld_safe --skip-networking &
pid="$!"

# Wait for server to start
for i in {30..0}; do
  if mysqladmin ping &>/dev/null; then
    break
  fi
  echo "Waiting for server to start..."
  sleep 1
done

if [ "$i" = 0 ]; then
  echo "Failed to start server"
  exit 1
fi

# Setup database and users
echo "Creating database and users..."
mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Stop temporary server
echo "Stopping temporary server..."
mysqladmin -uroot -p"$MYSQL_ROOT_PASSWORD" shutdown

# Start main MariaDB server
echo "Starting main MariaDB server..."
exec mysqld