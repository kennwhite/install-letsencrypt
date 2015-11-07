#!/bin/sh

# FreeBSD 10.2-RELEASE stock build (on AWS: ami-f709a29c) LetsEncrypt beta client installer
#
# If you get stuck, just try again:
#  cd ~/ && rm -rf ./letsencrypt && rm -rf ~/.local/share/letsencrypt && rm -rf /etc/letsencrypt && rm -rf ~/.cache/pip
#
# Usage (as root; note the leading space): . ./FreeBSD10.sh

# Set this to your domain for certificate

export DOMAIN=www.EXAMPLE.org

su - root -c 'pkg install -y py-letsencrypt sudo'

# If on AWS, add ec2-user to sudoers if not present (yes, it's a hack)
if ( ping -c 1 `hostname`| grep -q ec2.internal ) then
  grep 'ec2' /usr/local/etc/sudoers || su - root -c 'echo "ec2-user ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers'
fi

mkdir letsencrypt
cd letsencrypt
./letsencrypt-auto --agree-dev-preview -d $DOMAIN --authenticator manual certonly

# For trusted cert (currently Beta testers only):
#  --server https://acme-v01.api.letsencrypt.org/directory
