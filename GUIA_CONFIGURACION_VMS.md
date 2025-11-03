# GUÍA: CONFIGURAR USUARIO EN LINUX MINT
# ====================================

## 🐧 LINUX MINT - CREACIÓN DE USUARIO

### Paso 1: Acceso inicial
- Usuario: `mint` (usuario temporal)
- Contraseña: (vacía o `mint`)

### Paso 2: Abrir Terminal
```bash
# Ctrl+Alt+T para abrir terminal

# Crear usuario permanente
sudo adduser academico
# Contraseña sugerida: academico123

# Agregar a grupos importantes
sudo usermod -aG sudo,adm,dialout,cdrom,floppy,audio,dip,video,plugdev,netdev academico

# Verificar usuario creado
id academico
```

### Paso 3: Configurar SSH
```bash
# Instalar SSH server
sudo apt update
sudo apt install openssh-server -y

# Habilitar SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# Verificar status
sudo systemctl status ssh

# Ver IP de la máquina
ip addr show
```

### Paso 4: Configurar red estática (opcional)
```bash
# Editar conexión de red
sudo nano /etc/netplan/01-netcfg.yaml

# Contenido sugerido:
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: no
      addresses: [192.168.1.100/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]

# Aplicar configuración
sudo netplan apply
```

## 🪟 WINDOWS 10 - CONFIGURACIÓN INICIAL

### Paso 1: Instalación básica
- Usuario: `Gamer`
- Contraseña: `gamer123`
- Configurar como cuenta local (no Microsoft)

### Paso 2: Habilitar WinRM
```powershell
# Ejecutar como Administrador
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
```

### Paso 3: Configurar red
- IP estática: 192.168.1.101
- Gateway: 192.168.1.1
- DNS: 8.8.8.8, 8.8.4.4