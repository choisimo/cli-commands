#!/bin/bash

# Check if root user
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Check if Docker is installed
if ! [ -x "$(command -v docker)" ]; then
    echo "Error: Docker is not installed."
    exit 1
fi

# Enter username
echo "Enter your MongoDB root username: "
read username

# Enter password
echo "Enter your MongoDB root password: "
read -s password

# Enter host directory for MongoDB data
echo "Enter the directory on your host to store MongoDB data (e.g., /path/to/data): "
read host_data_dir

# Ensure the host data directory exists
if [ ! -d "$host_data_dir" ]; then
  echo "Creating directory $host_data_dir..."
  mkdir -p "$host_data_dir"
  chmod 755 "$host_data_dir"
fi

# Pull MongoDB Docker image
sudo docker pull mongo:4.4

# Run MongoDB container with volume mapping
sudo docker run -d \
  -p 27017:27017 \
  -v "$host_data_dir:/data/db" \
  -e MONGO_INITDB_ROOT_USERNAME="$username" \
  -e MONGO_INITDB_ROOT_PASSWORD="$password" \
  --name mongodb \
  mongo:4.4

# Check if the container is running
sudo docker ps

# Test MongoDB connection
sudo docker exec -it mongodb mongo --username "$username" --password "$password" || {
    echo "Error: Failed to start MongoDB container"
    exit 1
}

# Output instructions for enabling authentication in mongod.conf
echo "To enable MongoDB authentication, ensure the following in your mongod.conf:"
echo "🔨 security:"
echo "🔨     authorization: 'enabled'"

echo "Setup complete. MongoDB is running in Docker with data directory mapped to $host_data_dir."
