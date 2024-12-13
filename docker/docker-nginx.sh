#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Stop and remove existing Docker containers if they exist
echo "Stopping and removing existing Docker containers if they exist..."
docker-compose down || true

# Remove old Docker volumes and directories
echo "Removing existing files and directories..."
DIRS=(/docker/npm/data /docker/npm/letsencrypt /docker/npm/data/mysql)
for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        echo "Removing $DIR..."
        sudo rm -rf "$DIR"
    else
        echo "$DIR does not exist. Skipping..."
    fi
done


# Prompt for MySQL root password
read -sp 'Enter MySQL root password: ' MYSQL_ROOT_PASSWORD
echo 

# Prompt for MySQL host port
read -p 'Enter MySQL host port (default: 13306): ' MYSQL_HOST_PORT
MYSQL_HOST_PORT=${MYSQL_HOST_PORT:-13306} # Use default port if none is provided

# Check if docker-compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
    echo "docker-compose is not installed. Installing docker-compose..."
    sudo apt-get update
    sudo apt-get install -y docker-compose
fi


# Create necessary directories and verify
CREATE_DIRS=(/docker/npm/data /docker/npm/letsencrypt /docker/npm/data/mysql)
echo "Creating necessary directories..."
for DIR in "${CREATE_DIRS[@]}"; do
    if [ ! -d "$DIR" ]; then
        echo "Creating $DIR..."
        sudo mkdir -p "$DIR"
        if [ $? -ne 0 ]; then
            echo "Failed to create $DIR. Exiting."
            exit 1
        fi
    else
        echo "$DIR already exists."
    fi
        # Set permissions to avoid MariaDB permission issues
    echo "Setting ownership and permissions for $DIR..."
    sudo chown -R 1001:1001 "$DIR"
    sudo chmod -R 755 "$DIR"
done

# Change to the target directory
cd /docker/npm || { echo "Failed to change directory to /docker/npm. Exiting."; exit 1; }

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
        ports:
            - '$MYSQL_HOST_PORT:3306'
        volumes:
            - /docker/npm/data/mysql:/var/lib/mysql
EOF

if [ $? -ne 0 ]; then
    echo "Failed to create docker-compose.yml file. Exiting."
    exit 1
fi

echo "docker-compose.yml has been created successfully."

# Start the Docker containers
echo "Starting Docker containers... in $(pwd)"
docker-compose up -d
if [ $? -ne 0 ]; then
    echo "Failed to start Docker containers. Exiting."
    exit 1
fi

# Final messages
echo "Docker containers have been started successfully."
echo "You can access the Nginx Proxy Manager at http://localhost:81"
echo "You can access the Nginx Proxy Manager dashboard at http://localhost:81/admin"
echo "MariaDB is accessible at localhost:$MYSQL_HOST_PORT"
echo "Default username and password for Nginx Proxy Manager:"
echo "Username: admin@example.com"
echo "Password: changeme"





