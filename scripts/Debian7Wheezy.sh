#!/bin/sh

# Debian 7.9 (Wheezy) LetsEncrypt beta client installer
#
# If you get stuck, just try again:
#  cd ~/ && rm -rf ./letsencrypt && rm -rf ~/.local/share/letsencrypt && rm -rf /etc/letsencrypt && rm -rf ~/.cache/pip
#
# Usage (as root; note the leading space): . ./Debian7Wheezy.sh

# Set this to your domain for certificate

export DOMAIN=www.EXAMPLE.org

apt-get -y -qq update
apt-get -y -qq install \
curl gcc git libbz2-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev llvm make patch python-pip wget zlib1g-dev


# A little insane, so read and run at your own risk!

# This installs the pyenv manager to run non-system multiple/parallel versions of python
# (Rationale in short: LE official python client requires very specific versions of libraries)

curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# There will be a long pause at the patch update while pyenv compiles 2.7.9
echo 'To monitor the build process, from another terminal: tail -f /tmp/$(ls -t /tmp | grep log$ | head -n 1)'
pyenv install 2.7.9 

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv global 2.7.9

echo "Next line should show: 2.7.9"
python -V

git clone https://github.com/letsencrypt/letsencrypt

cd letsencrypt

./letsencrypt-auto --agree-dev-preview -d $DOMAIN --authenticator manual certonly

# For trusted cert (currently Beta testers only):
#  --server https://acme-v01.api.letsencrypt.org/directory

