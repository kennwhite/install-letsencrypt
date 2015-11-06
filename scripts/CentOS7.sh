#!/bin/bash

# CentOS 7 stock LetsEncrypt beta client installer
#
# If you get stuck, just try again:
#  cd ~/ && rm -rf ./letsencrypt && rm -rf ~/.local/share/letsencrypt && rm -rf /etc/letsencrypt && rm -rf ~/.cache/pip
#
# Usage (as root; note the leading space): . ./CentOS7.sh

# Set this to your domain for certificate

export DOMAIN=www.EXAMPLE.org

# Sanity checks
if ( whoami | grep -qv root ); then
  echo "Fatal: Please rerun script as sudo or root." && read -p "[Hit cntrl-c to break]"
fi
if [ "$DOMAIN" == "www.EXAMPLE.org" ]; then
  echo "Fatal: Please set DOMAIN and rerun this script." && read -p "[Hit cntrl-c to break]"
fi

yum update -y -q
yum -q -y install git

git clone https://github.com/letsencrypt/letsencrypt

cd letsencrypt

./letsencrypt-auto --agree-dev-preview -d $DOMAIN --authenticator manual certonly

# For trusted cert (currently Beta testers only):
#  --server https://acme-v01.api.letsencrypt.org/directory
