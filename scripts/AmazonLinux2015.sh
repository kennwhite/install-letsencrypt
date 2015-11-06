#!/bin/bash

# Amazon Linux 2015.09-Minimal stock LetsEncrypt beta client installer (HVM EBS: ami-fbb9c991)
#
# If you get stuck, just try again:
#  cd ~/ && rm -rf ./letsencrypt && rm -rf ~/.local/share/letsencrypt && rm -rf /etc/letsencrypt && rm -rf ~/.cache/pip
#
# Usage (as root; note the leading space): . ./AmazonLinux2015sh

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

# The LE installer OS autodetect doesn't recognize Amazon Linux, so we have to manually pre-install required buildpkgs

yum install -y -q augeas-libs dialog epel-release gcc git libffi-devel openssl-devel python27-pip python27-python-devel python27-virtualenv

git clone https://github.com/letsencrypt/letsencrypt

cd letsencrypt

./letsencrypt-auto --agree-dev-preview -d $DOMAIN --authenticator manual certonly

# For trusted cert (currently Beta testers only):
#  --server https://acme-v01.api.letsencrypt.org/directory
