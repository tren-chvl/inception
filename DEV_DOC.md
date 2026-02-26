# Developer Documentation — Inception

This document explains how a developer can understand, configure, build, and manage the Inception project. It covers environment setup, secrets, Docker architecture, Makefile usage, container management, and data persistence.

## 1. Environment Setup from Scratch
To set up the project from zero, ensure the following prerequisites are installed on the system: Docker, Docker Compose, GNU Make. Clone the repository and navigate into the project directory. Create a secrets/ directory at the root of the project. Inside this directory, create two files: db_password.txt containing the WordPress database user password, and db_root_password.txt containing the MariaDB root password. These files must contain only the password text with no extra spaces or newlines. Ensure the domain <login>.42.fr resolves to 127.0.0.1 by adding it to /etc/hosts if necessary.

## 2. Configuration Files and Project Structure
The project includes several key configuration files: Dockerfiles for Nginx, WordPress (PHP-FPM), and MariaDB; docker-compose.yml defining services, networks, volumes, and secrets; Nginx configuration for TLS and virtual hosting; WordPress setup scripts; MariaDB initialization scripts; and a Makefile automating build and management tasks. Each service runs in its own container and communicates through a dedicated Docker network.

## 3. Building and Launching the Project
The Makefile provides all necessary commands to build and run the infrastructure. Running "make" builds Docker images if needed and starts all containers using Docker Compose. "make down" stops the containers without removing volumes. "make clean" removes containers and volumes. "make fclean" performs a full cleanup including images, volumes, and cache. "make re" rebuilds everything from scratch. These commands ensure consistent and reproducible environment management.

## 4. Managing Containers and Volumes
Developers can inspect running containers using "docker ps". To view logs for debugging, use "docker logs <container_name>". To access a container shell, use "docker exec -it <container_name> sh" or bash depending on the base image. Volumes are created automatically by Docker Compose and persist data across container restarts. They can be listed with "docker volume ls" and inspected with "docker volume inspect <volume_name>". Removing volumes manually should be done with caution as it deletes all stored data.

## 5. Data Storage and Persistence
The project uses Docker named volumes to store persistent data. The WordPress volume contains uploaded files, themes, plugins, and configuration. The MariaDB volume stores all database tables and metadata. These volumes ensure that data remains intact even if containers are stopped, rebuilt, or recreated. Secrets are stored in the secrets/ directory and mounted securely inside containers at runtime. No sensitive information is stored in environment variables or version control.

## 6. Networking and Service Communication
All services communicate through a dedicated Docker bridge network defined in docker-compose.yml. Nginx acts as the public entry point and forwards PHP requests to the WordPress PHP-FPM container. WordPress connects to MariaDB using internal DNS resolution provided by Docker Compose. No service is exposed directly to the host except Nginx, which listens on port 443 for HTTPS traffic.

## 7. Rebuilding and Debugging
To rebuild a single service, use "docker compose build <service>". To restart a service without rebuilding, use "docker compose restart <service>". If configuration changes do not apply, ensure caches are cleared and containers are rebuilt using "make re". For debugging database issues, connect to the MariaDB container and use the mysql CLI. For WordPress issues, check PHP-FPM logs and Nginx logs.

# End of Developer Documentation
