#!/bin/bash
set -x
if [ "$EUID" -ne 0 ]; then echo "This script requires root to issue Docker commands."; exit; fi

docker rm darkwebkittens

docker build -t darkwebkittens .

docker run --rm -it \
  --name "alexhaydock" \
  -v "$(pwd)/../:/opt/www/" \
  -p "127.0.0.1:4000:4000/tcp" \
  darkwebkittens \
    bundle exec jekyll serve --incremental -H 0.0.0.0
