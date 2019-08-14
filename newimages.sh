#!/bin/bash
set -xe

npm install
apt-get update && apt-get install -y gulp
gulp
