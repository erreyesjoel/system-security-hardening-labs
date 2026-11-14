# Linux Lab: AlmaLinux Minimal and Debian 12

## 1. Scenario

This lab covers two different Linux environments:

- **AlmaLinux Minimal** is the main environment used for user and group management, password policies and file permissions.
- **Debian 12** is used as the security auditing environment to run Lynis, configure `auditd` and document hardening improvements, including UFW firewall configuration.

AlmaLinux and Debian are documented as independent environments.

## 2. Scope

| Item | Value |
|---|---|
| Main server | AlmaLinux Minimal (VM) |
| Auditing environment | Debian 12 (VM) |
| Authorized users | `usuari1`, `usuari2` |
| Group | `projecte` |
| Protected resource | `/opt/projecte` |
| Auditing | `auditd`, key `projecte_access` |

## 3. AlmaLinux Minimal: Server Setup

Before getting started, identify the operating system and check the current system information:

```bash
cat /etc/os-release
uname -a
id
```

## 4. Password Policies on AlmaLinux

Configure and document the following settings:

- Minimum password length: 10 characters.
- Maximum password age: 90 days.
- Password history: prevent reuse of the last 5 passwords.

Check the password aging settings with:

```bash
sudo chage -l usuari1
sudo chage -l usuari2
```

The password history policy is configured using the PAM module available in the distribution. Before editing PAM configuration files, create a backup and keep an administrative session open. Afterwards, verify the behavior by changing the password of a test user. Never publish passwords.

Password history is configured through PAM in `/etc/pam.d/system-auth` and `/etc/pam.d/password-auth`, using `pam_pwhistory.so` with `remember=5`.

Back up these files before editing them and keep an administrative session open. Testing should be performed as a regular user, not only as `root`, since restrictions may behave differently for administrators.

## 5. User Management, Groups and Permissions on AlmaLinux

Check group membership:

```bash
id usuari1
id usuari2
getent group projecte
```

Positive test, using an authorized user:

```bash
su - usuari1
cd /opt/projecte
echo "lab evidence" > prueba.txt
cat prueba.txt
exit
```

Negative test, using a user who does not belong to the `projecte` group:

```bash
su - usuario-no-autorizado
cd /opt/projecte
```

The second command should return `Permission denied`. Do not add the test user to `sudo`, as this would test administrative privileges rather than group-based access control.

## 6. Security Auditing with auditd on Debian 12

On the Debian 12 machine, use `auditd` to monitor and review system activity.

Check whether the audit service is running:

```bash
sudo systemctl status auditd
```

Check the loaded audit rules:

```bash
sudo auditctl -l
```

Generate an audit event by accessing the monitored directory and creating a file. Then search for the relevant audit key:

```bash
sudo ausearch -k projecte_access -i
```

The output should allow you to identify at least the user, operation, path and timestamp.

## 7. Debian 12: Lynis and Firewall

On the Debian 12 machine, assess the system's security hardening status using Lynis:

```bash
sudo apt update
sudo apt install lynis -y
sudo lynis audit system
```

The report includes the `hardening index`, the number of tests performed, plugins and corrective recommendations.

As an additional step, configure UFW and check its status:

```bash
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
sudo ufw status verbose
```

If the machine does not use SSH, do not open the port unnecessarily. On a remote VM, configure the SSH rule first to avoid losing the connection.

## 8. Verification and Analysis

Record each control as `PASS`, `FAIL` or `N/A`, explain the reason and propose a corrective action.

To perform a before-and-after comparison, run Lynis and keep only the summary, hardening index and relevant recommendations.

```bash
sudo lynis audit system
```