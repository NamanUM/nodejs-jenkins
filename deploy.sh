#!/bin/bash

# This is to demo

node_app=`docker ps -a | grep image'`
if [ $node_app=='image' ]; then
    echo "nodeapp is running, lets delete"
        docker rm -f nodeapp
fi

images=`docker images | grep naman211/image '`
docker rmi $images
