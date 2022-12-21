#!/bin/bash

apt-get update
apt-get install -y git python3.9 build-essential cmake autoconf autogen libtool pkg-config ragel

git config --global pull.rebase false
ln -sf /usr/bin/python3.9 /usr/bin/python