# SO-Ansible (Hybrid) v1.1

Proyecto Ansible para administración híbrida de infraestructura con soporte para:
- **ESXi/VMware** - Creación de VMs base
- **VirtualBox** - Desarrollo local  
- **Linux/Windows/macOS** - Configuración multiplataforma
- **IPv6 + IPv4** - Red dual stack

## 🏗️ Arquitectura del Proyecto

### Fase 1: Infraestructura (Automatizada)
- Creación de VMs base en ESXi o VirtualBox
- Configuración de hardware y red básica

### Fase 2: Instalación OS (Manual)
- Instalación de sistemas operativos
- Configuración inicial de usuarios y conectividad

### Fase 3: Configuración (Automatizada)
- Gestión de servicios y aplicaciones
- Configuración avanzada de red IPv6
- Administración de usuarios y seguridad

## 📁 Estructura del Proyecto

```
AnsibleV1/
├── playbooks/
│   ├── main.yml                    # Playbook principal
│   └── infrastructure/
│       └── esxi_create.yml         # Creación de VMs en ESXi
├── roles/
│   ├── infrastructure/             # Creación de VMs
│   ├── linux/                     # Configuración Linux/Ubuntu
│   ├── windows/                   # Configuración Windows
│   └── macos/                     # Configuración macOS
├── inventory/
│   └── hosts.ini                  # Inventario de hosts
├── group_vars/                    # Variables por grupos
├── templates/                     # Plantillas de configuración
└── docs/
    └── INSTALACION_MANUAL.md      # Guía de instalación manual
```

## 🚀 Ejecución del Proyecto

### Fase 1: Creación de VMs Base (Automatizada)
```bash
# Crear VMs base en ESXi
ansible-playbook playbooks/infrastructure/esxi_create.yml
```

### Fase 2: Instalación Manual de OS (Manual)
📋 **Seguir la guía:** [docs/INSTALACION_MANUAL.md](docs/INSTALACION_MANUAL.md)

Esta fase incluye:
- Instalación de Ubuntu Server 24.04 LTS  
- Instalación de Windows 11 Pro
- Configuración de red y SSH/WinRM
- Actualización de inventario con IPs reales

### Fase 3: Configuración Automatizada (Ansible)
```bash
# Una vez completada la instalación manual
ansible-playbook playbooks/main.yml

# Configuración específica por tags
ansible-playbook playbooks/main.yml --tags "network,users"

# Solo sistemas Linux
ansible-playbook playbooks/main.yml --limit linux

# Solo sistemas Windows  
ansible-playbook playbooks/main.yml --limit windows
```

## ⚙️ Configuración Inicial

### 1. Preparar entorno
```bash
# Activar entorno virtual
source .venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Instalar collections
ansible-galaxy collection install -r requirements.yml
```

### 2. Configurar inventario
Editar `inventory/hosts.ini` con las IPs reales después de la instalación manual:

```ini
[academico]
192.168.1.100 ansible_user=ansible

[gamer]  
192.168.1.101 ansible_user=Administrador ansible_connection=winrm
```

### 3. Probar conectividad
```bash
# Linux
ansible academico -m ping

# Windows
ansible gamer -m win_ping
```

## 🌐 Características de Red

- **IPv6 preferido** con fallback IPv4
- **DNS dual stack** (Google DNS IPv6/IPv4)
- **Configuración automática** de netplan (Linux) y PowerShell (Windows)
- **Plantillas personalizables** para diferentes topologías

## 📋 Laboratorios Incluidos

### Laboratorio Académico (Linux)
- **OS**: Ubuntu Server 24.04 LTS
- **Servicios**: SSH, Docker, nginx
- **Red**: IPv6 estática + IPv4 DHCP
- **Usuario**: ansible (sudo sin contraseña)

### Laboratorio Gamer (Windows)  
- **OS**: Windows 11 Pro
- **Servicios**: WinRM, IIS, Hyper-V
- **Red**: IPv6 estática + IPv4 DHCP
- **Usuario**: Administrador

### Laboratorio Testing (macOS)
- **OS**: macOS Mojave (opcional)
- **Servicios**: SSH, homebrew
- **Red**: IPv6 + IPv4
- **Usuario**: admin

## 🔧 Herramientas de Validación

```bash
# Validar sintaxis
./validate_project.sh

# Verificar estructura
ansible-playbook --syntax-check playbooks/main.yml

# Modo dry-run
ansible-playbook playbooks/main.yml --check
```

## 📚 Documentación

- [Instalación Manual de OS](docs/INSTALACION_MANUAL.md)
- [Configuración de Red IPv6](templates/README.md)
- [Roles y Variables](group_vars/README.md)

## 💡 Mejores Prácticas

Como recomienda el **Ing. Paulo**:
1. **Ansible NO debe** automatizar instalación de OS
2. **Usar templates** para VMs configuradas
3. **Automatizar configuración** post-instalación
4. **Documentar pasos manuales** claramente

---

**Proyecto desarrollado para el curso de Sistemas Operativos**  
**Universidad Peruana Unión - Facultad de Ingeniería**
