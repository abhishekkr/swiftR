swift_mkdev(){
    mkfs.xfs -f -i size=512 -L d1 /dev/sdb
    mkfs.xfs -f -i size=512 -L d2 /dev/sdc
    mkfs.xfs -f -i size=512 -L d3 /dev/sdd
    mkfs.xfs -f -i size=512 -L d4 /dev/sde
}

swift_mount_dev(){
    for idx in 1 2 3 4; do
        mkdir -p /srv/node/d$idx
        mount -t xfs -L d$idx /srv/node/d$idx
    done
}

swift_validate_ring(){
    for typ in object container account; do
        swift-ring-builder "${typ}.builder"
    done
}

swift_ringer(){
    cd $SWIFTR_BASEDIR

    for typ in object container account; do
        swift-ring-builder "${typ}.builder" create 18 3 1
    done

    shout "IP is ${SWIFTR_HOST_IPv4} : $1"
    port_idx=0
    for typ in object container account; do
        for idx in 1 2 3 4; do
            swift-ring-builder "${typ}.builder" add "z${idx}-${SWIFTR_HOST_IPv4}:600${port_idx}/d${idx}" 100
        done
        let port_idx++
    done

    swift_validate_ring

    for typ in object container account; do
        swift-ring-builder "${typ}.builder" rebalance
    done
}
