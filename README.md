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
├── config/
│   └── audit-projecte.rules       # Regla persistente de auditd
├── docs/
│   ├── lab-linux.md               # AlmaLinux Minimal y Debian 12
│   ├── lab-windows.md             # Laboratorio Windows independiente
│   ├── windows/
│   │   └── README.md               # Resumen y capturas Windows
│   └── evidencias/
│       ├── README.md               # Índice y explicación de capturas
│       ├── windows/                # Capturas específicas de Windows
│       └── *.png                   # Evidencias aportadas
└── scripts/
    ├── setup-linux.sh             # Preparación del laboratorio Linux
    └── verify-linux.sh            # Comprobaciones Linux
```

## Documentación

- [Laboratorio Linux](docs/lab-linux.md): AlmaLinux Minimal y Debian 12.
- [Laboratorio Windows](docs/lab-windows.md): configuración técnica del entorno.
- [README de Windows](docs/windows/README.md): resumen del trabajo y capturas.
- [Evidencias Linux](docs/evidencias/README.md): capturas integradas del entorno Linux.
