#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Prompt for MySQL root password
read -sp 'Enter MySQL root password: ' MYSQL_ROOT_PASSWORD
echo 

# check if the docker-compose command exists
if ! [ -x "$(command -v docker-compose)" ]; then
    echo "docker-compose is not installed. Please install docker-compose."
    sudo apt-get install docker-compose
fi

# Create necessary directories
sudo mkdir -p /docker/npm/data
sudo mkdir -p /docker/npm/letsencrypt
sudo mkdir -p /docker/npm/data/mysql

cd /docker/npm
# Docker Compose configuration
cat <<EOF > docker-compose.yml
version: '3'
services:
    app:
        image: 'jc21/nginx-proxy-manager:latest'
        ports:
            - '80:80'
            - '81:81'
            - '443:443'
        environment:
            DB_MYSQL_HOST: "db"
            DB_MYSQL_PORT: 3306
            DB_MYSQL_USER: "npm"
            DB_MYSQL_PASSWORD: "npm"
            DB_MYSQL_NAME: "npm"
        volumes:
            - /docker/npm/data:/data
            - /docker/npm/letsencrypt:/etc/letsencrypt
    db:
        image: 'jc21/mariadb-aria:latest'
        environment:
            MYSQL_ROOT_PASSWORD: '$MYSQL_ROOT_PASSWORD'
            MYSQL_DATABASE: 'npm'
            MYSQL_USER: 'npm'
            MYSQL_PASSWORD: 'npm'
        volumes:
            - /docker/npm/data/mysql:/var/lib/mysql
EOF

# Start the Docker containers
echo "Starting Docker containers... on $(pwd)"
docker-compose up -d

# Display the status of the Docker containers
echo "Docker containers status:"
docker ps
echo "Docker containers have been started successfully."
echo "You can access the Nginx Proxy Manager at http://localhost:81"
echo "You can access the Nginx Proxy Manager dashboard at http://localhost:81/admin"
echo "You can access the MariaDB database at http://localhost




