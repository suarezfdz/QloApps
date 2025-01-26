#!/bin/bash
set -e

service mysql start
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'myrootpassword';"
mysql -e "FLUSH PRIVILEGES;"

exec apache2-foreground

