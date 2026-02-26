#!/bin/sh

echo ">>> ENTRYPOINT WORDPRESS <<<"

cd /var/www/html

# --- Génération du wp-config.php ---
if [ ! -f wp-config.php ]; then
    echo "[INFO] Création du wp-config.php..."
    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/$MYSQL_DATABASE/" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" wp-config.php
    sed -i "s/password_here/$(cat /run/secrets/db_password)/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi

# --- Installation WP-CLI ---
if [ ! -f /usr/local/bin/wp ]; then
    echo "[INFO] Installation de WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# --- Attente de MariaDB ---
echo "[INFO] Attente de MariaDB..."
until mysqladmin ping -h mariadb --silent; do
    echo "[WAIT] MariaDB pas encore prêt..."
    sleep 1
done
echo "[INFO] MariaDB est prêt."

# --- Installation WordPress ---
if ! wp core is-installed --allow-root; then
    echo "[INFO] Installation de WordPress..."
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$(cat /run/secrets/wp_admin_password)" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "[INFO] Création de l'utilisateur standard..."
    wp user create wp_user wp_user@example.com \
        --user_pass="$(cat /run/secrets/db_password)" \
        --role=author \
        --allow-root
fi

echo "[INFO] Lancement de PHP-FPM..."
exec php-fpm81 -F

