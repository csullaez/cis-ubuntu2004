#!/usr/bin/env bats

@test "1.6.1.1 Asegurar que AppArmor esté instalado (Automatizado)" {
    run bash -c "dpkg -s apparmor | grep -E '(Status:|not installed)'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Status: install ok installed"* ]]
}

@test "1.6.1.2 Asegurar que AppArmor esté habilitado en la configuración del cargador de arranque (Automatizado)" {
    run bash -c "grep \"^\s*linux\" /boot/grub/grub.cfg | grep -v \"apparmor=1\""
    [ "$status" -eq 1 ]
    [[ "$output" == "" ]]

    run bash -c "grep \"^\s*linux\" /boot/grub/grub.cfg | grep -v \"security=apparmor\""
    [ "$status" -eq 1 ]
    [[ "$output" == "" ]]
}

@test "1.6.1.3 Asegurar que todos los perfiles de AppArmor estén en modo de cumplimiento o queja (Automatizado)" {
    run bash -c "apparmor_status | grep profiles | grep -E '^0 profiles are loaded.'"
    [ "$status" -eq 1 ]

    local enforce_mode
    run bash -c "apparmor_status | grep profiles | grep -E '^0 profiles are in enforce mode.'"
    enforce_mode=$?

    local complain_mode
    run bash -c "apparmor_status | grep profiles | grep -E '^0 profiles are in complain mode.'"
    complain_mode=$?

    [ "$enforce_mode" -eq 0 ] || [ "$complain_mode" -eq 0 ]

    run bash -c "apparmor_status | grep processes | grep -E '^0 processes are unconfined'"
    [ "$status" -eq 0 ]
}

@test "1.6.1.4 Asegurar que todos los perfiles de AppArmor estén aplicando (Automatizado)" {
    run bash -c "apparmor_status | grep -E '^0 profiles are loaded'"
    [ "$status" -eq 1 ]

    run bash -c "apparmor_status | grep profiles | grep -E '^0 profiles are in complain mode.'"
    [ "$status" -eq 0 ]

    run bash -c "apparmor_status | grep processes | grep -E '^0 processes are unconfined'"
    [ "$status" -eq 0 ]
}
