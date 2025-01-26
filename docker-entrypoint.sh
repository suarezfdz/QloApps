#!/bin/bash
set -e

mysqld 
# wait-for-it -t 30 localhost:3306 --
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'myrootpassword';"
mysql -e "FLUSH PRIVILEGES;"

exec apache2-foreground

