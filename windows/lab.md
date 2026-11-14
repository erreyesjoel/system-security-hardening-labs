# Laboratorio Windows: políticas, permisos y auditoría

Este laboratorio es independiente del laboratorio Linux. Se puede realizar en
Windows 10, Windows 11 o Windows Server dentro de una máquina virtual.

## 1. Configuración

Crear dos usuarios locales y un grupo `Projecte`, aplicar una política de
contraseñas, proteger `C:\Projecte` mediante permisos NTFS y registrar el acceso
a esa carpeta en el visor de eventos.

## 2. Preparación

Abre PowerShell como administrador y comprueba el sistema:

```powershell
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsBuildNumber
whoami
```

## 3. Usuarios y grupo

```powershell
$Password = Read-Host "Contraseña temporal" -AsSecureString
New-LocalUser -Name "usuari1" -Password $Password -Description "Usuario de laboratorio"
New-LocalUser -Name "usuari2" -Password $Password -Description "Usuario de laboratorio"
New-LocalGroup -Name "Projecte" -Description "Grupo del proyecto"
Add-LocalGroupMember -Group "Projecte" -Member "usuari1", "usuari2"
```

Si los objetos ya existen, no los vuelvas a crear: compruébalos:

```powershell
Get-LocalUser -Name usuari1, usuari2
Get-LocalGroup -Name Projecte
Get-LocalGroupMember -Group Projecte
```

## 4. Política de contraseñas

Abre `secpol.msc` y navega a:

`Configuración de seguridad > Directivas de cuenta > Directiva de contraseñas`

Configura:

| Política | Valor |
|---|---:|
| Longitud mínima | 10 caracteres |
| La contraseña debe cumplir requisitos de complejidad | Habilitada |
| Vigencia máxima | 90 días |
| Historial | 5 contraseñas recordadas |

La complejidad debe exigir mayúsculas, minúsculas, números y símbolos, y no
permitir que la contraseña contenga el nombre del usuario.

Comprueba la vigencia desde PowerShell:

```powershell
net user usuari1
```

Valida la política con una contraseña demasiado corta o sin complejidad y
documenta el rechazo sin mostrar el valor utilizado. Para validar el historial,
cambia la contraseña de un usuario normal cinco veces y prueba reutilizar una
anterior desde la interfaz de cambio de contraseña. No uses únicamente un cambio
administrativo: el administrador puede estar exento de algunas restricciones.

## 5. Permisos NTFS de `C:\Projecte`

Crea la carpeta y configura el grupo como propietario funcional:

```powershell
New-Item -ItemType Directory -Path "C:\Projecte" -Force
icacls "C:\Projecte" /inheritance:r
icacls "C:\Projecte" /grant:r "Projecte:(OI)(CI)M" "Administrators:(OI)(CI)F" "SYSTEM:(OI)(CI)F"
icacls "C:\Projecte"
```

`(OI)(CI)` propaga los permisos a archivos y subcarpetas. `M` concede
modificación al grupo del proyecto, mientras que los administradores y el
sistema conservan control total para administrar la máquina.

Prueba el acceso iniciando sesión como `usuari1`:

```powershell
whoami
Set-Content -Path "C:\Projecte\prueba.txt" -Value "evidencia de laboratorio"
Get-Content "C:\Projecte\prueba.txt"
```

Prueba después con un usuario que no pertenezca a `Projecte`. El acceso debe
fallar. No añadas ese usuario a un grupo administrativo, porque invalidaría la
prueba de permisos NTFS.

## 6. Auditoría de accesos

### 6.1 Habilitar la política global

Abre `secpol.msc` y navega a:

`Directivas locales > Directiva de auditoría > Auditar el acceso a objetos`

Activa auditoría de éxito y error. Esta política permite que Windows genere
eventos, pero todavía hay que indicar qué carpeta se audita.

### 6.2 Auditar `C:\Projecte`

Desde una cuenta administrativa:

1. Propiedades de `C:\Projecte`.
2. **Seguridad > Opciones avanzadas > Auditoría**.
3. Añade el grupo `Projecte`.
4. Aplica a esta carpeta, subcarpetas y archivos.
5. Selecciona acciones de éxito y error relevantes, como lectura, escritura,
   creación, eliminación y cambio de permisos.

Genera un acceso creando o modificando `prueba.txt`. Después abre
`eventvwr.msc`, entra en **Registros de Windows > Seguridad** y filtra los
eventos relacionados con acceso a objetos. Documenta el usuario, la hora, la
acción y el objeto auditado.

## 7. Evidencias

Las capturas y el resumen del trabajo Windows están en
[`windows/README.md`](README.md).
