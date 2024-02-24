#!/usr/bin/env bats

@test "1.8.1 Asegurar que GNOME Display Manager esté eliminado (Manual)" {
    run bash -c "dpkg -s gdm3 | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
    [[ "$output" == *"dpkg-query: package 'gdm3' is not installed and no information is available"* ]]
}

@test "1.8.2 Asegurar que el banner de inicio de sesión de GDM esté configurado (Automatizado)" {
    if dpkg -s gdm3; then
        run bash -c "cat /etc/gdm3/greeter.dconf-defaults"
        [ "$status" -eq 0 ]
        [[ "$output" = *"[org/gnome/login-screen]"* ]]
        [[ "$output" = *"banner-message-enable=true"* ]]
        [[ "$output" = *"banner-message-text="* ]]
    fi
}

@test "1.8.3 Asegurar que disable-user-list esté habilitado (Automatizado)" {
    if dpkg -s gdm3; then
        run bash -c "grep -E '^\s*disable-user-list\s*=\s*true\b' /etc/gdm3/greeter.dconf-defaults"
        [ "$status" -eq 0 ]
    fi
}

@test "1.8.4 Asegurar que XDCMP no esté habilitado (Automatizado)" {
    run bash -c "grep -Eis '^\s*Enable\s*=\s*true' /etc/gdm3/custom.conf"
    [ "$status" -ne 0 ]
    [[ "$output" = "" ]]
}
