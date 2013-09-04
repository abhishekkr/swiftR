#!/usr/bin/env bash

pre_requisite(){
    sudo yum -y install gcc libvirt memcached xfsprogs openssh-server git-core libffi-devel gzip
    sudo yum -y install sqlite python-setuptools python-devel python-simplejson # python-config

    sudo easy_install pip virtualenv

    mkdir ~/.venv
    virtualenv ~/.venv/swiftR
    source ~/.venv/swiftR/bin/activate

    ~/.venv/swiftR/bin/pip install webob eventlet xattr coverage swift netifaces
    ~/.venv/swiftR/bin/pip install configobj nose simplejson xattr eventlet greenlet pastedeploy

    groupadd swift
    useradd -g swift swift
}
