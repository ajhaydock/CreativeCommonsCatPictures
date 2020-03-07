#!/bin/sh

# To run the cron job, you already need to have run the 'issue' script
# to issue a certificate so acme.sh knows what it might need to renew.

sudo docker run --rm -it \
  -v "/home/ubuntu/certs":"/acme.sh" \
  --name=acme.sh \
  neilpang/acme.sh --cron