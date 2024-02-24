#!/usr/bin/env bats

@test "2.2.1 Asegurar que el cliente NIS no esté instalado (Automatizado)" {
    run bash -c "dpkg -s nis | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'nis' is not installed and no information is available"* ]]
}

@test "2.2.2 Asegurar que el cliente rsh no esté instalado (Automatizado)" {
    run bash -c "dpkg -s rsh-client | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'rsh-client' is not installed and no information is available"* ]]
}

@test "2.2.3 Asegurar que el cliente talk no esté instalado (Automatizado)" {
    run bash -c "dpkg -s talk | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'talk' is not installed and no information is available"* ]]
}

@test "2.2.4 Asegurar que el cliente telnet no esté instalado (Automatizado)" {
    run bash -c "dpkg -s telnet | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'telnet' is not installed and no information is available"* ]]
}

@test "2.2.5 Asegurar que el cliente LDAP no esté instalado (Automatizado)" {
    run bash -c "dpkg -s ldap-utils | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'ldap-utils' is not installed and no information is available"* ]]
}

@test "2.2.6 Asegurar que RPC no esté instalado (Automatizado)" {
    run bash -c "dpkg -s rpcbind | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'rpcbind' is not installed and no information is available"* ]]
}
