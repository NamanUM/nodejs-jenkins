#!/bin/bash

# This is to demo

node_app=`docker ps -a | grep imag'`
if [ $node_app=='imag' ]; then
    echo "nodeapp is running, lets delete"
        docker rm -f nodeapp
fi

images=`docker images | grep good777lord/imag '`
docker rmi $images
