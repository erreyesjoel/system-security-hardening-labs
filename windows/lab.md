# Windows Lab: Security Policies, Permissions and Auditing

This lab is independent of the Linux lab. It can be performed on Windows 10, Windows 11 or Windows Server running inside a virtual machine.

## 1. Configuration

Create two local user accounts and a `Projecte` group, apply a password policy, protect `C:\Projecte` using NTFS permissions and audit access to that folder through Windows Event Viewer.

## 2. Preparation

Open PowerShell as Administrator and check the system information:

```powershell
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsBuildNumber
whoami
```

## 3. Users and Groups

```powershell
$Password = Read-Host "Temporary password" -AsSecureString
New-LocalUser -Name "usuari1" -Password $Password -Description "Lab user"
New-LocalUser -Name "usuari2" -Password $Password -Description "Lab user"
New-LocalGroup -Name "Projecte" -Description "Project group"
Add-LocalGroupMember -Group "Projecte" -Member "usuari1", "usuari2"
```

If the objects already exist, do not create them again. Verify their existence instead:

```powershell
Get-LocalUser -Name usuari1, usuari2
Get-LocalGroup -Name Projecte
Get-LocalGroupMember -Group Projecte
```

## 4. Password Policy

Open `secpol.msc` and navigate to:

`Security Settings > Account Policies > Password Policy`

Configure the following settings:

| Policy | Value |
|---|---:|
| Minimum password length | 10 characters |
| Password must meet complexity requirements | Enabled |
| Maximum password age | 90 days |
| Enforce password history | 5 passwords remembered |

Password complexity must require uppercase letters, lowercase letters, numbers and symbols, and must prevent passwords from containing the user's account name.

Check password expiration settings using PowerShell:

```powershell
net user usuari1
```

Validate the policy using a password that is too short or does not meet complexity requirements, and document the rejection without displaying the password used. To validate password history, change a regular user's password five times and then attempt to reuse a previous password through the password change interface. Do not rely exclusively on an administrative password change, as administrators may be exempt from certain restrictions.

## 5. NTFS Permissions for `C:\Projecte`

Create the folder and configure the group-based access permissions:

```powershell
New-Item -ItemType Directory -Path "C:\Projecte" -Force
icacls "C:\Projecte" /inheritance:r
icacls "C:\Projecte" /grant:r "Projecte:(OI)(CI)M" "Administrators:(OI)(CI)F" "SYSTEM:(OI)(CI)F"
icacls "C:\Projecte"
```

`(OI)(CI)` propagates permissions to files and subfolders. `M` grants Modify permissions to the project group, while administrators and the system retain Full Control to manage the machine.

Test access by signing in as `usuari1`:

```powershell
whoami
Set-Content -Path "C:\Projecte\prueba.txt" -Value "lab evidence"
Get-Content "C:\Projecte\prueba.txt"
```

Then test with a user who does not belong to `Projecte`. Access should be denied. Do not add this user to an administrative group, as this would invalidate the NTFS permissions test.

## 6. Access Auditing

### 6.1 Enable the Global Audit Policy

Open `secpol.msc` and navigate to:

`Local Policies > Audit Policy > Audit object access`

Enable both Success and Failure auditing. This policy allows Windows to generate events, but you must still specify which folder should be audited.

### 6.2 Audit `C:\Projecte`

Using an administrative account:

1. Open the Properties of `C:\Projecte`.
2. Navigate to **Security > Advanced > Auditing**.
3. Add the `Projecte` group.
4. Apply the auditing settings to this folder, subfolders and files.
5. Select relevant Success and Failure actions, such as reading, writing, creating, deleting and changing permissions.

Generate an access event by creating or modifying `prueba.txt`. Then open `eventvwr.msc`, navigate to **Windows Logs > Security** and filter for events related to object access. Document the user, timestamp, action and audited object.

## 7. Evidence

Screenshots and an overview of the Windows lab are available in [`windows/README.md`](README.md).