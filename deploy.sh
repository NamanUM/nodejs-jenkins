#!/bin/bash

NEW_IMAGE_NAME="naman211/my-new-image:latest" # Change this to your new image name

# Log in to Docker Hub using Jenkins-provided credentials.
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"

# Remove the container based on the name of the image it uses.
node_app=$(docker ps -a --filter "ancestor=$NEW_IMAGE_NAME" | awk 'NR>1 {print $1}')

if [[ -n "$node_app" ]]; then
    echo "$NEW_IMAGE_NAME container is running, lets delete"
    docker rm -f $node_app
fi

# Remove the old image itself.
images=$(docker images | grep "$NEW_IMAGE_NAME" | awk '{print $3}')

if [[ -n "$images" ]]; then
    docker rmi $images
fi

# Pull the new image from Docker Hub.
docker pull $NEW_IMAGE_NAME

# Run a new container using the pulled image.
docker run -d -p 3500:3500 --name my-new-container $NEW_IMAGE_NAME
