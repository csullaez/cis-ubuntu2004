#!/usr/bin/env bats

@test "1.5.1 Asegurar que el soporte XD/NX esté habilitado (Manual)" {
    run bash -c "journalctl | grep 'protection: active'"
    [ "$status" -eq 0 ]
}

@test "1.5.2 Asegurar que la aleatorización del espacio de direcciones (ASLR) esté habilitada (Automatizado)" {
    run bash -c "sysctl kernel.randomize_va_space"
    [ "$status" -eq 0 ]
    [[ "$output" == "kernel.randomize_va_space = 2" ]]
    run bash -c "grep -Es \"^\s*kernel\.randomize_va_space\s*=\s*([0-1]|[3-9]|[1-9][0-9]+)\" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf /run/sysctl.d/*.conf"
    [ "$status" -ne 0 ]
    [[ "$output" == "" ]]
}

@test "1.5.3 Asegurar que prelink esté deshabilitado (Automatizado)" {
    run bash -c "dpkg -s prelink | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
    [[ "$output" == *"dpkg-query: package 'prelink' is not installed and no information is available"* ]]
}

@test "1.5.4 Asegurar que los volcados de núcleo estén restringidos (Automatizado)" {
    run bash -c "grep -Es '^(\*|\s).*hard.*core.*(\s+#.*)?$' /etc/security/limits.conf /etc/security/limits.d/*"
    [[ "$output" == *"* hard core 0" ]]

    run bash -c "sysctl fs.suid_dumpable"
    [ "$output" == "fs.suid_dumpable = 0" ]

    run bash -c "grep \"fs.suid_dumpable\" /etc/sysctl.conf /etc/sysctl.d/*"
    [[ "$output" == *"fs.suid_dumpable = 0" ]]
}
