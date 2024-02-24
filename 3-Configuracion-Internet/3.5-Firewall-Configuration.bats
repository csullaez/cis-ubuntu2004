#!/usr/bin/env bats

load IPv6-helper


@test "3.5.1.1 Asegurar que ufw esté instalado (Automatizado)" {
    [[ $(dpkg -s ufw | grep 'Estado: instalado') == "Estado: instalado ok instalado" ]]
}

@test "3.5.1.2 Asegurar que iptables-persistent no esté instalado con ufw (Automatizado)" {
    run bash -c "dpkg-query -s iptables-persistent"
    [ $status -eq 1 ]
    [[ "$output" == *"paquete 'iptables-persistent' no está instalado y no hay información disponible"* ]]
}

@test "3.5.1.3 Asegurar que el servicio ufw esté habilitado (Automatizado)" {
    [[ $(systemctl is-enabled ufw) == "habilitado" ]]
    [[ $(ufw status | grep Estado) == "Estado: activo" ]]
}

@test "3.5.1.4 Asegurar que el tráfico de loopback de ufw esté configurado (Automatizado)" {
    run bash -c "ufw status verbose"
    [ "$status" -eq 0 ]
    local check1=0 check2=0 check3=0 check4=0 check5=0 check6=0
    for index in ${!lines[*]}
    do
        current_line="${lines[$index]}"
        case "$current_line" in
            "En cualquier lugar en lo"*"PERMITIR EN"*"En cualquier lugar"*) check1=1 ;;
            "En cualquier lugar"*"DENEGAR EN"*"127.0.0.0/8"*) check2=1 ;;
            "En cualquier lugar (v6) en lo"*"PERMITIR EN"*"En cualquier lugar (v6)"*) check3=1 ;;
            "En cualquier lugar (v6)"*"DENEGAR EN"*"::1"*) check4=1 ;;
            "En cualquier lugar"*"PERMITIR FUERA"*"En cualquier lugar en lo"*) check5=1 ;;
            "En cualquier lugar (v6)"*"PERMITIR FUERA"*"En cualquier lugar (v6) en lo"*) check6=1 ;;
            *) ;;
        esac
    done
    [ $check1 -eq 1 ]
    [ $check2 -eq 1 ]
    [ $check3 -eq 1 ]
    [ $check4 -eq 1 ]
    [ $check5 -eq 1 ]
    [ $check6 -eq 1 ]
}

@test "3.5.1.5 Asegurar que las conexiones salientes de ufw estén configuradas (Manual)" {
    skip "Esta auditoría debe hacerse manualmente"
}

@test "3.5.1.6 Asegurar que existan reglas de firewall ufw para todos los puertos abiertos (Manual)" {
    skip "Esta auditoría debe hacerse manualmente"
}

@test "3.5.1.7 Asegurar la política de denegación predeterminada del firewall ufw (Automatizado)" {
    run bash -c "ufw status verbose | grep -i predeterminado"
    [ "$status" -eq 0 ]
    [[ "$output" == *"denegar (entrante)"* || "$output" == *"rechazar (entrante)"* ]]
    [[ "$output" == *"denegar (saliente)"* || "$output" == *"rechazar (saliente)"* ]]
    [[ "$output" == *"denegar (encaminado)"* || "$output" == *"rechazar (encaminado)"* ]]
}

# 3.5.2 Configure nftables

@test "3.5.2.1 Asegurar que nftables esté instalado (Automatizado)" {
    run bash -c "dpkg-query -s nftables | grep 'Estado: instalado ok instalado'"
    [[ "$output" == "Estado: instalado ok instalado" ]]
}

@test "3.5.2.2 Asegurar que ufw esté desinstalado o desactivado con nftables (Automatizado)" {
    run bash -c "dpkg-query -s ufw | grep 'Estado: instalado ok instalado'"
    if [[ ! "$output" == *"paquete 'ufw' no está instalado y no hay información disponible"* ]]; then
        [[ $(ufw status | grep 'Estado') == "Estado: inactivo" ]]
    fi
}

@test "3.5.2.3 Asegurar que se eliminen las iptables con nftables (Manual)" {
    run bash -c "iptables -L"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
    run bash -c "ip6tables -L"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "3.5.2.4 Asegurar que exista una tabla nftables (Automatizado)" {
    run bash -c "nft list tables"
    [ "$status" -eq 0 ]
}

@test "3.5.2.5 Asegurar que existan cadenas base de nftables (Automatizado)" {
    run bash -c "nft list ruleset | grep 'engancha entrada'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"tipo filtro engancha entrada prioridad filtro;"* ]]
    run bash -c "nft list ruleset | grep 'engancha reenviar'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"tipo filtro engancha reenviar prioridad filtro;"* ]]
    run bash -c "nft list ruleset | grep 'engancha salida'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"tipo filtro engancha salida prioridad filtro;"* ]]
}

@test "3.5.2.6 Asegurar que el tráfico de loopback de nftables esté configurado (Automatizado)" {
    run bash -c "nft list ruleset | awk '/engancha entrada/,/}/' | grep 'iif \"lo\" accept'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"iif \"lo\" accept"* ]]
    run bash -c "nft list ruleset | awk '/engancha entrada/,/}/' | grep 'ip saddr'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"ip saddr 127.0.0.0/8 counter packets 0 bytes 0 drop"* ]]
    
    run check_ip_v6
    [ $status -eq 0 ]
    if [[ "$output" == *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        run bash -c "nft list ruleset | awk '/engancha entrada/,/}/' | grep 'ip6 saddr'"
        [ "$status" -eq 0 ]
        [[ "$output" == *"ip6 saddr ::1 counter packets 0 bytes 0 drop"* ]]
    fi
}

@test "3.5.2.7 Asegurar que las conexiones salientes y establecidas de nftables estén configuradas (Manual)" {
    run bash -c "nft list ruleset | awk '/engancha entrada/,/}/' | grep -E 'ip protocolo (tcp|udp|icmp) ct estado'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"ip protocolo tcp ct estado establecido aceptar"* ]]
    [[ "$output" == *"ip protocolo udp ct estado establecido aceptar"* ]]
    [[ "$output" == *"ip protocolo icmp ct estado establecido aceptar"* ]]

    run bash -c "nft list ruleset | awk '/engancha salida/,/}/' | grep -E 'ip protocolo (tcp|udp|icmp) ct estado'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"ip protocolo tcp ct estado establecido,relacionado,nuevo aceptar"* ]]
    [[ "$output" == *"ip protocolo udp ct estado establecido,relacionado,nuevo aceptar"* ]]
    [[ "$output" == *"ip protocolo icmp ct estado establecido,relacionado,nuevo aceptar"* ]]
}

@test "3.5.2.8 Asegurar la política de denegación predeterminada de nftables (Automatizado)" {
    run bash -c "nft list ruleset | grep 'engancha entrada'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"tipo filtro engancha entrada prioridad filtro; política drop;"* ]]
    run bash -c "nft list ruleset | grep 'engancha reenviar'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"tipo filtro engancha reenviar prioridad filtro; política drop;"* ]]
    run bash -c "nft list ruleset | grep 'engancha salida'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"tipo filtro engancha salida prioridad filtro; política drop;"* ]]
}

@test "3.5.2.9 Asegurar que el servicio nftables esté habilitado (Automatizado)" {
    run bash -c "systemctl is-enabled nftables"
    [[ "$output" == "habilitado" ]]
}

@test "3.5.2.10 Asegurar que las reglas de nftables sean permanentes (Automatizado)" {
    skip "Esta auditoría debe hacerse manualmente"
}

# 3.5.3 Configure iptables

## 3.5.3.1 Configure el software iptables

@test "3.5.3.1.1 Asegurar que los paquetes iptables estén instalados (Automatizado)" {
    run bash -c "apt list iptables iptables-persistent | grep instalado"
    [ $status -eq 0 ]
    [[ "$output" =~ iptables[^-].*\[(instalado(,automático)*)\] ]]
    [[ "$output" =~ iptables-persistent.*\[(instalado(,automático)*)\] ]]
}

@test "3.5.3.1.2 Asegurar que nftables no esté instalado con iptables (Automatizado)" {
    run bash -c "dpkg -s nftables | grep 'dpkg-query'"
    [ $status -eq 1 ]
    [[ "$output" == *"dpkg-query: el paquete 'nftables' no está instalado"* ]]
}

@test "3.5.3.1.3 Asegurar que ufw esté desinstalado o desactivado con iptables (Automatizado)" {
    run bash -c "dpkg -s ufw | grep 'dpkg-query'"
    if [[ ! "$output" == *"dpkg-query: el paquete 'ufw' no está instalado y no hay información disponible"* ]]; then
        [[ $(ufw status | grep 'Estado') == "Estado: inactivo" ]]
    fi
}

## 3.5.3.2 Configurar iptables IPv4

@test "3.5.3.2.1 Asegurar que el tráfico de loopback de iptables esté configurado (Automatizado)" {
    run bash -c "iptables -L INPUT -v -n"
    [ "$status" -eq 0 ]
    [[ "$output" = *"ACEPTAR"*"todo"*"--"*"lo"*"*"*"0.0.0.0/0"*"0.0.0.0/0"* ]]
    [[ "$output" = *"DEJAR"*"todo"*"--"*"*"*"*"*"127.0.0.0/8"*"0.0.0.0/0"* ]]
    run bash -c "iptables -L OUTPUT -v -n"
    [ "$status" -eq 0 ]
    [[ "$output" = *"ACEPTAR"*"todo"*"--"*"*"*"lo"*"0.0.0.0/0"*"0.0.0.0/0"* ]]
}

@test "3.5.3.2.2 Asegurar que las conexiones salientes y establecidas de iptables estén configuradas (Manual)" {
    skip "Esta auditoría debe hacerse manualmente"
}

@test "3.5.3.2.3 Asegurar la política de denegación predeterminada de iptables (Automatizado)" {
    run bash -c "iptables -L"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Cadena INPUT (política DROP)"* || "$output" == *"Cadena INPUT (política REJECT)"* ]]
    [[ "$output" == *"Cadena FORWARD (política DROP)"* || "$output" == *"Cadena FORWARD (política REJECT)"* ]]
    [[ "$output" == *"Cadena OUTPUT (política DROP)"* || "$output" == *"Cadena OUTPUT (política REJECT)"* ]]
}

@test "3.5.3.2.4 Asegurar que existan reglas de firewall iptables para todos los puertos abiertos (Automatizado)" {
    skip "Esta auditoría debe hacerse manualmente"
}

## 3.5.3.3 Configure ip6tables IPv6

@test "3.5.3.3.1 Asegurar que el tráfico de loopback de ip6tables esté configurado (Automatizado)" {
    run check_ip_v6
    [ "$status" -eq 0 ]
    if [[ "$output" != *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        skip "*** IPv6 no está habilitado en el sistema ***"
    fi

    run bash -c "ip6tables -L INPUT -v -n"
    [ "$status" -eq 0 ]
    [[ "$output" = *"ACEPTAR"*"todo"*"lo"*"*"*"::/0"*"::/0"* ]]
    [[ "$output" = *"DEJAR"*"todo"*"*"*"*"*"::1"*"::/0"* ]]
    run bash -c "ip6tables -L OUTPUT -v -n"
    [ "$status" -eq 0 ]
    [[ "$output" = *"ACEPTAR"*"todo"*"*"*"lo"*"::/0"*"::/0"* ]]
}

@test "3.5.3.3.2 Asegurar que las conexiones salientes y establecidas de ip6tables estén configuradas (Manual)" {
    run check_ip_v6
    [ "$status" -eq 0 ]
    if [[ "$output" != *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        skip "*** IPv6 no está habilitado en el sistema ***"
    fi
    skip "Esta auditoría debe hacerse manualmente"
}

@test "3.5.3.3.3 Asegurar la política de denegación predeterminada de ip6tables (Automatizado)" {
    run check_ip_v6
    [ "$status" -eq 0 ]
    if [[ "$output" != *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        skip "*** IPv6 no está habilitado en el sistema ***"
    fi

    run bash -c "ip6tables -L"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Cadena INPUT (política DROP)"* || "$output" == *"Cadena INPUT (política REJECT)"* ]]
    [[ "$output" == *"Cadena FORWARD (política DROP)"* || "$output" == *"Cadena FORWARD (política REJECT)"* ]]
    [[ "$output" == *"Cadena OUTPUT (política DROP)"* || "$output" == *"Cadena OUTPUT (política REJECT)"* ]]
}

@test "3.5.3.3.4 Asegurar que existan reglas de firewall ip6tables para todos los puertos abiertos (Manual)" {
    run check_ip_v6
    [ "$status" -eq 0 ]
    if [[ "$output" != *"*** IPv6 está habilitado en el sistema ***"* ]]; then
        skip "*** IPv6 no está habilitado en el sistema ***"
    fi
    skip "Esta auditoría debe hacerse manualmente"
}
