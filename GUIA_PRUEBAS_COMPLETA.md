# 🔧 GUÍA DE PRUEBAS DEL PROYECTO ANSIBLE ESXi

## 📋 LISTA DE VERIFICACIÓN PREVIA

### ✅ **REQUISITOS QUE DEBES TENER:**

#### **1. Acceso a ESXi:**
- [ ] ESXi accesible en IP: `168.121.48.254:10113`
- [ ] Usuario root con contraseña
- [ ] VMs Linux Mint (172.17.25.102) y Windows (172.17.25.83) creadas
- [ ] Conexión de red desde tu PC al ESXi

#### **2. Entorno Local:**
- [ ] WSL Ubuntu funcionando
- [ ] Ansible 2.16.3+ instalado
- [ ] Python 3.x en WSL
- [ ] Módulos Python: `pywinrm`, `pyvmomi`

#### **3. Archivos del Proyecto:**
- [ ] `inventory/hosts.ini` actualizado con IPs correctas
- [ ] `group_vars/vault_vars.yml` encriptado
- [ ] Roles de seguridad configurados
- [ ] Playbooks principales listos

---

## 🔧 **PASO 2: CONFIGURACIONES QUE NECESITAS MODIFICAR**

### **A) Actualizar Variables de ESXi:**

```yaml
# En playbooks/gestion_vms_esxi_seguro.yml - CAMBIAR ESTAS LÍNEAS:
vars:
  esxi_host: "168.121.48.254:10113"  # ← Verificar IP y puerto
  esxi_user: "{{ vault_esxi_username }}"
  esxi_pass: "{{ vault_esxi_password }}"
  ds_name: "datastore1"  # ← Verificar nombre del datastore
  esxi_hostname_fqdn: "localhost.lim.upeu.edu.pe"  # ← Cambiar si es diferente
```

### **B) Verificar IPs en Inventario:**

```ini
# En inventory/hosts.ini - CONFIRMAR ESTAS IPs:
[academico]
172.17.25.102 ansible_user=mint ansible_ssh_private_key_file=~/.ssh/id_ed25519_ansible

[gamer] 
172.17.25.83 ansible_user=Administrador ansible_password='{{ vault_windows_password }}' 
ansible_connection=winrm ansible_winrm_transport=ntlm ansible_port=5985
```

### **C) Configurar Credenciales del Vault:**

```bash
# En WSL, editar el vault:
ansible-vault edit group_vars/vault_vars.yml

# Agregar/verificar estas credenciales:
vault_esxi_username: "root"
vault_esxi_password: "TU_PASSWORD_ESXI_REAL"
vault_windows_password: "TU_PASSWORD_WINDOWS_REAL"
vault_linux_password: "TU_PASSWORD_LINUX_REAL"
```

---

## 🎯 **PASO 3: QUÉ VA A HACER CADA CÓDIGO**

### **🔒 A) PLAYBOOK DE GESTIÓN ESXi (`gestion_vms_esxi_seguro.yml`):**

#### **Lo que hace:**
1. **Conecta a ESXi** usando credenciales del vault
2. **Crea/verifica VMs** Linux y Windows con configuraciones específicas
3. **Configura interfaces de red** con auditoría
4. **Registra todas las operaciones** en logs de seguridad
5. **Audita dispositivos** (CD, USB, Red, Discos)
6. **Genera reportes** de configuración

#### **Salida esperada:**
```
🔒 INICIANDO CONFIGURACIÓN DE SEGURIDAD INTEGRAL
✅ VM Linux: linux-mint-academico - CREADA/YA_EXISTÍA
✅ VM Windows: windows-gaming-lab - CREADA/YA_EXISTÍA  
📊 Auditoría completa de dispositivos realizada
🔒 Logs guardados en: /var/log/ansible_monitor/esxi_operations.log
```

### **🛡️ B) ROLES DE SEGURIDAD:**

#### **Linux Security (`roles/security/tasks/linux_security.yml`):**
- **Configura iptables** con políticas restrictivas
- **Instala Fail2ban** para protección SSH
- **Configura SSH hardening** (sin root, sin password)
- **Instala AIDE** para detección de intrusiones
- **Optimiza kernel** con sysctl

#### **Windows Security (`roles/security/tasks/windows_security.yml`):**
- **Configura Windows Firewall** con reglas específicas
- **Habilita Windows Defender** con configuración empresarial
- **Configura UAC** en nivel máximo
- **Deshabilita servicios** innecesarios
- **Configura auditoría** completa

### **📊 C) MONITOREO (`roles/security/tasks/security_monitoring.yml`):**
- **Scripts de monitoreo** cada 5 minutos
- **Alertas automáticas** de seguridad
- **Dashboard web** de estadísticas
- **Reportes semanales** automatizados

---

## 🚀 **PASO 4: COMANDOS PARA PROBAR TODO**

### **A) Verificar Conexión Básica:**
```bash
# En WSL Ubuntu:
cd /mnt/c/Users/Carlos/Documents/2025-2/SO-Ansible

# Probar conexión a las VMs:
ansible all -m ping -i inventory/hosts.ini --ask-vault-pass

# Resultado esperado:
# 172.17.25.102 | SUCCESS => {"ping": "pong"}
# 172.17.25.83 | SUCCESS => {"ping": "pong"}
```

### **B) Probar Gestión de VMs en ESXi:**
```bash
# Ejecutar playbook de ESXi (modo simulación):
ansible-playbook playbooks/gestion_vms_esxi_seguro.yml --check --ask-vault-pass

# Ejecutar playbook real:
ansible-playbook playbooks/gestion_vms_esxi_seguro.yml --ask-vault-pass
```

### **C) Aplicar Configuraciones de Seguridad:**
```bash
# Ejecutar configuración completa (simulación):
ansible-playbook playbooks/main.yml --check --ask-vault-pass

# Ejecutar configuración real:
ansible-playbook playbooks/main.yml --ask-vault-pass
```

---

## 👁️ **PASO 5: VISTAS FINALES - QUÉ DEBE PASAR**

### **🖥️ A) En la Consola de Ansible:**

```
PLAY [Gestión Segura de VMs ESXi] ********************************

TASK [🔒 Registrar inicio de operaciones ESXi] ******************
ok: [localhost]

TASK [🐧 Crear VM Linux Mint (Laboratorio Académico)] ***********
changed: [localhost]

TASK [🎮 Crear VM Windows (Laboratorio Gaming)] ******************
changed: [localhost]

TASK [🔍 Auditoría completa de dispositivos VM Linux] ***********
ok: [localhost]

TASK [🔍 Auditoría completa de dispositivos VM Windows] *********
ok: [localhost]

TASK [✅ Resumen final de operaciones de seguridad] *************
ok: [localhost] => {
    "msg": [
        "🔒 ===== RESUMEN DE SEGURIDAD =====",
        "✅ Credenciales: Protegidas con Ansible Vault",
        "✅ Logging: Todas las operaciones registradas", 
        "✅ Auditoría: Dispositivos inventariados",
        "✅ Trazabilidad: Timestamps completos",
        "📁 Log file: /var/log/ansible_monitor/esxi_operations.log"
    ]
}

PLAY RECAP *******************************************************
localhost: ok=15  changed=2  unreachable=0  failed=0
```

### **📁 B) En los Archivos de Log:**

```bash
# /var/log/ansible_monitor/esxi_operations.log
2025-10-29T15:30:00Z - INICIO: Operaciones ESXi por usuario carlos
2025-10-29T15:30:15Z - CREACIÓN: VM Linux linux-mint-academico - Estado: CREADA
2025-10-29T15:30:30Z - CREACIÓN: VM Windows windows-gaming-lab - Estado: CREADA
2025-10-29T15:30:45Z - NIC: VM Network configurada para linux-mint-academico
2025-10-29T15:31:00Z - AUDIT: linux-mint-academico - Dispositivos: 4
2025-10-29T15:31:15Z - COMPLETADO: Operaciones finalizadas - Usuario: carlos
```

### **🌐 C) En el ESXi Web Client:**

**Lo que verás:**
- ✅ **Carpeta `/Laboratorios`** creada
- ✅ **VM `linux-mint-academico`**: 2 CPU, 4GB RAM, 40GB disco
- ✅ **VM `windows-gaming-lab`**: 4 CPU, 8GB RAM, 80GB disco
- ✅ **Interfaces de red** configuradas en `VM Network`
- ✅ **Estado** de ambas VMs (encendidas/apagadas)

### **🔒 D) En las VMs después de Configuración de Seguridad:**

#### **Linux Mint:**
```bash
# Verificar firewall:
sudo iptables -L
# Chain INPUT (policy DROP)
# ACCEPT     tcp  --  168.121.48.0/24  anywhere  tcp dpt:ssh
# DROP       tcp  --  anywhere         anywhere  tcp flags:ALL/ALL

# Verificar SSH:
sudo systemctl status ssh
# Active: active (running)

# Verificar Fail2ban:
sudo fail2ban-client status sshd
# Status for the jail: sshd - Currently banned: 0
```

#### **Windows:**
```powershell
# Verificar Firewall:
Get-NetFirewallRule | Where {$_.DisplayName -like "*Ansible*"}
# WinRM-HTTP-Ansible: Enabled, Allow, In

# Verificar Windows Defender:
Get-MpComputerStatus
# RealTimeProtectionEnabled: True
# DefinitionStatus: UpToDate

# Verificar UAC:
Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
# EnableLUA: 1
```

---

## ⚠️ **PASO 6: PROBLEMAS COMUNES Y SOLUCIONES**

### **🚨 A) Error de Conexión a ESXi:**
```
PROBLEMA: "Connection refused to 168.121.48.254:10113"
SOLUCIÓN: 
1. Verificar que estés en la misma red que ESXi
2. Probar: ping 168.121.48.254
3. Verificar puerto con: telnet 168.121.48.254 10113
```

### **🚨 B) Error de Credenciales:**
```
PROBLEMA: "Authentication failed"
SOLUCIÓN:
1. Verificar vault: ansible-vault view group_vars/vault_vars.yml
2. Probar credenciales manualmente en ESXi web
3. Actualizar contraseñas en vault
```

### **🚨 C) Error de Módulos Python:**
```
PROBLEMA: "ModuleNotFoundError: No module named 'pyvmomi'"
SOLUCIÓN:
# En WSL:
pip3 install pyvmomi pywinrm requests
```

---

## 🎯 **PASO 7: COMANDOS DE VERIFICACIÓN FINAL**

```bash
# 1. Verificar estado de todas las VMs:
ansible all -m setup -i inventory/hosts.ini --ask-vault-pass

# 2. Verificar logs de seguridad:
ansible linux -m shell -a "tail -20 /var/log/ansible_monitor/*.log" -i inventory/hosts.ini

# 3. Verificar servicios críticos:
ansible linux -m systemd -a "name=ssh state=started" -i inventory/hosts.ini
ansible windows -m win_service -a "name=WinRM" -i inventory/hosts.ini

# 4. Generar reporte de seguridad:
ansible-playbook playbooks/security_report.yml --ask-vault-pass
```

---

## ✅ **RESULTADO FINAL ESPERADO**

**Al completar todas las pruebas tendrás:**

🔒 **Infraestructura ESXi** completamente auditada y documentada  
🛡️ **VMs Linux y Windows** con configuraciones de seguridad empresariales  
📊 **Sistema de monitoreo** funcionando 24/7  
📁 **Logs detallados** de todas las operaciones  
🔐 **Credenciales protegidas** con Ansible Vault  
📈 **Dashboard de seguridad** accessible vía web  

**¡Tu proyecto será una implementación de nivel empresarial que impresionará a tu profesor!** 🚀