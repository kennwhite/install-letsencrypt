#!/bin/bash

# CentOS 6.7 stock LetsEncrypt beta client installer
#
# If you get stuck, just try again:
#  cd ~/ && rm -rf ./letsencrypt && rm -rf ~/.local/share/letsencrypt && rm -rf /etc/letsencrypt && rm -rf ~/.cache/pip
#
# Usage (as root; note the leading space): . ./CentOS6.sh

# Set this to your domain for certificate

export DOMAIN=www.EXAMPLE.org

# Sanity checks
if ( whoami | grep -qv root ); then
  echo "Fatal: Please rerun script as sudo or root." && read -p "[Hit cntrl-c to break]"
fi
if [ "$DOMAIN" == "www.EXAMPLE.org" ]; then
  echo "Fatal: Please set DOMAIN and rerun this script." && read -p "[Hit cntrl-c to break]"
fi

# Enable EPEL repository (for Python 2.7)
rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

yum install -y -q git python-pip python27-python-devel
pip install --upgrade pip

# Set temporary PATH and LD Library (current shell only)
# Note the leading space. Rerun if starting new shell before launching letsencrypt-auto

. /opt/rh/python27/enable

if ( python -V 2>&1 | grep -q '2.7'  ) then
  git clone https://github.com/letsencrypt/letsencrypt
  cd letsencrypt
  ./letsencrypt-auto --agree-dev-preview -d $DOMAIN --authenticator manual certonly
  # For trusted cert (currently Beta testers only):
  #  --server https://acme-v01.api.letsencrypt.org/directory
else
  echo -e "\n\nFatal: Incompatible Python build environment. Please rerun: . /opt/rh/python27/enable \n"
fi
