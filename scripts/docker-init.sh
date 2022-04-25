#!/bin/bash

apt-get update
apt-get install -y git python3 build-essential cmake

git config --global pull.rebase false
