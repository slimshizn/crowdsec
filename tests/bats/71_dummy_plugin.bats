#!/usr/bin/env bats
# vim: ft=bats:list:ts=8:sts=4:sw=4:et:ai:si:

set -u

setup_file() {
    load "../lib/setup_file.sh" >&3 2>&1
    ./instance-data load

    tempfile=$(TMPDIR="${BATS_FILE_TMPDIR}" mktemp)
    export tempfile

    yq "
        .group_wait=\"5s\" |
        .group_threshold=2 |
        .output_file=\"${tempfile}\"
    " -i "${CONFIG_DIR}/notifications/dummy.yaml"

    yq '
        .notifications=["dummy_default"] |
        .filters=["Alert.GetScope() == \"Ip\""]
    ' -i "${CONFIG_DIR}/profiles.yaml"

    yq '
        .plugin_config.user="" |
        .plugin_config.group=""
    ' -i "${CONFIG_DIR}/config.yaml"

    ./instance-crowdsec start
}

teardown_file() {
    load "../lib/teardown_file.sh" >&3 2>&1
}

setup() {
    load "../lib/setup.sh"
}

#----------

@test "$FILE add two bans" {
    run -0 cscli decisions add --ip 1.2.3.4 --duration 30s
    assert_output --partial 'Decision successfully added'

    run -0 cscli decisions add --ip 1.2.3.5 --duration 30s
    assert_output --partial 'Decision successfully added'
    sleep 2
}

@test "$FILE expected 1 notification" {
    run -0 cat "${tempfile}"
    assert_output --partial 1.2.3.4
    assert_output --partial 1.2.3.5
}
