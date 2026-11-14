#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Ejecuta este script como root: sudo bash scripts/setup-linux.sh" >&2
    exit 1
fi

for user in usuari1 usuari2; do
    if ! id "${user}" &>/dev/null; then
        useradd --create-home --shell /bin/bash "${user}"
    fi
done

getent group projecte >/dev/null || groupadd projecte
usermod --append --groups projecte usuari1
usermod --append --groups projecte usuari2

install -d --owner=root --group=projecte --mode=2770 /opt/projecte

if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install --yes auditd
elif command -v dnf >/dev/null 2>&1; then
    dnf install --assumeyes audit
else
    echo "No se reconoce apt-get ni dnf; instala auditd manualmente." >&2
    exit 1
fi

install -m 0640 config/audit-projecte.rules /etc/audit/rules.d/projecte.rules
systemctl enable --now auditd
augenrules --load

echo "Laboratorio preparado. Define contraseñas de prueba con: passwd usuari1 y passwd usuari2"
