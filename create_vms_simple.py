#!/usr/bin/env python3
"""
Script simple para crear VMs en ESXi
Versión funcional sin complicaciones
"""

from pyVim.connect import SmartConnect, Disconnect
from pyVmomi import vim
import ssl
import atexit

def create_vm_simple(vm_name, memory_mb, num_cpus, guest_id):
    print(f"🖥️  Creando VM {vm_name}...")
    
    # Configuración ESXi
    esxi_host = "168.121.48.254"
    esxi_port = 10121
    esxi_user = "root"
    esxi_pass = "qwe123$"
    
    try:
        # Conectar a ESXi
        context = ssl.create_default_context()
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
        
        si = SmartConnect(
            host=esxi_host,
            port=esxi_port,
            user=esxi_user,
            pwd=esxi_pass,
            sslContext=context
        )
        atexit.register(Disconnect, si)
        
        content = si.RetrieveContent()
        
        # Buscar elementos necesarios
        datacenter = content.rootFolder.childEntity[0]
        vm_folder = datacenter.vmFolder
        
        # Verificar si VM ya existe
        for vm in vm_folder.childEntity:
            if hasattr(vm, 'name') and vm.name == vm_name:
                print(f"✅ VM {vm_name} ya existe")
                return True
        
        # Buscar host y resource pool
        cluster = datacenter.hostFolder.childEntity[0]
        host = cluster.host[0]
        resource_pool = cluster.resourcePool
        datastore = datacenter.datastore[0]
        
        # Configuración mínima de VM
        config_spec = vim.vm.ConfigSpec()
        config_spec.name = vm_name
        config_spec.memoryMB = memory_mb
        config_spec.numCPUs = num_cpus
        config_spec.guestId = guest_id
        
        # Configurar ubicación de archivos
        config_spec.files = vim.vm.FileInfo()
        config_spec.files.vmPathName = f"[{datastore.name}]"
        
        print(f"🔧 Creando VM {vm_name} con {memory_mb}MB RAM y {num_cpus} CPUs...")
        
        # Crear VM
        task = vm_folder.CreateVM_Task(config_spec, resource_pool, host)
        
        # Esperar completación
        while task.info.state in [vim.TaskInfo.State.running, vim.TaskInfo.State.queued]:
            continue
        
        if task.info.state == vim.TaskInfo.State.success:
            print(f"✅ VM {vm_name} creada exitosamente!")
            return True
        else:
            print(f"❌ Error creando VM {vm_name}: {task.info.error}")
            return False
            
    except Exception as e:
        print(f"❌ Error de conexión para {vm_name}: {e}")
        return False

def main():
    print("🚀 Creando VMs básicas en ESXi...")
    print("📝 Nota: Configuración básica sin discos ni red")
    print("🔧 Se agregarán manualmente desde ESXi Host Client")
    print()
    
    results = []
    
    # Crear VM Ubuntu
    ubuntu_ok = create_vm_simple(
        vm_name="Ubuntu-Academico",
        memory_mb=4096,
        num_cpus=2,
        guest_id="ubuntu64Guest"
    )
    results.append(ubuntu_ok)
    
    # Crear VM Windows
    windows_ok = create_vm_simple(
        vm_name="Windows-Gamer", 
        memory_mb=8192,
        num_cpus=4,
        guest_id="windows9_64Guest"
    )
    results.append(windows_ok)
    
    print("\n" + "="*50)
    
    if all(results):
        print("✅ ¡TODAS LAS VMs CREADAS EXITOSAMENTE!")
        print()
        print("📋 PRÓXIMOS PASOS:")
        print("1. 🌐 Acceder a ESXi Host Client: https://168.121.48.254:443")
        print("2. 💾 Agregar discos duros a cada VM manualmente")
        print("3. 🌐 Configurar adaptadores de red")
        print("4. 📀 Montar ISOs de sistemas operativos")
        print("5. 📖 Seguir guía: docs/INSTALACION_MANUAL.md")
        print()
        print("🎯 Las VMs están creadas pero necesitan configuración adicional")
    else:
        print("❌ Hubo errores en la creación de algunas VMs")
        print("🔍 Revisar logs arriba para detalles")
        exit(1)

if __name__ == "__main__":
    main()