#!/bin/sh

echo ">>> ENTRYPOINT MARIA DB EXECUTE <<<"

chown -R mysql:mysql /var/lib/mysql
echo "[INFO] Vérification de l'état de /var/lib/mysql/mysql..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[INFO] Base non initialisée. Initialisation en cours..."

    mysql_install_db --user=mysql --ldata=/var/lib/mysql
    echo "[INFO] mysql_install_db terminé."

    echo "[INFO] Démarrage temporaire de MariaDB..."
    mysqld --user=mysql --socket=/run/mysqld/mysqld.sock &
    pid="$!"

    echo "[INFO] Attente que MariaDB réponde au ping..."
    until mysqladmin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
        echo "[WAIT] MariaDB pas encore prêt..."
        sleep 1
    done
    echo "[INFO] MariaDB est prêt."

    # Petit délai pour éviter les erreurs InnoDB
    sleep 1

    echo "[INFO] Exécution du SQL d'initialisation..."
    mysql --socket=/run/mysqld/mysqld.sock -u root << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

-- 🔥 SUPPRESSION DES UTILISATEURS ANONYMES
DELETE FROM mysql.user WHERE User='';

-- 🔥 SUPPRESSION DE WP_USER SI IL EXISTE
DROP USER IF EXISTS '$MYSQL_USER'@'%';

-- 🔥 CREATION DE WP_USER
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

-- 🔥 MOT DE PASSE ROOT
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';

FLUSH PRIVILEGES;
EOF

    echo "[INFO] SQL exécuté."

    echo "[INFO] Arrêt du serveur temporaire..."
    mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"$(cat /run/secrets/db_root_password)" shutdown
    echo "[INFO] Serveur temporaire arrêté."
else
    echo "[INFO] Base déjà initialisée. Aucun SQL exécuté."
fi

echo "[INFO] Lancement final de MariaDB..."
exec mysqld --user=mysql --bind-address=0.0.0.0

