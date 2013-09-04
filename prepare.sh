#!/usr/bin/env bash

MY_DIR=$(dirname $0)
for script in ${MY_DIR}/helpers/*.sh; do
  echo "Loading... $script"
  . $script --source-only
done

shout(){
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "$@"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}

## tested tried script at CentOS 6.4

export SWIFTR_BASEDIR='/etc/swift'

shout "Installing all pre-requisites"
pre_requisite # from helpers

SWIFTR_HOST_IPv4=`ip -4 -o addr | awk '{print $2,$4}' | grep '^e' | tail -1 | awk '{print $2}'`
export SWIFTR_HOST_IPv4=`echo $SWIFTR_HOST_IPv4 | awk -F '/' '{print $1}'`
shout "IP is ${SWIFTR_HOST_IPv4}"

shout "Instaling Swift Auth"
get_swauth # from helpers

shout "Configure SWIFT"
mkdir -p $SWIFTR_BASEDIR
export SWIFT_HASH=`od -t x8 -N 8 -A n </dev/random`

configure_swift # from helpers

shout "Create Certification"
cd $SWIFTR_BASEDIR
certify # ./helpers/certifier.sh

shout "Restart Memcache"
service memcached restart ; ps -aux | grep mem

shout "Configure Swift Proxy and RSyslog"
#configuration from helpers
configure_swift_proxy
configure_rsyslog

## create Ring (nodes and proxy)
shout "Swift Ringer"
swift_ringer

service rsyslog restart
chown -R swift:swift $SWIFTR_BASEDIR

#swift-init proxy restart
swift-init main restart

# clean-up
unset SWIFTR_KEY
unset SWIFTR_CERT
unset SWIFTR_HOST_IPv4
