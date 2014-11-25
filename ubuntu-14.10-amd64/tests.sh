#!/usr/bin/bash

sudo apt-get update
sudo apt-get install -y build-essential cmake
bash /vagrant/cocos2d-x/build/install-deps-linux.sh

mkdir -p build && cd build && cmake /vagrant/cocos2d-x && make -j2
