# User Documentation — Inception

This document explains how an end user or administrator can use the Inception project. It focuses on understanding the services provided, running the stack, accessing the website, managing credentials, and verifying that everything works correctly.

## 1. Overview of the Services
The Inception stack provides the following services:
- Nginx (with TLS) — Acts as a secure reverse proxy serving HTTPS traffic.
- WordPress (PHP-FPM) — A fully functional WordPress website running behind Nginx.
- MariaDB — A relational database storing all WordPress data.
- Docker Secrets — Secure storage for database credentials.
- Docker Volumes — Persistent storage for WordPress files and MariaDB data.
All services run in isolated Docker containers and communicate through a dedicated Docker network.

## 2. Starting and Stopping the Project
The project is controlled using a Makefile.
Start the entire stack: make  
Stop all running containers: make down  
Remove containers and volumes: make clean  
Full reset (containers, images, volumes, cache): make fclean  
Rebuild everything from scratch: make re  

## 3. Accessing the Website and Admin Panel
Once the stack is running, open your browser and visit: https://<login>.42.fr  
WordPress setup (first launch): choose a site title, create your admin account, log in to the dashboard.  
Admin panel: https://<login>.42.fr/wp-admin  

## 4. Credentials Location and Management
Database credentials are stored securely using Docker secrets. They must be placed in the secrets/ directory:
- secrets/db_password.txt — WordPress database user password
- secrets/db_root_password.txt — MariaDB root password
These files must be created manually before running the project. WordPress admin credentials are created during the initial setup through the browser.

## 5. Verifying That Services Are Running
Check running containers: docker ps  
You should see nginx, wordpress (php-fpm), mariadb.  
Check logs: docker logs <container_name>  
Check website: https://<login>.42.fr  
Check persistence: content should remain after make down then make.

## 6. Troubleshooting
Domain does not resolve: add "127.0.0.1 <login>.42.fr" to /etc/hosts.  
WordPress does not load: restart with make.  
Database errors: ensure secrets exist and contain valid passwords.  
Containers not running: docker ps -a then make.

# End of User Documentation
