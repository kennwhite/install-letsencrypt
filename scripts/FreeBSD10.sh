#!/bin/sh

# FreeBSD 10.2-RELEASE stock build (on AWS: ami-f709a29c) LetsEncrypt beta client installer
#
# If you get stuck, just try again:
#  cd ~/ && rm -rf ./letsencrypt && rm -rf ~/.local/share/letsencrypt && rm -rf /usr/local/etc/letsencrypt && rm -rf ~/.cache/pip
#

# Usage (as root; note the leading space): source ./FreeBSD10.sh

# Set this to your domain for certificate
export DOMAIN=www.EXAMPLE.org


mkdir -p /usr/local/etc/pkg/repos

# Currently only available for 10.2-Release

cat > /usr/local/etc/pkg/repos/FreeBSD.conf << 'EOF'
 FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest"
 }
'EOF'

pkg install -y py27-letsencrypt

letsencrypt --agree-dev-preview -d $DOMAIN --authenticator manual certonly


# For trusted cert (currently Beta testers only):
#  --server https://acme-v01.api.letsencrypt.org/directory 


