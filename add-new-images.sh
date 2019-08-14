#!/bin/bash

# Place your images in the images/ directory and then run this script

docker run --rm -it \
  -v "$(pwd):/opt/code" \
  --entrypoint "/bin/bash" \
  --workdir "/opt/code" \
node:lts-buster \
  "newimages.sh"
