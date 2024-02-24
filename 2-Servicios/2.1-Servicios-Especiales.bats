#!/usr/bin/env bats

@test "2.1.1.1 Asegurar que se esté utilizando la sincronización horaria (Automatizado)" {
    run bash -c "systemctl is-enabled systemd-timesyncd || dpkg -s chrony || dpkg -s ntp"
    [[ "$status" -eq 0 ]]
}

@test "2.1.1.2 Asegurar que systemd-timesyncd esté configurado (Automatizado)" {
    run bash -c "dpkg -s ntp"
    [[ "${lines[0]}" == "dpkg-query: package 'ntp' is not installed and no information is available" ]]

    run bash -c "dpkg -s chrony"
    [[ "${lines[0]}" == "dpkg-query: package 'chrony' is not installed and no information is available" ]]

    run bash -c "systemctl is-enabled systemd-timesyncd.service"
    [[ "$output" = "enabled" ]]

    run bash -c "timedatectl status"
    [[ "${lines[4]}" == *"System clock synchronized: yes"* ]]
    [[ "${lines[5]}" == *"NTP service: active"* ]]
}

@test "2.1.1.3 Asegurar que chrony esté configurado (Automatizado)" {
    run bash -c "dpkg -s ntp | grep -E '(Status:|not installed)'"
    [[ "${lines[0]}" == *"dpkg-query: package 'ntp' is not installed and no information is available"* ]]

    run bash -c "systemctl is-enabled systemd-timesyncd"
    [[ "$output" == *"masked"* ]]

    run bash -c "grep -E \"^(server|pool)\" /etc/chrony/chrony.conf"
    [ "$status" -eq 0 ]
    [[ "$output" == "server "* || "$output" == "pool "* ]]

    run bash -c "ps -ef | grep chronyd"
    [ "$status" -eq 0 ]
    [[ "$output" == "_chrony "*" /usr/sbin/chronyd"* ]]
}

@test "2.1.1.4 Asegurar que ntp esté configurado (Automatizado)" {
    run bash -c "dpkg -s chrony"
    [[ "${lines[0]}" == "dpkg-query: package 'chrony' is not installed and no information is available" ]]

    run bash -c "systemctl is-enabled systemd-timesyncd.service"
    [[ "$output" = "masked" ]]

    run bash -c "grep \"^restrict\" /etc/ntp.conf"
    [ "$status" -eq 0 ]
    [[ "$output" == *"restrict -4 default "*"kod"* && "* ]]
    [[ "$output" == *"restrict -4 default "*"nomodify"* && "* ]]
    [[ "$output" == *"restrict -4 default "*"notrap"* && "* ]]
    [[ "$output" == *"restrict -4 default "*"nopeer"* && "* ]]
    [[ "$output" == *"restrict -4 default "*"noquery"* && "* ]]
    [[ "$output" == *"restrict -6 default "*"kod"* && "* ]]
    [[ "$output" == *"restrict -6 default "*"nomodify"* && "* ]]
    [[ "$output" == *"restrict -6 default "*"notrap"* && "* ]]
    [[ "$output" == *"restrict -6 default "*"nopeer"* && "* ]]
    [[ "$output" == *"restrict -6 default "*"noquery"* && "* ]]
    run bash -c "grep -E \"^(server|pool)\" /etc/ntp.conf"
    [ "$status" -eq 0 ]
    [[ "$output" == "server "* || "$output" == "pool "* ]]
    run bash -c "grep \"RUNASUSER=ntp\" /etc/init.d/ntp"
    [ "$status" -eq 0 ]
    [[ "$output" == "RUNASUSER=ntp" ]]
}

@test "2.1.2 Asegurar que el sistema X Window no esté instalado (Automatizado)" {
    run bash -c "dpkg -l xserver-xorg*"
    [ "$status" -eq 1 ]
    [[ "$output" == *"no packages found matching xserver-xorg*" ]]
}

@test "2.1.3 Asegurar que el servidor Avahi no esté instalado (Automatizado)" {
    run bash -c "dpkg -s avahi-daemon | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'avahi-daemon' is not installed and no information is available"* ]]
}

@test "2.1.4 Asegurar que CUPS no esté instalado (Automatizado)" {
    run bash -c "dpkg -s cups | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'cups' is not installed and no information is available"* ]]
}

@test "2.1.5 Asegurar que el servidor DHCP no esté instalado (Automatizado)" {
    run bash -c "dpkg -s isc-dhcp-server | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'isc-dhcp-server' is not installed and no information is available"* ]]
}

@test "2.1.6 Asegurar que el servidor LDAP no esté instalado (Automatizado)" {
    run bash -c "dpkg -s slapd | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'slapd' is not installed and no information is available"* ]]
}

@test "2.1.7 Asegurar que NFS no esté instalado (Automatizado)" {
    run bash -c "dpkg -s nfs-kernel-server | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'nfs-kernel-server' is not installed and no information is available"* ]]
}

@test "2.1.8 Asegurar que el servidor DNS no esté instalado (Automatizado)" {
    run bash -c "dpkg -s bind9 | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'bind9' is not installed and no information is available"* ]]
}

@test "2.1.9 Asegurar que el servidor FTP no esté instalado (Automatizado)" {
    run bash -c "dpkg -s vsftpd | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'vsftpd' is not installed and no information is available"* ]]
}

@test "2.1.10 Asegurar que el servidor HTTP no esté instalado (Automatizado)" {
    run bash -c "dpkg -s apache2 | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'apache2' is not installed and no information is available"* ]]
}

@test "2.1.11 Asegurar que los servidores IMAP y POP3 no estén instalados (Automatizado)" {
    run bash -c "dpkg -s dovecot-imapd dovecot-pop3d | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'dovecot-imapd' is not installed and no information is available"* ]]
    [[ "$output" == *"dpkg-query: package 'dovecot-pop3d' is not installed and no information is available"* ]]
}

@test "2.1.12 Asegurar que Samba no esté instalado (Automatizado)" {
    run bash -c "dpkg -s samba | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'samba' is not installed and no information is available"* ]]
}

@test "2.1.13 Asegurar que el servidor HTTP Proxy no esté instalado (Automatizado)" {
    run bash -c "dpkg -s squid | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'squid' is not installed and no information is available"* ]]
}

@test "2.1.14 Asegurar que el servidor SNMP no esté instalado (Automatizado)" {
    run bash -c "dpkg -s snmpd | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'snmpd' is not installed and no information is available"* ]]
}

@test "2.1.15 Asegurar que el agente de transferencia de correo esté configurado solo para el modo local (Automatizado)" {
    run bash -c "ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s'"
    [[ "$status" -eq 1 ]]
    [[ "$output" == "" ]]
}

@test "2.1.16 Asegurar que el servicio rsync no esté instalado (Automatizado)" {
    run bash -c "dpkg -s rsync | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'rsync' is not installed and no information is available"* ]]
}

@test "2.1.17 Asegurar que el servidor NIS no esté instalado (Automatizado)" {
    run bash -c "dpkg -s nis | grep -E '(Status:|not installed)'"
    [[ "$output" == *"dpkg-query: package 'nis' is not installed and no information is available"* ]]
}
