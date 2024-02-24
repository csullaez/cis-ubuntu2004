#!/usr/bin/env bats

@test "1.9 Asegurar que las actualizaciones, parches y software de seguridad adicional estén instalados (Manual)" {
    (apt -s upgrade | grep "^0 upgraded")
    (apt -s upgrade | grep -E "[[:space:]]0 newly installed")
    (apt -s upgrade | grep -E "[[:space:]]0 to remove")
    (apt -s upgrade | grep -E "[[:space:]]0 not upgraded")
}
