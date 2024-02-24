#!/usr/bin/env bats

@test "1.1.1.1 Asegurar que el montaje de sistemas de archivos cramfs esté deshabilitado (Automatizado)" {
    run bash -c "modprobe -n -v cramfs | grep -E '(cramfs|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep cramfs"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.1.2 Asegurar que el montaje de sistemas de archivos freevxfs esté deshabilitado (Automatizado)" {
    run bash -c "modprobe -n -v freevxfs | grep -E '(freevxfs|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep freevxfs"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.1.3 Asegurar que el montaje de sistemas de archivos jffs2 esté deshabilitado (Automatizado)" {
    run bash -c "modprobe -n -v jffs2 | grep -E '(jffs2|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep jffs2"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.1.4 Asegurar que el montaje de sistemas de archivos hfs esté deshabilitado (Automatizado)" {
    run bash -c "modprobe -n -v hfs| grep -E '(hfs|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep hfs"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.1.5 Asegurar que el montaje de sistemas de archivos hfsplus esté deshabilitado (Automatizado)" {
    run bash -c "modprobe -n -v hfsplus| grep -E '(hfsplus|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep hfsplus"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.1.6 Asegurar que el montaje de sistemas de archivos squashfs esté deshabilitado (Manual)" {
    run bash -c "modprobe -n -v squashfs | grep -E '(squashfs|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true" ]
    run bash -c "lsmod | grep squashfs"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.1.7 Asegurar que el montaje de sistemas de archivos udf esté deshabilitado (Automatizado)" {
    run bash -c "modprobe -n -v udf | grep -E '(udf|install)'"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep udf"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.2 Asegurar que /tmp esté configurado (Automatizado)" {
    run bash -c "findmnt -n /tmp"
    [ "$status" -eq 0 ]
    [[ "$output" == "/tmp "* ]]
    local FSTAB=$(grep -E '\s/tmp\s' /etc/fstab | grep -E -v '^\s*#')
    local TMPMOUNT=$(systemctl is-enabled tmp.mount)
    [[ "$FSTAB" != "" ]] || [ "$TMPMOUNT" = "enabled" ]
}

@test "1.1.3 Asegurar que la opción nodev esté configurada en la partición /tmp (Automatizado)" {
    run bash -c "findmnt -n /tmp | grep -v nodev"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.4 Asegurar que la opción nosuid esté configurada en la partición /tmp (Automatizado)" {
    run bash -c "findmnt -n /tmp | grep -v nosuid"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.5 Asegurar que la opción noexec esté configurada en la partición /tmp (Automatizado)" {
    run bash -c "findmnt -n /tmp | grep -v noexec"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.6 Asegurar que /dev/shm esté configurado (Automatizado)" {
    run bash -c "findmnt -n /dev/shm"
    [ "$status" -eq 0 ]
    [[ "$output" = "/dev/shm "* ]]
}

@test "1.1.7 Asegurar que la opción nodev esté configurada en la partición /dev/shm (Automatizado)" {
    run bash -c "findmnt -n /dev/shm | grep -v nodev"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.8 Asegurar que la opción nosuid esté configurada en la partición /dev/shm (Automatizado)" {
    run bash -c "findmnt -n /dev/shm | grep -v nosuid"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.9 Asegurar que la opción noexec esté configurada en la partición /dev/shm (Automatizado)" {
    run bash -c "findmnt -n /dev/shm | grep -v noexec"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.10 Asegurar que existe una partición separada para /var (Automatizado)" {
    run bash -c "findmnt /var"
    [ "$status" -eq 0 ]
    [[ "$output" == *"/var "* ]]
}

@test "1.1.11 Asegurar que existe una partición separada para /var/tmp (Automatizado)" {
    run bash -c "findmnt /var/tmp"
    [ "$status" -eq 0 ]
    [[ "$output" == *"/var/tmp "* ]]
}

@test "1.1.12 Asegurar que la partición /var/tmp incluya la opción nodev (Automatizado)" {
    run bash -c "findmnt -n /var/tmp | grep -v nodev"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.13 Asegurar que la partición /var/tmp incluya la opción nosuid (Automatizado)" {
    run bash -c "findmnt -n /var/tmp | grep -v nosuid"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.14 Asegurar que la partición /var/tmp incluya la opción noexec (Automatizado)" {
    run bash -c "findmnt -n /var/tmp | grep -v noexec"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.15 Asegurar que existe una partición separada para /var/log (Automatizado)" {
    run bash -c "findmnt /var/log"
    [ "$status" -eq 0 ]
    [[ "$output" == *"/var/log "* ]]
}

@test "1.1.16 Asegurar que existe una partición separada para /var/log/audit (Automatizado)" {
    run bash -c "findmnt /var/log/audit"
    [ "$status" -eq 0 ]
    [[ "$output" == *"/var/log/audit "* ]]
}

@test "1.1.17 Asegurar que existe una partición separada para /home (Automatizado)" {
    run bash -c "findmnt /home"
    [ "$status" -eq 0 ]
    [[ "$output" == *"/home "* ]]
}

@test "1.1.18 Asegurar que la partición /home incluya la opción nodev (Automatizado)" {
    run bash -c "findmnt -n /home | grep -v nodev"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}

@test "1.1.19 Asegurar que la opción nodev esté configurada en las particiones de medios extraíbles (Manual)" {
    skip "Esta control debe realizarse manualmente"
}

@test "1.1.20 Asegurar que la opción nosuid esté configurada en las particiones de medios extraíbles (Manual)" {
    skip "Esta control debe realizarse manualmente"
}

@test "1.1.21 Asegurar que la opción noexec esté configurada en las particiones de medios extraíbles (Manual)" {
    skip "Esta control debe realizarse manualmente"
}

@test "1.1.22 Asegurar que el bit sticky esté configurado en todos los directorios con permisos de escritura para todos los usuarios (Automatizado)" {
    run bash -c 'df --local -P | awk '\''{if (NR!=1) print $6}'\'' | xargs -I '\''{}'\'' find '\''{}'\'' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null'
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "1.1.23 Deshabilitar el montaje automático (Automatizado)" {
    run bash -c "systemctl is-enabled autofs"
    if [ "$status" -eq 0 ]; then
        [ "$output" != "enabled" ]
    fi
}

@test "1.1.24 Deshabilitar el almacenamiento USB (Automatizado)" {
    run bash -c "modprobe -n -v usb-storage"
    [ "$status" -eq 0 ]
    [ "$output" = "install /bin/true " ]
    run bash -c "lsmod | grep usb-storage"
    [ "$status" -eq 1 ]
    [ "$output" = "" ]
}
