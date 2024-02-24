#!/usr/bin/env bats

@test "1.4.1 Asegurar que los permisos en la configuración del cargador de arranque no estén sobrescritos (Automatizado)" {
    run bash -c 'grep -E '\''^\s*chmod\s+[0-7][0-7][0-7]\s+\$\{grub_cfg\}\.new'\'' -A 1 -B1 /usr/sbin/grub-mkconfig'
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == 'if [ "x${grub_cfg}" != "x" ]; then' ]]
    [[ "${lines[1]}" == '  chmod 400 ${grub_cfg}.new || true' ]]
    [[ "${lines[2]}" == *"fi" ]]
}

@test "1.4.2 Asegurar que se establezca una contraseña para el cargador de arranque (Automatizado)" {
    run bash -c "grep \"^set superusers\" /boot/grub/grub.cfg"
    [ "$status" -eq 0 ]
    [[ "$output" == "set superusers="* ]]
    run bash -c "grep \"^password\" /boot/grub/grub.cfg"
    [ "$status" -eq 0 ]
    [[ "$output" == "password_pbkdf2 "* ]]
}

@test "1.4.3 Asegurar que los permisos en la configuración del cargador de arranque estén configurados (Automatizado)" {
    run bash -c "stat /boot/grub/grub.cfg"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Access: (0400"* ]]
    [[ "$output" == *"Uid: (    0/    root)"* ]]
    [[ "$output" == *"Gid: (    0/    root)"* ]]
}

@test "1.4.4 Asegurar que se requiera autenticación para el modo de usuario único (Automatizado)" {
    run bash -c 'grep -Eq '\''^root:\$[0-9]'\'' /etc/shadow || echo "root is locked"'
    [ "$status" -eq 0 ]
    [[ "$output" == "" ]]
}
