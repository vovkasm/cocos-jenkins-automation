#!/usr/bin/bash

wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh epel-release-6*.rpm 

# GCC
sudo wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
sudo yum -y install devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++
PATH=/opt/rh/devtoolset-2/root/usr/bin:$PATH

sudo yum -y update
sudo yum -y install cmake

# deps
sudo yum -y install freeglut freeglut-devel \
 libX11-devel mesa-libGLU-devel libXrandr-devel libXinerama-devel libXinput-devel \
 libXi-devel libXcursor-devel libXxf86vm-devel \
 libzip-devel libpng-devel libcurl-devel fontconfig-devel sqlite-devel gnutls-devel 

# glfw & glew (glew exists in CentOS but very old)
sudo yum -y install git doxygen curl

git clone https://github.com/nigels-com/glew.git
(cd glew && make extensions && make && sudo make install)

glfw_ver=3.0.4
curl -o glfw-${glfw_ver}.tar.gz https://codeload.github.com/glfw/glfw/tar.gz/${glfw_ver}
tar xzf glfw-${glfw_ver}.tar.gz
(mkdir -p build-glfw && cd build-glfw && cmake ../glfw-${glfw_ver} && make && sudo make install)

mkdir -p build && cd build && cmake /vagrant/cocos2d-x && make -j4
