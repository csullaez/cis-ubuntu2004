#!/usr/bin/env bats

@test "3.4.1 Asegurar que DCCP esté desactivado (Automatizado)" {
    run bash -c "modprobe -n -v dccp"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep dccp"
    [ "$status" -ne 0 ]
    [ "$output" = "" ]
}

@test "3.4.2 Asegurar que SCTP esté desactivado (Automatizado)" {
    run bash -c "modprobe -n -v sctp | grep -E '(sctp|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep sctp"
    [ "$status" -ne 0 ]
    [ "$output" = "" ]
}

@test "3.4.3 Asegurar que RDS esté desactivado (Automatizado)" {
    run bash -c "modprobe -n -v rds"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep rds"
    [ "$status" -ne 0 ]
    [ "$output" = "" ]
}

@test "3.4.4 Asegurar que TIPC esté desactivado (Automatizado)" {
    run bash -c "modprobe -n -v tipc | grep -E '(tipc|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep tipc"
    [ "$status" -ne 0 ]
    [ "$output" = "" ]
}
