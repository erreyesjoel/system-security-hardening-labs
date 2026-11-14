# Laboratorio Linux: AlmaLinux Minimal y Debian 12

## 1. Escenario

Este laboratorio reúne dos usos distintos de Linux:

- **AlmaLinux Minimal** es el entorno principal de la actividad. Aquí se
  configuran usuarios, grupo, contraseñas, permisos y `auditd`.
- **Debian 12** se utiliza como entorno de auditoría para ejecutar Lynis y
  documentar mejoras de hardening, incluido el firewall UFW.

AlmaLinux y Debian se documentan como entornos independientes.

## 2. Alcance

| Elemento | Valor |
|---|---|
| Servidor principal | AlmaLinux Minimal (VM) |
| Auditoría adicional | Debian 12 (VM) |
| Usuarios autorizados | `usuari1`, `usuari2` |
| Grupo | `projecte` |
| Recurso protegido | `/opt/projecte` |
| Auditoría | `auditd`, clave `projecte_access` |

## 3. AlmaLinux Minimal: preparación del servidor

Antes de empezar:

```bash
cat /etc/os-release
uname -a
id
```

En AlmaLinux, instala las herramientas necesarias y ejecuta:

```bash
sudo bash ../scripts/setup-linux.sh
```

El script crea los usuarios, el grupo, el directorio, instala `auditd` si está
disponible y carga la regla de auditoría de `../config/audit-projecte.rules`.

En una instalación Minimal puede ser necesario instalar previamente herramientas
como `sudo`, `passwd`, `audit` o un editor de texto. El nombre del paquete es
`audit` en AlmaLinux/RHEL, aunque el servicio se llama `auditd`.

## 4. Política de contraseñas en AlmaLinux

Configura y documenta estos valores:

- longitud mínima: 10 caracteres;
- caducidad máxima: 90 días;
- historial: no reutilizar las últimas 5 contraseñas.

Comprueba los valores de envejecimiento con:

```bash
sudo chage -l usuari1
sudo chage -l usuari2
```

La regla de historial se configura con el módulo PAM disponible en la
distribución. Antes de editar PAM, realiza una copia de seguridad y conserva una
sesión administrativa abierta. Comprueba después el comportamiento cambiando la contraseña de un usuario de
prueba; nunca publiques la contraseña.

El historial se configura mediante PAM en `/etc/pam.d/system-auth` y
`/etc/pam.d/password-auth`, usando `pam_pwhistory.so` con `remember=5`.
Haz una copia de seguridad antes de editar estos ficheros y conserva una sesión
de administración abierta. La prueba debe realizarse como usuario normal, no
solo mediante `root`, porque las restricciones pueden comportarse de forma
diferente para el administrador.

## 5. Usuarios, grupo y permisos en AlmaLinux

Comprueba la pertenencia:

```bash
id usuari1
id usuari2
getent group projecte
```

Prueba positiva, con un usuario autorizado:

```bash
su - usuari1
cd /opt/projecte
echo "evidencia de laboratorio" > prueba.txt
cat prueba.txt
exit
```

Prueba negativa, con un usuario que no pertenezca a `projecte`:

```bash
su - usuario-no-autorizado
cd /opt/projecte
```

El segundo comando debe terminar con `Permission denied`. No añadas el usuario
de prueba a `sudo`, porque eso probaría privilegios administrativos y no el
control del grupo.

## 6. Auditoría con auditd en AlmaLinux

Comprueba que la regla está cargada:

```bash
sudo auditctl -l
```

Genera un evento entrando en el directorio y creando un fichero. Después busca
la clave:

```bash
sudo ausearch -k projecte_access -i
```

El resultado debe permitir identificar al menos el usuario, la operación, la
ruta y la hora.

## 7. Debian 12: Lynis y firewall

En la máquina Debian 12, la segunda parte de la práctica comprueba el estado de
hardening con Lynis:

```bash
sudo apt update
sudo apt install lynis -y
sudo lynis audit system
```

El informe incluye el `hardening index`, el número de pruebas, los plugins y las
medidas correctoras aplicadas.

Como ampliación, configura UFW y comprueba su estado:

```bash
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
sudo ufw status verbose
```

Si la máquina no usa SSH, no abras el puerto innecesariamente. En una VM remota,
configura primero la regla de SSH para no perder la conexión.

## 8. Verificación y análisis

```bash
sudo bash ../scripts/verify-linux.sh
```

Anota cada control como `PASS`, `FAIL` o `N/A`, explica la causa y propone una
acción correctora. Para una comparación antes/después, ejecuta Lynis y conserva
solo el resumen, el índice y las recomendaciones relevantes:

```bash
sudo lynis audit system
```
