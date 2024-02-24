#!/usr/bin/env bats

@test "1.7.1 Asegurar que el mensaje del día esté configurado correctamente (Automatizado)" {
    run bash -c 'grep -Eis "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/motd'
    [ "$status" -eq 1 ]
}

@test "1.7.2 Asegurar que el banner de advertencia de inicio de sesión local esté configurado correctamente (Automatizado)" {
    run bash -c 'grep -Eis "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/issue'
    [ "$status" -eq 1 ]
}

@test "1.7.3 Asegurar que el banner de advertencia de inicio de sesión remoto esté configurado correctamente (Automatizado)" {
    run bash -c 'grep -Eis "(\\\v|\\\r|\\\m|\\\s|$(grep '\''^ID='\'' /etc/os-release | cut -d= -f2 | sed -e '\''s/"//g'\''))" /etc/issue.net'
    [ "$status" -eq 1 ]
}

@test "1.7.4 Asegurar que los permisos en /etc/motd estén configurados correctamente (Automatizado)" {
    if [ -f /etc/motd ]; then
        run bash -c "stat -L /etc/motd | grep -E \"Uid: \([[:space:]]+0/[[:space:]]+root\)\""
        [ "$status" -eq 0 ]
        run bash -c "stat -L /etc/motd | grep -E \"Gid: \([[:space:]]+0/[[:space:]]+root\)\""
        [ "$status" -eq 0 ]
        run bash -c "stat -L /etc/motd | grep \"Access: (0644/\""
        [ "$status" -eq 0 ]
    fi
}

@test "1.7.5 Asegurar que los permisos en /etc/issue estén configurados correctamente (Automatizado)" {
    if [ -f /etc/issue ]; then
        run bash -c "stat /etc/issue | grep -E \"Uid: \([[:space:]]+0/[[:space:]]+root\)\""
        [ "$status" -eq 0 ]
        run bash -c "stat /etc/issue | grep -E \"Gid: \([[:space:]]+0/[[:space:]]+root\)\""
        [ "$status" -eq 0 ]
        run bash -c "stat /etc/issue | grep \"Access: (0644/\""
        [ "$status" -eq 0 ]
    fi
}

@test "1.7.6 Asegurar que los permisos en /etc/issue.net estén configurados correctamente (Automatizado)" {
    if [ -f /etc/issue.net ]; then
        run bash -c "stat /etc/issue.net | grep -E \"Uid: \([[:space:]]+0/[[:space:]]+root\)\""
        [ "$status" -eq 0 ]
        run bash -c "stat /etc/issue.net | grep -E \"Gid: \([[:space:]]+0/[[:space:]]+root\)\""
        [ "$status" -eq 0 ]
        run bash -c "stat /etc/issue.net | grep \"Access: (0644/\""
        [ "$status" -eq 0 ]
    fi
}
