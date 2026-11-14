# System Security Hardening Labs

Documentation of the **"Security Hardening Plans, Policies and Standards"** activity, organized by operating system and working environment.

## What Does This Lab Cover?

This lab applies security policies to Windows and Linux systems to manage users, passwords, permissions, shared resources and auditing.

The main security controls include:

- Creating users and groups.
- Enforcing strong passwords, expiration policies and password history.
- Restricting access to a directory exclusively to its designated group.
- Recording access and changes through auditing.
- Assessing system security using best-practice tools.

## Environments Used

The entire lab is not performed on a single machine:

| Lab | System | Purpose |
|---|---|---|
| Main Linux environment | **AlmaLinux Minimal** | User and group management, password policies, `/opt/projecte` and `auditd` |
| Linux auditing | **Debian 12** | Lynis, hardening assessment and UFW firewall |
| Windows | **Windows 10/11 or Windows Server** | PowerShell, local policies, NTFS permissions and auditing |

Evidence is organized separately according to the environment and operating system.

## Repository Structure

```text
.
├── README.md
├── linux/
│   ├── README.md                  # AlmaLinux Minimal and Debian 12
│   └── evidencias/                # Linux evidence
├── windows/
│   ├── README.md                  # Windows overview and screenshots
│   ├── lab.md                     # Windows technical procedure
│   └── evidencias/                # Windows evidence
```

## Documentation

- [Linux](linux/README.md): AlmaLinux Minimal and Debian 12.
- [Windows](windows/README.md): Work overview and screenshots.
- [Windows Procedure](windows/lab.md): Technical configuration of the environment.