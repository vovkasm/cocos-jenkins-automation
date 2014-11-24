#!/usr/bin/bash

sudo apt-get update
sudo apt-get install -y build-essential cmake ninja
bash /vagrant/cocos2d-x/build/install-deps-linux.sh

mkdir -p build && cd build && cmake -GNinja /vagrant/cocos2d-x && ninja -v
