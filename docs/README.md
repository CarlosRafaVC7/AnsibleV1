# SO-Ansible (Hybrid) - Documentación Completa

## Descripción del Proyecto

SO-Ansible (Hybrid) es un proyecto de automatización para la administración de laboratorios virtuales híbridos que soporta:

- **Laboratorio Académico**: Linux Ubuntu/Mint (VirtualBox/ESXi)
- **Laboratorio Gamer**: Windows 11 Pro (VirtualBox/ESXi)  
- **VM de Testing**: macOS Mojave (VirtualBox)

### Características Principales

✅ **Infraestructura como Código**: Creación automática de VMs en VMware ESXi y VirtualBox
✅ **Soporte IPv6**: Configuración preferencial IPv6 con fallback IPv4
✅ **Multi-Plataforma**: Linux, Windows y macOS
✅ **Seguridad**: Uso de claves SSH, WinRM configurado correctamente
✅ **Monitoreo**: Jobs automáticos de sistema y recursos
✅ **Idempotencia**: Playbooks ejecutables múltiples veces

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

## Flujo de Uso

### Opción A: Infraestructura ESXi

```bash
# 1. Crear VMs en ESXi
ansible-playbook playbooks/infrastructure/esxi_create.yml

# 2. Completar instalación de OS manualmente en vSphere Client

# 3. Configurar red IPv6 en cada VM

# 4. Actualizar inventory/hosts.ini con IPs reales

# 5. Validar conectividad
ansible-playbook tests/validate_connectivity.yml

# 6. Configurar VMs automáticamente
ansible-playbook playbooks/main.yml

# 7. Validar configuración final
ansible-playbook tests/validate_configuration.yml
```

### Opción B: Infraestructura VirtualBox

```bash
# 1. Crear VMs en VirtualBox
ansible-playbook playbooks/infrastructure/virtualbox_create.yml

# 2. Iniciar VMs desde VirtualBox Manager

# 3. Completar instalación de OS

# 4. Configurar red Host-Only con IPv6

# 5. Actualizar inventory/hosts.ini

# 6. Continuar con pasos 5-7 de la Opción A
```

## Configuración de Red IPv6

### Linux (Ubuntu/Mint)

El proyecto genera automáticamente configuración netplan:

```yaml
# /etc/netplan/01-ansible.yaml
network:
  version: 2
  ethernets:
    ens33:
      addresses:
        - 2001:db8:1::100/64
        - 192.168.18.28/24  # fallback
      gateway6: 2001:db8:1::1
      gateway4: 192.168.18.1
```

Aplicar con:
```bash
sudo netplan apply
```

### Windows

Ejecutar script PowerShell generado:
```powershell
# Configuración automática de IPv6
New-NetIPAddress -InterfaceIndex X -IPAddress "2001:db8:1::101" -PrefixLength 64
New-NetRoute -DestinationPrefix "::/0" -NextHop "2001:db8:1::1"
```

### macOS

```bash
# Configuración manual
sudo networksetup -setv6manual "Wi-Fi" 2001:db8:1::102 64 2001:db8:1::1
```

## Troubleshooting

### Problemas Comunes

**SSH no funciona (Linux/macOS):**
```bash
# Verificar servicio
sudo systemctl status ssh
sudo systemctl start ssh

# Verificar puerto
sudo ufw allow 22

# Test de conectividad
ansible academico -m ping
```

**WinRM no funciona (Windows):**
```powershell
# Configurar WinRM
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

# Verificar listener
winrm enumerate winrm/config/listener

# Test de conectividad
ansible gamer -m win_ping
```

**Collections faltantes:**
```bash
# Instalar collections requeridas
ansible-galaxy collection install community.vmware
ansible-galaxy collection install community.windows
ansible-galaxy collection install community.crypto
```

### Comandos de Diagnóstico

```bash
# Verificar conectividad general
ansible all -m ping

# Verificar facts de un host específico
ansible -m setup HOSTNAME

# Ejecutar command ad-hoc
ansible academico -m command -a "ip addr show"
ansible gamer -m ansible.windows.win_shell -a "ipconfig /all"

# Ver variables de un host
ansible-inventory --host HOSTNAME --yaml
```

## Archivos de Logs y Monitoreo

### Linux
- Logs de monitoreo: `/var/log/ansible_monitor/`
- Memoria: `/var/log/ansible_monitor/memoria.log`
- Disco: `/var/log/ansible_monitor/df.log`

### Windows
- Logs de monitoreo: `C:\ansible_monitor\`
- CPU: `C:\ansible_monitor\cpu.txt`

### macOS
- Logs de monitoreo: `/var/log/ansible_monitor/`
- Script monitor: `/Users/Shared/lab_shared/system_monitor.sh`

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

**Proyecto SO-Ansible (Hybrid) v1.0**
Automatización de laboratorios virtuales multi-plataforma con soporte IPv6