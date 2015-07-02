#!/bin/bash
# @author nanopx

# build image
echo "Building docker image..."
docker build -t nanopx/docker-s3-fluentd-es-kibana .
echo "Removing initialized container..."
docker rm docker-s3-fluentd-es-kibana 1>/dev/null 2>/dev/null && echo "Removed initialized container." || echo "Container not initialized. No need to remove."
echo "Running docker image..."
docker run -it --name="docker-s3-fluentd-es-kibana" nanopx/docker-s3-fluentd-es-kibana
