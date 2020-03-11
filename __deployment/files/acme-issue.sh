#!/bin/sh

# The ~/certs directory needs to have account.conf in it with your Cloudflare account API key in it.
# I generated this originally by passing the API key into the container as an env var.
# See: https://github.com/acmesh-official/acme.sh/wiki/dnsapi
#
# Now I just keep it stashed in ~/.ssh/acme_ssh_account.conf for when I need it.

sudo docker run --rm -it \
  -v "/home/ubuntu/certs":"/acme.sh" \
  --name=acme.sh \
  neilpang/acme.sh --issue --dns dns_cf -d wg.darkwebkittens.xyz