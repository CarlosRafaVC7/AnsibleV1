# 🔐 ROLES DE SEGURIDAD PARA LABORATORIO

Este documento describe los dos roles de Ansible creados para la gestión de usuarios y seguridad del laboratorio.

## 📋 ÍNDICE

- [Rol usuarios_seguridad](#rol-usuarios_seguridad)
- [Rol seguridad_firewall](#rol-seguridad_firewall)
- [Uso de los roles](#uso-de-los-roles)
- [Variables de configuración](#variables-de-configuración)
- [Ejemplos de ejecución](#ejemplos-de-ejecución)

---

## 🔐 ROL: usuarios_seguridad

### Propósito
Gestiona la creación y configuración de usuarios, grupos y políticas de seguridad en sistemas Linux y Windows.

### Funcionalidades

#### 👥 Usuarios Creados
1. **labadmin**
   - Administrador principal del laboratorio
   - Privilegios sudo completos **sin contraseña**
   - Grupos: academic_admin, sudo, adm, systemd-journal
   - Contraseña desde Vault: `vault_labadmin_password`

2. **lab_student**
   - Estudiante principal del laboratorio
   - Privilegios sudo **limitados con contraseña**
   - Comandos permitidos: systemctl (Apache/MySQL), logs, herramientas básicas
   - Grupos: students, lab_developers
   - Contraseña desde Vault: `vault_student_password`

3. **practice_user**
   - Usuario para prácticas de servicios web
   - **Solo permisos de servicio web sin contraseña**
   - Comandos permitidos: Apache/Nginx start/stop/restart/status
   - Grupos: students, practice
   - Contraseña desde Vault: `vault_practice_password`

#### 🏢 Grupos Creados
- **students** (GID: 2000): Grupo de estudiantes del laboratorio
- **practice** (GID: 2001): Grupo para prácticas web controladas
- **academic_admin** (GID: 2002): Administradores académicos
- **lab_developers** (GID: 2003): Desarrolladores del laboratorio

#### 🔒 Políticas de Seguridad
- **Contraseñas**: Mínimo 8 caracteres, expiran en 90 días, complejidad obligatoria
- **Sudoers**: Configuración desde plantilla `sudoers_lab.j2`
- **Cuentas deshabilitadas**: root (SSH), guest
- **Auditoría**: Logging de actividades de usuario
- **Límites de sistema**: Control de recursos por grupo

### Archivos del Rol
```
roles/usuarios_seguridad/
├── tasks/
│   ├── main.yml              # Orquestador principal
│   ├── linux_usuarios.yml    # Configuración Linux
│   └── windows_usuarios.yml  # Configuración Windows
├── templates/
│   ├── sudoers_lab.j2        # Plantilla sudoers principal
│   ├── sudoers_individual.j2 # Plantilla sudoers individual
│   ├── pwquality.conf.j2     # Políticas de contraseñas Linux
│   ├── limits.conf.j2        # Límites de sistema
│   └── log_user_activity.sh.j2 # Script de auditoría
├── vars/
│   └── main.yml              # Variables del rol
└── handlers/
    └── main.yml              # Handlers de servicios
```

---

## 🔥 ROL: seguridad_firewall

### Propósito
Configura firewall, antivirus, protección SSH y red DHCPv6 en sistemas Linux y Windows.

### Funcionalidades

#### 🔥 Configuración de Firewall

##### Linux (UFW + iptables)
- **Política por defecto**: DENEGAR TODO excepto salida
- **Puertos permitidos**: 
  - SSH (22) - Solo desde 192.168.1.0/24
  - HTTP (80) y HTTPS (443) - Servicios web
  - DNS (53) y NTP (123) - Servicios básicos
- **Puertos bloqueados**: Telnet(23), FTP(21), SMB(445), RDP(3389), SNMP(161)
- **Protecciones avanzadas**: Anti NULL packets, anti XMAS, rate limiting SSH

##### Windows (Windows Defender Firewall)
- **Política por defecto**: BLOQUEAR conexiones entrantes
- **Puertos permitidos**:
  - WinRM (5985/5986) - Solo desde 192.168.1.0/24
  - HTTP (80) y HTTPS (443) - IIS
- **Puertos bloqueados**: Mismos que Linux + NetBIOS(139)
- **Logging**: Habilitado para auditoría

#### 🦠 Configuración de Antivirus

##### Linux (ClamAV)
- **Protección en tiempo real**: Demonio activo
- **Escaneo automático**: Nocturno a las 2:30 AM
- **Directorios escaneados**: /home, /opt, /tmp, /var/log
- **Actualizaciones**: Automáticas cada hora
- **Exclusiones**: /sys, /proc, /dev

##### Windows (Windows Defender)
- **Protección en tiempo real**: Habilitada
- **Cloud protection**: Habilitada con envío automático de muestras
- **Escaneo automático**: Nocturno a las 2:00 AM
- **Exclusiones**: Directorios temporales para rendimiento

#### 🛡️ Fail2ban (Linux)
- **Protección SSH**: Banea IPs tras 3 intentos fallidos
- **Tiempo de baneo**: 30 minutos
- **Ventana de detección**: 10 minutos
- **IPs ignoradas**: 127.0.0.1/8, 192.168.1.0/24
- **Protección web**: Apache/Nginx incluidos

#### 🌐 Red DHCPv6
- **IPv6**: DHCPv6 como principal
- **IPv4**: DHCP como fallback
- **DNS**: Híbrido IPv6/IPv4 (Google, Cloudflare)
- **Netplan**: Configuración automática en Linux
- **Windows**: PowerShell para configuración de adaptadores

### Archivos del Rol
```
roles/seguridad_firewall/
├── tasks/
│   ├── main.yml              # Orquestador principal
│   ├── linux_firewall.yml    # Firewall y antivirus Linux
│   ├── windows_firewall.yml  # Firewall y antivirus Windows
│   └── network_config.yml    # Configuración de red común
├── templates/
│   ├── jail.local.j2         # Configuración Fail2ban
│   ├── netplan_dhcpv6.yaml.j2 # Configuración Netplan
│   └── resolved.conf.j2      # Configuración DNS systemd
├── vars/
│   └── main.yml              # Variables del rol
└── handlers/
    └── main.yml              # Handlers de servicios
```

---

## 🚀 USO DE LOS ROLES

### Requisitos Previos
1. Ansible 2.16+ instalado
2. Acceso SSH (Linux) o WinRM (Windows)
3. Privilegios de administrador en hosts destino
4. Ansible Vault configurado para contraseñas

### Configuración de Vault
```bash
# Crear archivo de vault
ansible-vault create group_vars/vault_vars.yml

# Contenido del vault:
---
vault_admin_password: "SecureAdmin2024!"
vault_student_password: "Student2024!Lab" 
vault_practice_password: "Practice2024!Web"
```

### Playbook Principal
```yaml
---
- name: "Configurar usuarios y seguridad"
  hosts: all
  become: true
  
  roles:
    - usuarios_seguridad
    - seguridad_firewall
```

### Ejecución
```bash
# Ejecución completa
ansible-playbook -i inventory/hosts.ini playbooks/setup_usuarios_firewall.yml --ask-vault-pass

# Solo usuarios
ansible-playbook playbooks/setup_usuarios_firewall.yml --tags "usuarios" --ask-vault-pass

# Solo firewall
ansible-playbook playbooks/setup_usuarios_firewall.yml --tags "firewall" --ask-vault-pass

# Solo antivirus
ansible-playbook playbooks/setup_usuarios_firewall.yml --tags "antivirus" --ask-vault-pass
```

---

## ⚙️ VARIABLES DE CONFIGURACIÓN

### Variables de Usuarios
```yaml
# En group_vars/all.yml
lab_usuarios:
  - username: "labadmin"
    fullname: "Administrador del Laboratorio"
    groups: ["academic_admin", "sudo"]
    sudo_config: "full"
    
password_policies:
  linux:
    min_length: 8
    max_age: 90
    complexity: true
```

### Variables de Firewall
```yaml
# En group_vars/all.yml
firewall_config:
  allowed_ports:
    ssh: 22
    http: 80
    https: 443
  
  authorized_networks:
    - "192.168.1.0/24"
    - "127.0.0.1"

network_config:
  dhcp6_enabled: true
  dhcp4_fallback: true
```

---

## 📊 EJEMPLOS DE EJECUCIÓN

### Ejecución por Sistema Operativo
```bash
# Solo sistemas Linux
ansible-playbook setup_usuarios_firewall.yml --limit "academico" --ask-vault-pass

# Solo sistemas Windows  
ansible-playbook setup_usuarios_firewall.yml --limit "gamer" --ask-vault-pass
```

### Ejecución por Funcionalidad
```bash
# Solo configuración de usuarios
ansible-playbook setup_usuarios_firewall.yml --tags "usuarios,grupos,sudo"

# Solo seguridad de red
ansible-playbook setup_usuarios_firewall.yml --tags "firewall,fail2ban"

# Solo antivirus
ansible-playbook setup_usuarios_firewall.yml --tags "antivirus"

# Solo configuración de red
ansible-playbook setup_usuarios_firewall.yml --tags "red,dhcpv6"
```

### Verificación Post-Ejecución
```bash
# Verificar usuarios creados (Linux)
ansible academico -m command -a "id labadmin" --ask-vault-pass

# Verificar firewall (Linux)
ansible academico -m command -a "ufw status verbose" --become --ask-vault-pass

# Verificar antivirus (Linux)
ansible academico -m command -a "systemctl status clamav-daemon" --ask-vault-pass

# Verificar firewall (Windows)
ansible gamer -m ansible.windows.win_shell -a "netsh advfirewall show allprofiles | findstr State" --ask-vault-pass
```

---

## 🔐 SEGURIDAD Y MEJORES PRÁCTICAS

### Variables Sensibles
- Todas las contraseñas deben estar en Ansible Vault
- Usar `no_log: true` en tareas con contraseñas
- Validar configuración sudoers con `visudo -c`

### Validación de Seguridad
- Verificar que SSH no permite root
- Confirmar que fail2ban está activo
- Validar que antivirus está actualizado
- Probar conectividad de red tras cambios

### Troubleshooting
- Logs de UFW: `/var/log/ufw.log`
- Logs de fail2ban: `/var/log/fail2ban.log`
- Logs de ClamAV: `/var/log/clamav/`
- Logs de sudo: `/var/log/sudo.log`

---

**Creado por**: Ansible SO-Lab Project  
**Fecha**: Noviembre 2024  
**Versión**: 2.0  