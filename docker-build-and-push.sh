#!/bin/bash
set -e
if [ "$EUID" -eq 0 ]; then echo "Please do not run as root. Please add yourself to the 'docker' group."; exit; fi

if [ "$(uname -m | grep 'x86_64' | wc -l)" -gt 0 ]; then
    echo "This looks like an x86_64 system. Building for that platform."
    docker build --no-cache -t registry.gitlab.com/alexhaydock/darkwebkittens.xyz .
    docker push registry.gitlab.com/alexhaydock/darkwebkittens.xyz
elif [ "$(uname -m | grep 'armv7l' | wc -l)" -gt 0 ]; then
    echo "This looks like an armv7l system. Building for that platform."
    docker build --no-cache -t registry.gitlab.com/alexhaydock/darkwebkittens.xyz:armv7l .
    docker push registry.gitlab.com/alexhaydock/darkwebkittens.xyz:armv7l
else
    echo "Sorry, I don't understand this processor architecture."
    echo "Please build manually."
fi
