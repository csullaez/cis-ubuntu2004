#!/usr/bin/env bats

@test "2.3 Asegurar que los servicios no esenciales estén eliminados o enmascarados (Manual)" {
    skip "Esta auditoría debe realizarse manualmente"

    # Ejecute el siguiente comando de auditoría:
    # lsof -i -P -n | grep -v "(ESTABLISHED)"
    # Revise la salida para asegurarse de que todos los servicios enumerados sean necesarios en el sistema.
    # Si un servicio enumerado no es necesario, elimine el paquete que contiene el servicio. Si se requiere
    # el paquete que contiene un servicio no esencial, detenga y enmascare el servicio no esencial.
}
