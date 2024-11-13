#!/usr/bin/env bash

# Function to print a message if there are no resources to delete
print_if_empty() {
  if [ -z "$1" ]; then
    echo "$2"
  else
    eval "$3"
  fi
}

# Stop and remove all containers
containers=$(docker ps -aq)
print_if_empty "$containers" "No containers to stop or remove." \
               "echo 'Stopping all running containers...'; docker stop \$containers; echo 'Removing all containers...'; docker rm \$containers"

# Remove all images
images=$(docker images -q)
print_if_empty "$images" "No images to remove." \
               "echo 'Removing all images...'; docker rmi -f \$images"

# Remove all volumes
volumes=$(docker volume ls -q)
print_if_empty "$volumes" "No volumes to remove." \
               "echo 'Removing all volumes...'; docker volume rm \$volumes"

# Remove all custom networks, excluding bridge, host, and none
networks=$(docker network ls --filter "type=custom" -q)
print_if_empty "$networks" "No custom networks to remove." \
               "echo 'Removing all custom networks...'; docker network rm \$networks"

# Remove all unused data (dangling images, stopped containers, networks, and volumes)
echo "Performing a system prune to clean up any remaining resources..."
docker system prune -a --volumes -f

echo "Docker environment cleanup complete!"

