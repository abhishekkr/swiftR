#!/usr/bin/env bash

configure_swift(){
    cat > $SWIFTR_BASEDIR/swift.conf << EOF_SWIFT
[swift-hash]

swift_hash_path_suffix = $SWIFT_HASH
EOF_SWIFT
}

configure_swift_proxy(){
shout "IP is ${SWIFTR_HOST_IPv4}"

    cat > $SWIFTR_BASEDIR/proxy-server.conf << EOF_SWIFT_PROXY
[DEFAULT]
cert_file = ${SWIFTR_BASEDIR}/${swiftr_cert}
key_file = ${SWIFTR_BASEDIR}/${swiftr_key}
bind_port = 8080
workers = 8
user = swift
log_facility = LOG_LOCAL0
allow_account_management = true

[pipeline:main]
pipeline = healthcheck cache swauth proxy-server

[app:proxy-server]
use = egg:swift#proxy
allow_account_management = true
account_autocreate = true
log_facility = LOG_LOCAL0
log_headers = true
log_level =DEBUG

[filter:swauth]
use = egg:swauth#swauth
default_swift_cluster = local#https://${SWIFTR_HOST_IPv4}:8080/v1
super_admin_key = swauthkey
log_facility = LOG_LOCAL1
log_headers = true
log_level =DEBUG
allow_account_management = true

[filter:healthcheck]
use = egg:swift#healthcheck

[filter:cache]
use = egg:swift#memcache
memcache_servers = ${SWIFTR_HOST_IPv4}:11211

EOF_SWIFT_PROXY
}

configure_rsyslog(){
    cat >> /etc/rsyslog.conf << EOF_RSYSLOG
local0.* /var/log/swift/proxy.log

local1.* /var/log/swift/swauth.log
EOF_RSYSLOG
}
