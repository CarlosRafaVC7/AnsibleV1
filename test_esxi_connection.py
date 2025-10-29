#!/usr/bin/env python3
"""
Script de prueba rápida de conectividad ESXi
Verifica que podemos conectarnos antes de ejecutar Ansible
"""

from pyVim.connect import SmartConnect, Disconnect
from pyVmomi import vim
import ssl
import atexit

def test_esxi_connection():
    # Configuración ESXi (misma que en Ansible)
    esxi_host = "168.121.48.254"
    esxi_port = 10121
    esxi_user = "root"
    esxi_pass = "qwe123$"
    
    print(f"🔌 Probando conexión a ESXi: {esxi_host}:{esxi_port}")
    
    try:
        # Crear contexto SSL que ignore certificados
        context = ssl.create_default_context()
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
        
        # Conectar a ESXi
        service_instance = SmartConnect(
            host=esxi_host,
            port=esxi_port,
            user=esxi_user,
            pwd=esxi_pass,
            sslContext=context
        )
        
        # Registrar desconexión automática
        atexit.register(Disconnect, service_instance)
        
        # Obtener información básica
        content = service_instance.RetrieveContent()
        host_view = content.viewManager.CreateContainerView(
            content.rootFolder, [vim.HostSystem], True
        )
        
        for host in host_view.view:
            print(f"✅ Conectado exitosamente a: {host.name}")
            print(f"   Version: {host.config.product.fullName}")
            print(f"   Datastores: {[ds.name for ds in host.datastore]}")
            break
            
        host_view.Destroy()
        return True
        
    except Exception as e:
        print(f"❌ Error de conexión: {e}")
        return False

if __name__ == "__main__":
    success = test_esxi_connection()
    exit(0 if success else 1)