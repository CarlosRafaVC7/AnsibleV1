# CONFIGURACIÓN MANUAL DE HARDWARE EN ESXi
# =======================================

## 🎯 PASOS EXACTOS PARA MEJORAR HARDWARE

### 1. APAGAR LAS VMs
```
- Ve a ESXi (https://168.121.48.254:10117)
- Apaga "LinuxMint-Academico" y "Windows10-Gamer"
- Espera que estén completamente apagadas
```

### 2. CONFIGURAR LinuxMint-Academico
```
Right-click → Edit Settings

🔧 HARDWARE CHANGES:
┌─────────────────────────────────────┐
│ CPU: 2 cores ✓                     │
│ Memory: 4096 MB ✓                  │
│ Hard disk 1: 40GB ✓               │
│ SCSI Controller: LSI Logic SAS      │ ← CAMBIAR ESTO
│ Network Adapter: VMXNET 3 ✓        │
│ CD/DVD Drive 1: Datastore ISO ✓    │
└─────────────────────────────────────┘

+ ADD DEVICE → USB Controller → USB 3.1
+ ADD DEVICE → Video Card → Configure:
  - Video RAM: 128 MB
  - 3D Graphics: Enable
  - Total Video Memory: 256 MB

🔧 ADVANCED OPTIONS:
Configuration Parameters → Add Configuration Params:
- usb.present = TRUE
- usb_xhci.present = TRUE
- svga.vramSize = 134217728  (128MB en bytes)
```

### 3. CONFIGURAR Windows10-Gamer
```
Right-click → Edit Settings

🔧 HARDWARE CHANGES:
┌─────────────────────────────────────┐
│ CPU: 4 cores ✓                     │
│ Memory: 8192 MB ✓                  │
│ Hard disk 1: 80GB ✓               │
│ SCSI Controller: LSI Logic SAS      │ ← CAMBIAR ESTO
│ Network Adapter: VMXNET 3 ✓        │
│ CD/DVD Drive 1: Datastore ISO ✓    │
└─────────────────────────────────────┘

+ ADD DEVICE → USB Controller → USB 3.1
+ ADD DEVICE → Video Card → Configure:
  - Video RAM: 256 MB
  - 3D Graphics: Enable
  - Total Video Memory: 512 MB

🔧 ADVANCED OPTIONS:
Configuration Parameters → Add Configuration Params:
- usb.present = TRUE
- usb_xhci.present = TRUE  
- svga.vramSize = 268435456  (256MB en bytes)
```

## 🚀 DESPUÉS DE CONFIGURAR HARDWARE:

### 4. ENCENDER Y CONFIGURAR Linux Mint
```
1. Power ON LinuxMint-Academico
2. Instalar Linux Mint (usuario: academico, pass: academico123)
3. Una vez instalado:
   sudo apt update && sudo apt install openssh-server -y
   sudo systemctl enable ssh && sudo systemctl start ssh
   ip addr show  # Anota la IP
```

### 5. ENCENDER Y CONFIGURAR Windows 10
```
1. Power ON Windows10-Gamer  
2. Instalar Windows 10 (usuario: Gamer, pass: gamer123)
3. Una vez instalado:
   - Abrir PowerShell como Admin
   - Enable-PSRemoting -Force
   - winrm quickconfig -y
   - Anota la IP desde ipconfig
```

## ✅ VERIFICACIONES FINALES:
- ✅ SCSI Controller: LSI Logic SAS en ambas
- ✅ USB 3.1: Habilitado en ambas  
- ✅ Video RAM: 128MB (Mint) / 256MB (Windows)
- ✅ SSH: Funcionando en Mint
- ✅ WinRM: Funcionando en Windows