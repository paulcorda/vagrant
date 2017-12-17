#!/usr/bin/env bash

# Remove exited containers
docker rm $(docker ps -q -f status=exited)

# Remove dangling images
docker rmi $(docker images -f "dangling=true" -q)

# Remove un-used volumes
docker volume rm $(docker volume ls -q)
