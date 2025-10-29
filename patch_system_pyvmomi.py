#!/usr/bin/env python3
"""
Patch definitivo para PyVmomi en Python 3.12
Reemplaza la asignación problemática con una función compatible
"""
import os
import re

def patch_system_pyvmomi():
    """Aplicar patch al PyVmomi del sistema"""
    file_path = "/usr/lib/python3/dist-packages/pyVmomi/SoapAdapter.py"
    
    if not os.path.exists(file_path):
        print(f"❌ Archivo no encontrado: {file_path}")
        return False
    
    print(f"🔧 Aplicando patch a {file_path}")
    
    # Leer el archivo
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Buscar la línea problemática
    pattern = r'^\s*_SocketWrapper = ssl\.wrap_socket\s*$'
    
    # Definir el reemplazo
    replacement = '''# Compatibility wrapper for Python 3.12+ (ssl.wrap_socket removed)
if hasattr(ssl, 'wrap_socket'):
    _SocketWrapper = ssl.wrap_socket
else:
    def _SocketWrapper(sock, keyfile=None, certfile=None, server_side=False,
                       cert_reqs=ssl.CERT_NONE, ssl_version=None, ca_certs=None,
                       do_handshake_on_connect=True, suppress_ragged_eofs=True,
                       ciphers=None, server_hostname=None):
        """Wrapper compatible para ssl.wrap_socket en Python 3.12+"""
        context = ssl.create_default_context()
        context.check_hostname = False
        context.verify_mode = cert_reqs
        
        if certfile and keyfile:
            context.load_cert_chain(certfile, keyfile)
        elif certfile:
            context.load_cert_chain(certfile)
        
        if ca_certs:
            context.load_verify_locations(ca_certs)
        
        if ciphers:
            context.set_ciphers(ciphers)
        
        return context.wrap_socket(
            sock, server_side=server_side,
            do_handshake_on_connect=do_handshake_on_connect,
            suppress_ragged_eofs=suppress_ragged_eofs,
            server_hostname=server_hostname
        )'''
    
    # Aplicar reemplazo
    new_content = re.sub(pattern, replacement, content, flags=re.MULTILINE)
    
    if new_content != content:
        # Escribir archivo modificado
        with open(file_path, 'w') as f:
            f.write(new_content)
        print("✅ Patch aplicado exitosamente")
        return True
    else:
        print("⚠️  Línea no encontrada o ya patcheada")
        return False

if __name__ == "__main__":
    success = patch_system_pyvmomi()
    
    if success:
        print("🧪 Probando importación...")
        try:
            import pyVmomi
            print("✅ PyVmomi se importa correctamente")
        except Exception as e:
            print(f"❌ Error al importar PyVmomi: {e}")
    else:
        print("❌ No se pudo aplicar el patch")