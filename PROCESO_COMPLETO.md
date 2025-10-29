## 🚀 EJECUCIÓN PASO A PASO - Proceso Completo

### 🔧 **FASE MANUAL (Haz ahora):**

#### 1. **Verificar VMs creadas** ✅
```bash
# Ya ejecutado exitosamente:
python create_vms_simple.py
# ✅ Ubuntu-Academico: 4GB RAM, 2 CPU
# ✅ Windows-Gamer: 8GB RAM, 4 CPU
```

#### 2. **Completar en ESXi Host Client:**
**URL:** https://168.121.48.254:443 | **User:** root | **Pass:** qwe123$

**Ubuntu-Academico:**
- [ ] Agregar disco: 40GB, thin provisioned
- [ ] Agregar red: VM Network (vmxnet3)  
- [ ] Montar ISO: Ubuntu 24.04 LTS
- [ ] Encender VM

**Windows-Gamer:**
- [ ] Agregar disco: 80GB, thin provisioned
- [ ] Agregar red: VM Network (vmxnet3)
- [ ] Montar ISO: Windows 11 Pro
- [ ] Encender VM

#### 3. **Instalar OS y configurar:**
**Ubuntu Setup:**
- Usuario: `ansible`
- Password: `Upeu2025#`
- Habilitar SSH server
- Configurar IP (anotar para inventory)

**Windows Setup:**
- Usuario: `Administrador`  
- Password: `Upeu2025#`
- Habilitar WinRM
- Configurar IP (anotar para inventory)

#### 4. **Actualizar inventory/hosts.ini:**
```ini
[academico]
192.168.X.X ansible_user=ansible

[gamer]  
192.168.X.X ansible_user=Administrador ansible_connection=winrm
```

#### 5. **Probar conectividad:**
```bash
ansible academico -m ping
ansible gamer -m win_ping
```

---

### 🤖 **FASE ANSIBLE (Automática después):**

Una vez completada la fase manual, Ansible automatizará:

#### **Ubuntu (playbooks/main.yml):**
- [ ] Configuración IPv6 + IPv4
- [ ] Instalación Docker, nginx
- [ ] Configuración usuarios y SSH
- [ ] Servicios del sistema
- [ ] Tareas programadas
- [ ] Configuración de almacenamiento

#### **Windows (playbooks/main.yml):**
- [ ] Configuración IPv6 + IPv4
- [ ] Instalación IIS, Hyper-V
- [ ] Configuración usuarios y WinRM
- [ ] Servicios Windows
- [ ] Tareas programadas
- [ ] Configuración de almacenamiento

#### **Comando final:**
```bash
ansible-playbook playbooks/main.yml
```

---

### 📊 **RESULTADO FINAL:**

✅ **Infraestructura completa automatizada**
✅ **Configuración IPv6/IPv4**  
✅ **Servicios y aplicaciones instaladas**
✅ **Usuarios y seguridad configurados**
✅ **Sistema listo para producción**

---

### 🎯 **SIGUIENTE ACCIÓN:**
**Accede ahora a:** https://168.121.48.254:443
**Y completa la configuración hardware de las VMs**