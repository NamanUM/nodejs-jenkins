#!/bin/bash

# This is to demo

node_app=$(docker ps -a | grep 'image')

if [[ -n "$node_app" ]]; then
    echo "nodeapp is running, lets delete"
        docker rm -f $(docker ps -a | grep 'image' | awk '{print $1}')
fi

images=$(docker images | grep 'naman211/image' | awk '{print $3}')

if [[ -n "$images" ]]; then
    docker rmi $images
fi
