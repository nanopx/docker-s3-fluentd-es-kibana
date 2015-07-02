#!/bin/bash
# @author nanopx


# build image
echo "Building docker image..."
docker build -t nanopx/s3-log-viewer .

# remove previous containers if exist
echo "Removing initialized container..."
docker stop log-viewer 1>/dev/null 2>/dev/null && docker rm log-viewer 1>/dev/null 2>/dev/null && echo "Removed initialized container." || echo "Container not initialized. No need to remove."

# run container
echo "Running docker image..."
docker run -d --name="log-viewer" nanopx/s3-log-viewer
