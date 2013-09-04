#!/usr/bin/env bash

get_swauth(){
    PRE_SWAUTH_DIR=`pwd`
    SWAUTH_VER="1.0.2+git20111128"
    SWAUTH_PKG="swauth_${SWAUTH_VER}"
    SWAUTH_DIR="swauth-${SWAUTH_VER}"
    curl -skL -C - -o "/tmp/${SWAUTH_PKG}.tgz" "https://launchpad.net/ubuntu/precise/+source/swauth/1.0.2+git20111128-0ubuntu1/+files/${SWAUTH_PKG}.orig.tar.gz"
    cd /tmp
    tar zxvf "/tmp/${SWAUTH_PKG}.tgz"
    cd "/tmp/${SWAUTH_DIR}"
    python setup.py build
    python setup.py install
    cd -
}
