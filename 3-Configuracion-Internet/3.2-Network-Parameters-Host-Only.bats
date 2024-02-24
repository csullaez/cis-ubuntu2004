#!/usr/bin/env bats

load IPv6-helper

@test "3.2.1 Asegurar que el envío de redirecciones de paquetes esté desactivado (Automatizado)" {
    run bash -c "sysctl net.ipv4.conf.all.send_redirects"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.all.send_redirects = 0" ]
    run bash -c "sysctl net.ipv4.conf.default.send_redirects"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.default.send_redirects = 0" ]
    run bash -c "grep \"net\.ipv4\.conf\.all\.send_redirects\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.all.send_redirects = 0" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
    run bash -c "grep \"net\.ipv4\.conf\.default\.send_redirects\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.default.send_redirects = 0" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
}

@test "3.2.2 Asegurar que el reenvío de IP esté desactivado (Automatizado)" {
    # IPv4
    run bash -c "sysctl net.ipv4.ip_forward"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.ip_forward = 0" ]
    run bash -c "grep -E -s \"^\s*net\.ipv4\.ip_forward\s*=\s*1\" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf"
    [ "$status" -ne 0 ]
    [ "$output" = "" ]
    # IPv6
    run check_ip_v6
    [ "$status" -eq 0 ]
    if [[ "$output" == *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        run bash -c "sysctl net.ipv6.conf.all.forwarding"
        [ "$status" -eq 0 ]
        [ "$output" = "net.ipv6.conf.all.forwarding = 0" ]
        run bash -c "grep -E -s \"^\s*net\.ipv6\.conf\.all\.forwarding\s*=\s*1\" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf"
        [ "$status" -ne 0 ]
        [ "$output" = "" ]
    fi
}
