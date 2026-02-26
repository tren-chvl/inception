*This project has been created as part of the 42 curriculum by marcheva.*

# Inception

## Description
Inception is a system administration project whose goal is to build a small, fully functional infrastructure using Docker. The project requires creating a multi-service environment composed of: - An Nginx container configured with TLS. - A WordPress container running with PHP-FPM. - A MariaDB database container. - Docker secrets for secure password handling. - Docker named volumes for persistent storage. Each service runs inside its own container, built from a custom Dockerfile. The entire infrastructure is orchestrated using Docker Compose. The objective is to understand containerization, service isolation, networking, and secure configuration practices.

---

## Instructions

### Requirements
Before running the project, ensure that: - Docker and Docker Compose are installed. - The domain <login>.42.fr resolves to 127.0.0.1. - The secrets/ directory contains: db_password.txt and db_root_password.txt.

### Running the project
Build and start the infrastructure: make  
Stop the containers: make down  
Remove containers and volumes: make clean  
Full reset (containers, images, volumes, cache): make fclean  
Rebuild everything: make re  

### Accessing the website
Once the stack is running, the WordPress website is available at: https://<login>.42.fr

---

## Project Description

### Use of Docker
Docker is used to isolate each service into its own container. The project includes: Custom Dockerfiles for Nginx, WordPress (PHP-FPM), and MariaDB. Docker Compose to orchestrate the services, networks, volumes, and secrets. Docker named volumes to persist WordPress and MariaDB data. Docker secrets to securely provide database credentials. A dedicated Docker network to allow communication between containers.

### Sources included in the project
The project includes: Custom configuration files for Nginx (TLS, virtual host). A WordPress setup script and PHP-FPM configuration. A MariaDB initialization script. A Makefile to automate setup and cleanup. Dockerfiles for each service.

### Main design choices
Use of Alpine Linux or Debian as lightweight base images. Use of PHP-FPM instead of Apache for WordPress. Use of TLS-only access through Nginx. Use of Docker secrets instead of environment variables for passwords. Use of named volumes instead of bind mounts to comply with the subject. Use of a bridge network for container communication.

---

## Technical Comparisons

### Virtual Machines vs Docker
Virtual Machines emulate an entire operating system, including the kernel. They are heavy, slow to boot, and consume more resources. Docker containers share the host kernel and isolate only the application environment. They are lightweight, fast, and more efficient for microservices.

### Secrets vs Environment Variables
Environment variables are easy to use but can be exposed through logs, process lists, or version control. Docker secrets are stored in memory, mounted as temporary files, and never appear in environment dumps. They are more secure for sensitive data such as passwords.

### Docker Network vs Host Network
Docker bridge network isolates containers from the host and allows controlled communication between services. Host network exposes containers directly to the host network stack, reducing isolation and increasing security risks. The project uses a bridge network for safety and compliance.

### Docker Volumes vs Bind Mounts
Bind mounts map a host directory directly into a container. They depend on the host filesystem and are not allowed by the subject. Docker named volumes are managed by Docker, portable, and more reliable for persistent data. This project uses named volumes for WordPress and MariaDB.

---

## Resources

### Documentation and references
Docker documentation: https://docs.docker.com/  
Docker Compose documentation: https://docs.docker.com/compose/  
Nginx documentation: https://nginx.org/en/docs/  
WordPress documentation: https://developer.wordpress.org/  
MariaDB documentation: https://mariadb.org/documentation/  

### Use of AI in this project
AI was used to: Review and correct Docker configuration files. Generate documentation (README, user guide, developer guide). Identify common mistakes related to Docker volumes, secrets, and Makefile rules. Provide explanations and comparisons required by the subject. AI was not used to write code automatically; all Dockerfiles, scripts, and configurations were manually implemented and verified.
