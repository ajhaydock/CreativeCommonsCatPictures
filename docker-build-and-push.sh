#!/bin/bash
set -xe
if [ "$EUID" -eq 0 ]; then echo "Please do not run as root. Please add yourself to the 'docker' group."; exit; fi

docker build --no-cache -t registry.gitlab.com/alexhaydock/darkwebkittens.xyz .
docker push registry.gitlab.com/alexhaydock/darkwebkittens.xyz