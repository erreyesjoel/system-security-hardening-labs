#!/usr/bin/env bash
set -Eeuo pipefail

pass=0
fail=0

check() {
    local description="$1"
    shift
    if "$@"; then
        printf 'PASS: %s\n' "${description}"
        pass=$((pass + 1))
    else
        printf 'FAIL: %s\n' "${description}"
        fail=$((fail + 1))
    fi
}

check "existe usuari1" id usuari1
check "existe usuari2" id usuari2
check "usuari1 pertenece a projecte" bash -c 'id -nG usuari1 | grep -qw projecte'
check "usuari2 pertenece a projecte" bash -c 'id -nG usuari2 | grep -qw projecte'
check "existe /opt/projecte" test -d /opt/projecte
check "grupo propietario correcto" bash -c '[[ "$(stat -c "%G" /opt/projecte)" == "projecte" ]]'
check "permisos sin acceso para otros" bash -c '[[ "$(stat -c "%a" /opt/projecte)" == "2770" ]]'
check "regla de auditd cargada" bash -c 'auditctl -l | grep -Fq "projecte_access"'
check "auditd activo" systemctl is-active --quiet auditd

printf '\nResultado: %d PASS, %d FAIL\n' "${pass}" "${fail}"
(( fail == 0 ))
