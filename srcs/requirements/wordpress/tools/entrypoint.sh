#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then
    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/$MYSQL_DATABASE/" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" wp-config.php
    sed -i "s/password_here/$(cat /run/secrets/db_password)/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi

exec "$@"