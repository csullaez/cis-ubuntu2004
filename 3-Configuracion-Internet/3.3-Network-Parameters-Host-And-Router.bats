#!/usr/bin/env bats

load IPv6-helper

grep "net\.ipv4\.conf\.all\.accept_source_route" /etc/sysctl.conf /etc/sysctl.d/*

@test "3.3.1 Asegurar que los paquetes con ruta de origen no sean aceptados (Automatizado)" {
    # pruebas para ipv4
    run bash -c "sysctl net.ipv4.conf.all.accept_source_route"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.all.accept_source_route = 0" ]
    run bash -c "sysctl net.ipv4.conf.default.accept_source_route"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.default.accept_source_route = 0" ]
    run bash -c "grep \"net\.ipv4\.conf\.all\.accept_source_route\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_ALL_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.all.accept_source_route = 0" ]]; then
            CONF_ALL_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_ALL_FILE_CORRECT -eq 1 ]
    run bash -c "grep \"net\.ipv4\.conf\.default\.accept_source_route\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_DEFAULT_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.default.accept_source_route = 0" ]]; then
            CONF_DEFAULT_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_DEFAULT_FILE_CORRECT -eq 1 ]

    run check_ip_v6
    [ $status -eq 0 ]
    if [[ "$output" == *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        # pruebas para ipv6
        run bash -c "sysctl net.ipv6.conf.all.accept_source_route"
        [ "$status" -eq 0 ]
        [ "$output" = "net.ipv6.conf.all.accept_source_route = 0" ]
        run bash -c "sysctl net.ipv6.conf.default.accept_source_route"
        [ "$status" -eq 0 ]
        [ "$output" = "net.ipv6.conf.default.accept_source_route = 0" ]
        run bash -c "grep \"net\.ipv6\.conf\.all\.accept_source_route\" /etc/sysctl.conf /etc/sysctl.d/*"
        [ "$status" -eq 0 ]
        # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
        local CONF_FILE_CORRECT=0
        while IFS= read -r line; do
            if [[ "$line" == *":net.ipv6.conf.all.accept_source_route = 0" ]]; then
                CONF_FILE_CORRECT=1
            fi
        done <<< "$output"
        [ $CONF_FILE_CORRECT -eq 1 ]
        run bash -c "grep \"net\.ipv6\.conf\.default\.accept_source_route\" /etc/sysctl.conf /etc/sysctl.d/*"
        [ "$status" -eq 0 ]
        # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
        local CONF_FILE_CORRECT=0
        while IFS= read -r line; do
            if [[ "$line" == *":net.ipv6.conf.default.accept_source_route = 0" ]]; then
                CONF_FILE_CORRECT=1
            fi
        done <<< "$output"
        [ $CONF_FILE_CORRECT -eq 1 ]
    fi
}

@test "3.3.2 Asegurar que las redirecciones ICMP no sean aceptadas (Automatizado)" {
    # comprobaciones para ipv4
    run bash -c "sysctl net.ipv4.conf.all.accept_redirects"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.all.accept_redirects = 0" ]
    run bash -c "sysctl net.ipv4.conf.default.accept_redirects"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.default.accept_redirects = 0" ]
    run bash -c "grep \"net\.ipv4\.conf\.all\.accept_redirects\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.all.accept_redirects = 0" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
    run bash -c "grep \"net\.ipv4\.conf\.default\.accept_redirects\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.default.accept_redirects = 0" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]

    # comprobaciones para ipv6
    run check_ip_v6
    [ $status -eq 0 ]
    if [[ "$output" == *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        run bash -c "sysctl net.ipv6.conf.all.accept_redirects"
        [ "$status" -eq 0 ]
        [ "$output" = "net.ipv6.conf.all.accept_redirects = 0" ]
        run bash -c "sysctl net.ipv6.conf.default.accept_redirects"
        [ "$status" -eq 0 ]
        [ "$output" = "net.ipv6.conf.default.accept_redirects = 0" ]
        run bash -c "grep \"net\.ipv6\.conf\.all\.accept_redirects\" /etc/sysctl.conf /etc/sysctl.d/*"
        [ "$status" -eq 0 ]
        # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
        local CONF_FILE_CORRECT=0
        while IFS= read -r line; do
            if [[ "$line" == *":net.ipv6.conf.all.accept_redirects = 0" ]]; then
                CONF_FILE_CORRECT=1
            fi
        done <<< "$output"
        [ $CONF_FILE_CORRECT -eq 1 ]
        run bash -c "grep \"net\.ipv6\.conf\.default\.accept_redirects\" /etc/sysctl.conf /etc/sysctl.d/*"
        [ "$status" -eq 0 ]
        # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
        local CONF_FILE_CORRECT=0
        while IFS= read -r line; do
            if [[ "$line" == *":net.ipv6.conf.default.accept_redirects = 0" ]]; then
                CONF_FILE_CORRECT=1
            fi
        done <<< "$output"
        [ $CONF_FILE_CORRECT -eq 1 ]
    fi
}

@test "3.3.3 Asegurar que las redirecciones ICMP seguras no sean aceptadas (Automatizado)" {
    run bash -c "sysctl net.ipv4.conf.all.secure_redirects"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.all.secure_redirects = 0" ]
    run bash -c "sysctl net.ipv4.conf.default.secure_redirects"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.default.secure_redirects = 0" ]
    run bash -c "grep \"net\.ipv4\.conf\.all\.secure_redirects\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.all.secure_redirects = 0" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
    run bash -c "grep \"net\.ipv4\.conf\.default\.secure_redirects\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.default.secure_redirects = 0" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
}

@test "3.3.4 Asegurar que los paquetes sospechosos sean registrados (Automatizado)" {
    run bash -c "sysctl net.ipv4.conf.all.log_martians"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.all.log_martians = 1" ]
    run bash -c "sysctl net.ipv4.conf.default.log_martians"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.default.log_martians = 1" ]
    run bash -c "grep \"net\.ipv4\.conf\.all\.log_martians\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.all.log_martians = 1" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
    run bash -c "grep "net\.ipv4\.conf\.default\.log_martians" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.default.log_martians = 1" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
}

@test "3.3.5 Asegurar que se ignoren las solicitudes de ICMP de difusión (Automatizado)" {
    run bash -c "sysctl net.ipv4.icmp_echo_ignore_broadcasts"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.icmp_echo_ignore_broadcasts = 1" ]
    run bash -c "grep \"net\.ipv4\.icmp_echo_ignore_broadcasts\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.icmp_echo_ignore_broadcasts = 1" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
}

@test "3.3.6 Asegurar que se ignoren las respuestas de ICMP falsas (Automatizado)" {
    run bash -c "sysctl net.ipv4.icmp_ignore_bogus_error_responses"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.icmp_ignore_bogus_error_responses = 1" ]
    run bash -c "grep \"net.ipv4.icmp_ignore_bogus_error_responses\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.icmp_ignore_bogus_error_responses = 1" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
}

@test "3.3.7 Asegurar que se habilite el filtrado de ruta inversa (Automatizado)" {
    run bash -c "sysctl net.ipv4.conf.all.rp_filter"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.all.rp_filter = 1" ]
    run bash -c "sysctl net.ipv4.conf.default.rp_filter"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.conf.default.rp_filter = 1" ]
    run bash -c "grep \"net\.ipv4\.conf\.all\.rp_filter\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.all.rp_filter = 1" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
    run bash -c "grep \"net\.ipv4\.conf\.default\.rp_filter\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.conf.default.rp_filter = 1" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
}

@test "3.3.8 Asegurar que se habiliten las cookies SYN de TCP (Automatizado)" {
    run bash -c "sysctl net.ipv4.tcp_syncookies"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv4.tcp_syncookies = 1" ]
    run bash -c "grep \"net\.ipv4\.tcp_syncookies\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv4.tcp_syncookies = 1" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
}

@test "3.3.9 Asegurar que no se acepten anuncios de router IPv6 (Automatizado)" {
    run check_ip_v6
    [ $status -eq 0 ]
    if [[ "$output" != *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        skip "*** IPv6 no está habilitado en el sistema ***"
    fi

    run bash -c "sysctl net.ipv6.conf.all.accept_ra"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv6.conf.all.accept_ra = 0" ]
    run bash -c "sysctl net.ipv6.conf.default.accept_ra"
    [ "$status" -eq 0 ]
    [ "$output" = "net.ipv6.conf.default.accept_ra = 0" ]
    run bash -c "grep \"net\.ipv6\.conf\.all\.accept_ra\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv6.conf.all.accept_ra = 0" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
    run bash -c "grep \"net\.ipv6\.conf\.default\.accept_ra\" /etc/sysctl.conf /etc/sysctl.d/*"
    [ "$status" -eq 0 ]
    # Verificar si la línea de salida deseada está activa en cualquiera de los archivos de configuración
    local CONF_FILE_CORRECT=0
    while IFS= read -r line; do
        if [[ "$line" == *":net.ipv6.conf.default.accept_ra = 0" ]]; then
            CONF_FILE_CORRECT=1
        fi
    done <<< "$output"
    [ $CONF_FILE_CORRECT -eq 1 ]
}
