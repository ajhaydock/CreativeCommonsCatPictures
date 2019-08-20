#!/bin/bash
if [ "$EUID" -eq 0 ]; then echo "Please do not run as root. Please add yourself to the 'docker' group."; exit; fi

docker run --rm -it \
  --name "darkwebkittens" \
  -v "$(pwd)/:/opt/www/" \
  -p "127.0.0.1:4000:4000/tcp" \
  registry.gitlab.com/alexhaydock/dockerfiles:jekyll \
     bundle exec jekyll serve -H 0.0.0.0
