#!/bin/bash

apt-get update
apt-get install -y git python build-essential cmake autoconf autogen libtool pkg-config ragel

git config --global pull.rebase false
