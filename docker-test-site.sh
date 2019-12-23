#!/bin/bash
set -xe

docker run --rm -it \
  --name "darkwebkittens" \
  -v $(pwd)/:/opt/www/ \
  -p "127.0.0.1:4000:4000/tcp" \
  --workdir /opt/www \
  registry.gitlab.com/alexhaydock/dockerfiles:jekyll \
    bundle exec jekyll serve -H 0.0.0.0
