# 📋 Guía de Instalación Manual de OS en VMs

## 🎯 Objetivo
Esta guía documenta los pasos manuales necesarios después de crear las VMs base con Ansible. Como explicó el **Ing. Paulo**, Ansible no debe automatizar la instalación de OS, sino configurar servicios post-instalación.

## 🏗️ Estado Actual del Proyecto

### ✅ Completado (Automatizado con Ansible):
- VMs base creadas en ESXi
- Configuración de hardware (CPU, RAM, disco)
- Configuración de red base

### ⏳ Pendiente (Manual - Esta guía):
- Instalación de sistemas operativos
- Configuración inicial de red
- Configuración de usuarios y SSH/WinRM
- Preparación para automatización Ansible

## 🔧 Pasos Manuales Requeridos

### 1. Acceder a ESXi Host Client
```
URL: https://168.121.48.254:10121
Usuario: root
Contraseña: qwe123$
```

### 2. Instalar Ubuntu Server en VM "Ubuntu-Academico"

**a) Preparar instalación:**
- Subir ISO Ubuntu 24.04 LTS al datastore si no está
- Montar ISO en la VM
- Encender VM y conectar por consola

**b) Configuración durante instalación:**
- Usuario: `ansible`
- Contraseña: `Upeu2025#`
- Habilitar OpenSSH server
- Red: Configurar IP estática o DHCP (anotar IP asignada)

**c) Post-instalación:**
```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Python (requerido por Ansible)
sudo apt install python3 python3-pip -y

# Configurar SSH para Ansible
sudo systemctl enable ssh
sudo systemctl start ssh

# Permitir sudo sin contraseña para ansible
echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible
```

### 3. Instalar Windows 11 Pro en VM "Windows-Gamer"

**a) Preparar instalación:**
- Subir ISO Windows 11 al datastore si no está
- Montar ISO en la VM
- Encender VM y seguir instalación

**b) Configuración durante instalación:**
- Usuario: `Administrador`
- Contraseña: `Upeu2025#`
- Red: Configurar IP estática o DHCP (anotar IP asignada)

**c) Post-instalación:**
```powershell
# Habilitar WinRM para Ansible
winrm quickconfig -y
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Configurar firewall
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow

# Habilitar ejecución de scripts
Set-ExecutionPolicy RemoteSigned -Force
```

### 4. Actualizar Inventario de Ansible

Editar `inventory/hosts.ini` con las IPs reales:

```ini
[academico]
192.168.1.100 ansible_user=ansible ansible_ssh_private_key_file=~/.ssh/id_ed25519_ansible

[gamer]  
192.168.1.101 ansible_user=Administrador ansible_password='Upeu2025#' ansible_connection=winrm ansible_winrm_transport=ntlm ansible_port=5985 ansible_winrm_server_cert_validation=ignore
```

### 5. Probar Conectividad

```bash
# Probar Ubuntu
ansible academico -m ping

# Probar Windows
ansible gamer -m win_ping

# Si todo funciona, ejecutar automatización
ansible-playbook playbooks/main.yml
```

## 🎯 Resultados Esperados

Después de completar esta guía manual:

✅ **VMs completamente funcionales**
✅ **Sistemas operativos instalados y configurados**
✅ **Conectividad SSH/WinRM establecida**  
✅ **Ansible puede conectarse y automatizar el resto**

## 🚀 Siguiente Fase: Automatización Ansible

Una vez completados los pasos manuales, Ansible automatizará:
- Instalación de software y servicios
- Configuración de aplicaciones
- Gestión de usuarios y permisos
- Políticas de seguridad
- Monitoreo y mantenimiento

---
**💡 Recordatorio del Ing. Paulo:** "Ansible sirve exactamente para automatizar configuraciones complejas, pero después de tener las VMs con OS instalado y configuración base."