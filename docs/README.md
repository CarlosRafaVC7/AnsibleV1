# 🧠 SO-Ansible (Hybrid) — Documentación Completa (v1.1)

## Descripción del Proyecto

SO-Ansible (Hybrid) es un proyecto de automatización orientado a la **administración integral de laboratorios virtuales híbridos** desplegados tanto en entornos on-premise (ESXi/VirtualBox) como en entornos locales.

Este proyecto aplica principios de **Infraestructura como Código (IaC)** y **Configuración Automatizada** en dos etapas claramente diferenciadas:

**Etapa 1 — Infraestructura:**
- Creación y despliegue de máquinas virtuales (VMs) base en VMware ESXi y VirtualBox
- Incluye definición de hardware, red y asignación de ISOs de instalación

**Etapa 2 — Configuración:**
- Una vez instalados los sistemas operativos en las VMs, Ansible se conecta a cada uno para realizar la automatización completa (configuración de red, usuarios, permisos, tareas, y monitoreo)

## Arquitectura General

| Componente | Descripción |
|------------|-------------|
| **Nodo de Control** | Ansible ejecutándose en WSL o Ubuntu local |
| **Infraestructura Virtual** | VMs en ESXi (remoto) o VirtualBox (local) |
| **Laboratorio Académico** | Linux Ubuntu / Linux Mint |
| **Laboratorio Gamer** | Windows 11 Pro |
| **VM de Testing** | macOS Mojave (solo en VirtualBox local) |

### Características Principales

✅ **Infraestructura como Código (IaC)** – VMs reproducibles en ESXi/VirtualBox  
✅ **Automatización por Etapas** – Separación entre despliegue y configuración  
✅ **Soporte IPv6 nativo** con fallback IPv4  
✅ **Multi-Plataforma**: Linux, Windows, macOS  
✅ **Seguridad**: SSH y WinRM  
✅ **Monitoreo activo** de CPU, memoria y disco  
✅ **Idempotencia garantizada**: los playbooks pueden re-ejecutarse sin efectos colaterales

## Estructura del Proyecto

```
AnsibleV1/
├── ansible.cfg                 # Configuración principal
├── requirements.yml            # Collections necesarias
├── inventory/
│   └── hosts.ini              # Inventario con soporte IPv6
├── group_vars/                # Variables por grupo
│   ├── all.yml
│   ├── academico.yml
│   ├── gamer.yml
│   └── macos_test.yml
├── host_vars/                 # Variables específicas por host
├── playbooks/
│   ├── main.yml              # Playbook principal
│   └── infrastructure/       # Creación de VMs
│       ├── esxi_create.yml
│       └── virtualbox_create.yml
├── roles/
│   ├── infrastructure/       # Gestión de infraestructura
│   ├── linux/               # Administración Linux
│   ├── windows/             # Administración Windows
│   └── macos/               # Administración macOS
├── templates/               # Templates de configuración
│   ├── netplan_config.yml.j2
│   └── windows_ipv6_config.ps1.j2
├── tests/                   # Playbooks de validación
│   ├── validate_connectivity.yml
│   └── validate_configuration.yml
└── docs/                    # Documentación
    └── README.md
```

## Estructura del Proyecto

```
AnsibleV1/
├── ansible.cfg                 # Configuración principal
├── requirements.yml            # Collections necesarias
├── inventory/
│   └── hosts.ini              # Inventario con soporte IPv6
├── group_vars/                # Variables por grupo
│   ├── all.yml
│   ├── academico.yml
│   ├── gamer.yml
│   └── macos_test.yml
├── host_vars/                 # Variables específicas por host
├── playbooks/
│   ├── main.yml              # Playbook principal
│   └── infrastructure/       # Creación de VMs
│       ├── esxi_create.yml
│       └── virtualbox_create.yml
├── roles/
│   ├── infrastructure/       # Gestión de infraestructura
│   ├── linux/               # Administración Linux
│   ├── windows/             # Administración Windows
│   └── macos/               # Administración macOS
├── templates/               # Templates de configuración
│   ├── netplan_config.yml.j2
│   └── windows_ipv6_config.ps1.j2
├── tests/                   # Playbooks de validación
│   ├── validate_connectivity.yml
│   └── validate_configuration.yml
└── docs/                    # Documentación
    └── README.md
```

## Instalación y Configuración Inicial

### 1. Requisitos Previos

```bash
# En el nodo de control (WSL/Ubuntu)
sudo apt update
sudo apt install ansible python3-pip

# Instalar collections
ansible-galaxy collection install -r requirements.yml

# Instalar dependencias Python
pip3 install pyvmomi pywinrm
```

### 2. Configuración de Credenciales

**Para ESXi (editar antes de usar):**
```yaml
# En playbooks/infrastructure/esxi_create.yml
esxi_host: "TU_IP_ESXI:443"
esxi_user: "root"
esxi_pass: "TU_PASSWORD"  # TODO: Mover a ansible-vault
```

**Para VMs (actualizar IPs reales):**
```ini
# En inventory/hosts.ini
[academico]
2001:db8:1::100 ansible_user=mint ansible_ssh_private_key_file=~/.ssh/id_ed25519_ansible

[gamer]
2001:db8:1::101 ansible_user=Administrador ansible_password='TU_PASSWORD' ansible_connection=winrm
```

## 🚀 Flujo Operativo (Etapas)

### 🏗️ Etapa 1 — Infraestructura (Creación de VMs)

**Objetivo:** crear y levantar las VMs base en ESXi o VirtualBox con sus parámetros definidos.

#### Opción A: ESXi
```bash
# 1. Crear VMs vacías en ESXi
ansible-playbook playbooks/infrastructure/esxi_create.yml

# 2. Instalar manualmente los SOs en vSphere Client (Ubuntu, Mint, Win11)

# 3. Configurar IPs IPv6 en cada VM
# 4. Actualizar inventory/hosts.ini con las IPs reales
```

#### Opción B: VirtualBox (local)
```bash
# 1. Crear VMs en VirtualBox
ansible-playbook playbooks/infrastructure/virtualbox_create.yml

# 2. Iniciar desde VirtualBox Manager e instalar manualmente los SOs

# 3. Configurar red Host-Only con IPv6
# 4. Actualizar inventory/hosts.ini
```

> 🧩 **En esta etapa Ansible solo crea la infraestructura, pero aún no entra a las VMs.**

### ⚙️ Etapa 2 — Configuración (Automatización de SOs)

**Objetivo:** aplicar la configuración automatizada en cada sistema operativo ya instalado.

```bash
# 1. Validar conectividad
ansible-playbook tests/validate_connectivity.yml

# 2. Configurar automáticamente los sistemas
ansible-playbook playbooks/main.yml

# 3. Validar la configuración final
ansible-playbook tests/validate_configuration.yml
```

## 🌐 Configuración de Red IPv6

### Linux (Ubuntu/Mint)

```yaml
# /etc/netplan/01-ansible.yaml
network:
  version: 2
  ethernets:
    ens33:
      addresses:
        - 2001:db8:1::100/64
        - 192.168.18.28/24
      gateway6: 2001:db8:1::1
      gateway4: 192.168.18.1
```

```bash
sudo netplan apply
```

### Windows

```powershell
New-NetIPAddress -InterfaceIndex X -IPAddress "2001:db8:1::101" -PrefixLength 64
New-NetRoute -DestinationPrefix "::/0" -NextHop "2001:db8:1::1"
```

### macOS

```bash
sudo networksetup -setv6manual "Wi-Fi" 2001:db8:1::102 64 2001:db8:1::1
```

## 🩺 Troubleshooting

### Conectividad SSH (Linux/macOS)
```bash
sudo systemctl status ssh
sudo ufw allow 22
ansible academico -m ping
```

### Conectividad WinRM (Windows)
```powershell
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
ansible gamer -m win_ping
```

### Collections faltantes
```bash
ansible-galaxy collection install community.vmware community.windows community.crypto
```

## 🧩 Comandos de Diagnóstico
```bash
ansible all -m ping
ansible academico -m command -a "ip addr show"
ansible gamer -m ansible.windows.win_shell -a "ipconfig /all"
ansible-inventory --host academico --yaml
```

## 📊 Monitoreo y Logs

| Sistema | Ruta de logs |
|---------|--------------|
| **Linux** | `/var/log/ansible_monitor/` |
| **Windows** | `C:\ansible_monitor\` |
| **macOS** | `/var/log/ansible_monitor/` |

## Instalación y Configuración Inicial

### 1. Requisitos Previos

```bash
# En el nodo de control (WSL/Ubuntu)
sudo apt update
sudo apt install ansible python3-pip

# Instalar collections
ansible-galaxy collection install -r requirements.yml

# Instalar dependencias Python
pip3 install pyvmomi pywinrm
```

### 2. Configuración de Credenciales

**Para ESXi (editar antes de usar):**
```yaml
# En playbooks/infrastructure/esxi_create.yml
esxi_host: "TU_IP_ESXI:443"
esxi_user: "root"
esxi_pass: "TU_PASSWORD"  # TODO: Mover a ansible-vault
```

**Para VMs (actualizar IPs reales):**
```ini
# En inventory/hosts.ini
[academico]
2001:db8:1::100 ansible_user=mint ansible_ssh_private_key_file=~/.ssh/id_ed25519_ansible

[gamer]
2001:db8:1::101 ansible_user=Administrador ansible_password='TU_PASSWORD' ansible_connection=winrm
```

## Próximos Pasos (TODO)

- [ ] Implementar ansible-vault para credenciales
- [ ] Añadir CI/CD con GitHub Actions
- [ ] Crear roles para backup automático
- [ ] Implementar inventario dinámico
- [ ] Añadir soporte para Docker containers

## Soporte

Para issues y preguntas:
1. Verificar logs de Ansible: `ansible-playbook -vvv`
2. Ejecutar tests de conectividad
3. Revisar configuración de red
4. Consultar documentación de modules específicos

---

**Proyecto SO-Ansible (Hybrid) v1.1**  
Automatización de laboratorios virtuales multi-plataforma con soporte IPv6