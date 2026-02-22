#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de MariaDB..."

    mysql_install_db --user=mysql --ldata=/var/lib/mysql

    mysqld --user=mysql --bootstrap << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';
FLUSH PRIVILEGES;
EOF
fi

exec "$@"