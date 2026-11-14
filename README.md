# System Security Hardening Labs

Documentación de la actividad **“Plans, polítiques i estàndards de
securització”**, organizada por sistema operativo y entorno de trabajo.

## ¿En qué consiste la práctica?

La práctica aplica políticas de seguridad a sistemas Windows y Linux para
gestionar usuarios, contraseñas, permisos, recursos compartidos y auditoría.

Los controles principales son:

- crear usuarios y grupos de trabajo;
- aplicar contraseñas robustas, caducidad e historial;
- limitar el acceso a un directorio únicamente a su grupo;
- registrar accesos y cambios mediante auditoría;
- revisar el sistema con herramientas de buenas prácticas.

## Entornos utilizados

La práctica no se ejecuta toda en una única máquina:

| Laboratorio | Sistema | Finalidad |
|---|---|---|
| Linux principal | **AlmaLinux Minimal** | Usuarios, grupo, contraseñas, `/opt/projecte` y `auditd` |
| Auditoría Linux | **Debian 12** | Lynis, revisión de hardening y firewall UFW |
| Windows | **Windows 10/11 o Windows Server** | PowerShell, políticas locales, permisos NTFS y auditoría |

Las evidencias se mantienen separadas por entorno y sistema operativo.

## Estructura del repositorio

```text
.
├── README.md
├── linux/
│   ├── README.md                  # AlmaLinux Minimal y Debian 12
│   └── evidencias/                # Evidencias Linux
├── windows/
│   ├── README.md                  # Resumen Windows y capturas
│   ├── lab.md                     # Procedimiento técnico Windows
│   └── evidencias/                # Evidencias Windows
├── config/
│   └── audit-projecte.rules       # Regla persistente de auditd
└── scripts/
    ├── setup-linux.sh             # Preparación del laboratorio Linux
    └── verify-linux.sh            # Comprobaciones Linux
```

## Documentación

- [Linux](linux/README.md): AlmaLinux Minimal y Debian 12.
- [Windows](windows/README.md): resumen del trabajo y capturas.
- [Procedimiento Windows](windows/lab.md): configuración técnica del entorno.
