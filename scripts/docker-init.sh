#!/bin/bash

apt-get update
apt-get install -y git python3.11 build-essential cmake autoconf autogen automake libtool pkg-config ragel wget xxd

git config --global pull.rebase false
ln -sf /usr/bin/python3.11 /usr/bin/python