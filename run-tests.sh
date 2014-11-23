#!/usr/bin/bash

test_variant=$1

cp automation/$test_variant/Vagrantfile Vagrantfile
cp automation/$test_variant/tests.sh tests.sh

vagrant destroy -f
vagrant up || exit 1
vagrant ssh -c "sh /vagrant/tests.sh" || exit 1
vagrant halt
