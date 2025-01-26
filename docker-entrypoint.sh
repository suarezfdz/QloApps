#!/bin/bash
set -e

# Wait for MySQL to be available
echo "Waiting for MySQL to be available..."
/usr/local/bin/wait-for-it db:3306 --timeout=30 --strict -- echo "MySQL is up!"

# Set MySQL root password
echo "Setting MySQL root password..."
mysql -h db -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -h db -u root -e "FLUSH PRIVILEGES;"

# Run Apache in the foreground
exec apache2-foreground
